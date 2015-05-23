platform :ios, 6.1
pod 'HYUtils', :git => 'https://github.com/hrk-ys/HYUtils.git', :commit => '806679b2773695602825a57ff1d7b8edb4e63bdb'
pod 'Parse', '1.7.3'
pod 'ParseUI', '1.1.3'
pod 'FontAwesomeKit', '1.1.3'
pod 'SDWebImage', '~>3.7'
pod 'SVProgressHUD', '1.0'
pod 'Helpshift', '4.2.0'
pod 'Mixpanel', '2.3.2'
pod 'GoogleAnalytics-iOS-SDK'
pod 'Google-Mobile-Ads-SDK'

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods/Pods-Acknowledgements.plist', 'DeskSlide/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
