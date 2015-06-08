#
#  Rakefile
#
#  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
#

task "test-unit" do
  run_xcode_tests "Unit Tests"
end

task "test-functional" do
  run_xcode_tests "Functional Tests"
end

task "build-and-distribute" do
  build_and_distribute
end

################################################################################

def infoplist_path
  ENV["XCODE_INFOPLIST_PATH"]
end

def branch
  ENV["CIRCLE_BRANCH"] || ENV["TRAVIS_BRANCH"]
end

def stable?
  @is_stable ||= %w(beta production).include?(branch)
end

def environment
  if stable?
    'Production'
  else
    'Staging'
  end
end

def bundle_id
  orig_bundle_id ||= ENV["BUNDLE_ID"] || `/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' '#{infoplist_path}'`.strip

  if stable?
    orig_bundle_id
  else
    orig_bundle_id += ".staging"
  end
end

def project_name
  @project_name ||= ENV["PROJECT_NAME"] || `/usr/libexec/PlistBuddy -c 'Print :CFBundleDisplayName' '#{infoplist_path}'`.strip
end

def display_name
  if stable?
    project_name
  else
    project_name + " (staging)"
  end
end

def travis?
  !!ENV["TRAVIS"]
end

def build_dir
  ENV["TRAVIS_BUILD_DIR"] || "#{ENV['HOME']}/#{ENV['CIRCLE_PROJECT_REPONAME']}"
end

def workspace_path
  "#{build_dir}/#{ENV['XCODE_WORKSPACE']}"
end

def build_config
  {
    workspace: workspace_path,
    configuration: environment,
  }
end

def test_config(scheme, sdk_version: "iphonesimulator", configuration: "Test", destination: "platform=iOS Simulator,name=iPhone 5s,OS=8.3")
  build_config.merge(
    scheme: scheme,
    sdk: sdk_version,
    configuration: configuration,
    destination: destination,
  )
end

def xcodebuild_flags hash
  hash.map do |k, v|
    "-#{k} '#{v}' "
  end.join
end

def run_xcode_tests(scheme, in_matrix: true)
  return if in_matrix && stable?

  flags = xcodebuild_flags(test_config(scheme))

  report_info "Running tests in scheme '#{scheme}', this may take a while..."

  sh "xcodebuild #{flags} test | tee $CIRCLE_ARTIFACTS/xcodebuild_raw.log | xcpretty -c ; exit ${PIPESTATUS[0]}"

  report_failure "Application #{scheme} failed", $?.exitstatus unless $?.success?
end

def build_number
  ENV["CIRCLE_BUILD_NUM"] || ENV["TRAVIS_BUILD_NUMBER"]
end

def set_bundle_params
  report_info "Setting 'CFBundleVersion' in '#{infoplist_path}' to '#{build_number}'"
  sh "/usr/libexec/PlistBuddy -c 'Set :CFBundleVersion #{build_number}' '#{infoplist_path}'"

  report_info "Setting 'CFBundleIdentifier' in '#{infoplist_path}' to '#{bundle_id}'"
  sh "/usr/libexec/PlistBuddy -c 'Set :CFBundleIdentifier #{bundle_id}' '#{infoplist_path}'"

  report_info "Setting 'CFBundleDisplayName' in '#{infoplist_path}' to '#{infoplist_path}'"
  sh "/usr/libexec/PlistBuddy -c 'Set :CFBundleDisplayName #{display_name}' '#{infoplist_path}'"
end

def testflight_list
  if stable?
    "#{project_name} - Beta"
  else
    "#{project_name} - Staging"
  end
end

def certs_dir
  ENV["CERTS_DIR"]
end

def profile_filename
  @profile_filename ||= File.basename(
    Dir.glob("#{certs_dir}/*.mobileprovision")
      .find{ |p| p.include? environment }
  )
end

