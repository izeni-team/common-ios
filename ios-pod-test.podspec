#
# Be sure to run `pod lib lint ios-pod-test.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Izeni"
  s.version          = "0.1.0"
  s.summary          = "Izeni's common iOS code."
  s.description      = <<-DESC
                       All of izeni's common code for iOS.
                       DESC
  s.homepage         = "https://dev.izeni.net/bhenderson/ios-common/"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "bhenderson@izeni.com" => "bhenderson@izeni.com" }
  s.source           = { :git => "https://dev.izeni.net/tallred/IOS-Common-Private-Pod.git", :tag => "0.1.0" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'ios-pod-test' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'EDQueue'
end
