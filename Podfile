source 'https://github.com/CocoaPods/Specs.git'

xcodeproj 'fh-ios-sdk.xcodeproj'
platform :ios, '7.0'

pod 'ASIHTTPRequest/Core', '1.8.2'
# tobe removed once PR merged in master + 1.1.0-beta2 is pushed to cocoapods
pod 'AeroGear-Push', :git => 'git@github.com:corinnekrych/aerogear-ios-push.git', :branch => 'objc.store.device.token' 

target 'FHTests', :exclusive => true do
    pod 'ASIHTTPRequest/Core', '1.8.2'
end
