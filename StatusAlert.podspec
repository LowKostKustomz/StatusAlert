Pod::Spec.new do |s|
  s.name             = 'StatusAlert'
  s.version          = '0.12.0'
  s.summary          = 'Display Apple system-like status alerts for iOS'
  s.description      = <<-DESC
StatusAlert is an iOS framework that displays status alerts similar to Apple's system self-hiding alerts. It is well suited for notifying user without interrupting user flow in iOS-like way.
It looks very similar to the alerts displayed in Podcasts, Apple Music and News apps.
                       DESC

  s.homepage         = 'https://github.com/LowKostKustomz/StatusAlert'
  s.screenshots      = 'https://raw.githubusercontent.com/LowKostKustomz/StatusAlert/master/Assets/iPhonesWithStatusAlert.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LowKostKustomz' => 'mierosh@gmail.com' }
  s.source           = { :git => 'https://github.com/LowKostKustomz/StatusAlert.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/LowKostKustomz'
  s.ios.deployment_target = '9.0'
  s.source_files     = 'Sources/**/*.{swift}'
  s.frameworks       = 'UIKit'
end