def build_and_distribute
  keychain_name = "distribution.keychain"
  keychain_password = "distribution"

  report_info "Creating keychain '#{keychain_name}'"
  sh "security create-keychain -p '#{keychain_password}' '#{keychain_name}'"
  sh "security unlock-keychain -p '#{keychain_password}' '#{keychain_name}'"
  sh "security set-keychain-settings '#{keychain_name}'"
  sh "security default-keychain -s '#{keychain_name}'"

  report_info "Importing authority certificates from '#{certs_dir}'"
  sh "security import '#{certs_dir}/'*.cer -k '#{keychain_name}' -A"

  cert_passphrase = ENV["CERT_PASSPHRASE"]

  report_info "Importing distribution certificates from '#{certs_dir}'"
  masked_sh "security import '#{certs_dir}'/*.p12 -P '#{cert_passphrase}' -k '#{keychain_name}' -A", [cert_passphrase]

  profile_dest_dir = File.expand_path("~/Library/MobileDevice/Provisioning Profiles")

  report_info "Copying profiles from '#{certs_dir}' to '#{profile_dest_dir}'"
  FileUtils.mkdir_p profile_dest_dir
  sh "cp '#{certs_dir}'/*.mobileprovision '#{profile_dest_dir}'"

  profile_path = "#{profile_dest_dir}/#{profile_filename}"

  set_bundle_params

  cert_name = ENV["CERT_NAME"]

  ipa_build_dir = File.expand_path("#{build_dir}/Build")
  ipa_build_flags = []
  ipa_build_flags << "--workspace '#{ENV["XCODE_WORKSPACE"]}'"
  ipa_build_flags << "--scheme '#{project_name}'"
  ipa_build_flags << "--destination '#{ipa_build_dir}'"
  ipa_build_flags << "--embed '#{profile_path}'"
  ipa_build_flags << "--identity '#{cert_name}'"
  ipa_build_flags << "--no-clean"
  ipa_build_flags << "--configuration '#{environment}'"
  ipa_build_flags << "--verbose"

  report_info "Building the application archive, this may take a while..."
  FileUtils.mkdir_p ipa_build_dir
  sh "ipa build #{ipa_build_flags.join(" ")}; exit ${PIPESTATUS[0]}"
  report_failure "Failed to build the application archive", $?.exitstatus unless $?.success?

  FileUtils.cd ipa_build_dir do

    hockeyapp_release_number = ENV["TRAVIS_BUILD_NUMBER"]
    hockeyapp_release_date = Time.new.strftime("%Y-%m-%d %H:%M:%S")
    hockeyapp_release_notes = "Build: #{hockeyapp_release_number}\nUploaded: #{hockeyapp_release_date}"

    hockeyapp_api_token = ENV["HOCKEYAPP_API_TOKEN"]
    ipa_distribute_flags = []
    ipa_distribute_flags << "-a '#{hockeyapp_api_token}'"
    ipa_distribute_flags << "--notes '#{hockeyapp_release_notes}'"

    report_info "Uploading the application archive to Hockeyapp, this may take a while..."
    masked_sh "ipa distribute:hockeyapp #{ipa_distribute_flags.join(" ")}; exit ${PIPESTATUS[0]}", [hockeyapp_api_token]
    report_failure "Failed to upload the application archive to Hockeyapp", $?.exitstatus unless $?.success?


  end
end

def masked_sh(command, masked_strings)
  masked_command = command
  masked_strings.each do |masked_string|
    masked_command = masked_command.sub(masked_string, "[secure]")
  end
  puts masked_command
  system command
end

def report_error(message)
  report_common message, 1
end

def report_success(message)
  report_common message, 2
end

def report_info(message)
  report_common message, 3
end

def report_failure(message, status = 1)
  report_error message
  exit status
end

def report_common(message, color)
  color_formatter = `tput setaf #{color}`
  reset_formatter = `tput sgr 0`
  puts "#{color_formatter}#{message}#{reset_formatter}\n"
end
