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

pod 'AFNetworking', '~> 2.5.2'

pod 'Alamofire', '~> 1.2.0'

pod 'Async',
    :git => "https://github.com/duemunk/Async.git",
    :tag => "1.2.1"

pod 'SwiftyJSON', '~> 2.2.0'

pod 'Cartography', '~> 0.5.0'

pod 'CryptoSwift',
    :git => "https://github.com/krzyzanowskim/CryptoSwift.git",
    :tag => "0.0.11"

pod 'AKPickerView-Swift', '~> 0.2.1'

pod 'SwiftyUserDefaults', '~> 1.1.0'

#pod 'PKHUD', '~> 2.0.1' - Latest Pod is not compiling in Xcode 6.3
pod 'PKHUD',
    :git => "https://github.com/pkluz/PKHUD.git",
    :commit => "86f3f342a6d83b124a8de4ed31f0ffda1ad3aeaa",
    :branch => "master"

pod 'DateKit',
    :git => "https://github.com/SnowdogApps/DateKit.git",
    :commit => "4c953cf5a70a14f88d154bdfd710019f20a10b49",
    :branch => "master"

pod 'FontAwesomeIconFactory', '~> 2.0'

target 'Tests' do link_with 'Unit Tests', 'Functional Tests'

    pod 'KIF', '~> 3.0',
        :configurations => ['Test']

    pod 'Quick', '~> 0.3.1',
        :configurations => ['Test']

    pod 'Nimble', '~> 0.4.2',
        :configurations => ['Test']
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
