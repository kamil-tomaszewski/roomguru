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
        :configurations => ['Test']
        
    pod 'Nimble',
        :configurations => ['Test'],
        git: 'git@github.com:Quick/Nimble.git',
        branch: 'swift-1.1' #version 0.4.0+ is available only for Swift 1.2+
end
