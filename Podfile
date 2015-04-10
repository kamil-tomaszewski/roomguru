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
pod 'Alamofire',
    :git => "git@github.com:Alamofire/Alamofire.git",
    :commit => "2ff5749ffc0425f05a1411b5b6fd2c25241b5b14",
    :branch => "xcode-6.3"

pod 'StatefulViewController',
    :git => "git@github.com:aschuch/StatefulViewController.git",
    :commit => "3eaa376eb348d13db99d4b37b2cbcec312a6e73f"

pod 'Async',
    :git => "git@github.com:duemunk/Async.git",
    :commit => "a61663f4469df082ac0b3311d9c4b8cd32185336",
    :branch => "master"

pod 'SwiftyJSON',
    :git => "git@github.com:SwiftyJSON/SwiftyJSON.git",
    :commit => "008a09d7ea8b13c03fb59b35c01aad339584a5e1",
    :branch => "xcode6.3"

pod 'Cartography',
    :git => "git@github.com:robb/Cartography.git",
    :commit => "7467721bb7253899f66e542f1845851032386b7f",
    :branch => "xcode6-3"

pod 'SwiftyUserDefaults',
    :git => "git@github.com:radex/SwiftyUserDefaults.git",
    :commit => "e467e0f712e3ac1d1ceb7f9020ffd02e487e8893",
    :branch => "swift-1.2"

pod 'DateKit',
    :git => "git@github.com:bartoszkopinski/DateKit.git",
    :commit => "63e1b2e07895801f5b27f4a3a5ca74bff919fcbf",
    :branch => "Swift_1_2"

pod 'CryptoSwift',
    :git => "git@github.com:krzyzanowskim/CryptoSwift.git",
    :commit => "6ae8206f06ed0dddbf2721182e6d4232f80698da",
    :branch => "master"

target 'Tests', :exclusive => true do link_with 'Unit Tests', 'Functional Tests'

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
