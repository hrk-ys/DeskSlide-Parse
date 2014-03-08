platform :ios, 6.1
pod 'HYUtils', :git => 'https://github.com/hrk-ys/HYUtils.git', :commit => '806679b2773695602825a57ff1d7b8edb4e63bdb'
pod 'Parse', '1.2.18'
pod 'FontAwesomeKit', '1.1.3'
pod 'SDWebImage', '3.5.2'
pod 'SVProgressHUD', '1.0'
pod 'Helpshift', '4.2.0'
pod 'Mixpanel', '2.3.2'

target 'DeskSlide Tests', :exclusive => true do
  pod 'KIF', '~> 2.0'
end


post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Pods-Acknowledgements.plist', 'DeskSlide/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
