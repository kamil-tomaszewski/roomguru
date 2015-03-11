#
#  Podfile
#
#  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
#

# Pod sources
source 'https://github.com/CocoaPods/Specs.git'

# Initial configuration
platform :ios, '8.0'
inhibit_all_warnings!
use_frameworks!

xcodeproj 'Roomguru', 'Development' => :debug, 'Production' => :release, 'Staging' => :release, 'Test' => :debug

pod 'Alamofire', '~> 1.1'
pod 'SwiftyJSON', '~> 2.1.3'

target 'Tests', :exclusive => true do link_with 'Unit Tests', 'Functional Tests'

    pod 'KIF', '~> 3.0',
        :configurations => ['Test']

    pod 'Quick',
        :configurations => ['Test'],
      	git: 'git@github.com:Quick/Quick.git',
      	branch: 'swift-1.1' #version 0.3.0+ is available only for Swift 1.2+

    pod 'Nimble',
        :configurations => ['Test'],
        git: 'git@github.com:Quick/Nimble.git',
        branch: 'swift-1.1' #version 0.4.0+ is available only for Swift 1.2+
end

post_install do |installer|

    puts 'Setting appropriate code signing identities'
    installer.project.targets.each { |target|
        {
            'iPhone Developer' => ['Debug', 'Development', 'Test'],
            'iPhone Distribution' => ['Release', 'Staging', 'Production'],
        }.each { |value, configs|
            target.set_build_setting('CODE_SIGN_IDENTITY[sdk=iphoneos*]', value, configs)
        }
    }

end

class Xcodeproj::Project::Object::PBXNativeTarget

    def set_build_setting setting, value, config = nil
        unless config.nil?
            if config.kind_of?(Xcodeproj::Project::Object::XCBuildConfiguration)
                config.build_settings[setting] = value
                elsif config.kind_of?(String)
                build_configurations
                .select { |config_obj| config_obj.name == config }
                .each { |config| set_build_setting(setting, value, config) }
                elsif config.kind_of?(Array)
                config.each { |config| set_build_setting(setting, value, config) }
                else
                raise 'Unsupported configuration type: ' + config.class.inspect
            end
            else
            set_build_setting(setting, value, build_configurations)
        end
    end

end
