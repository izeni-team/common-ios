#
# Be sure to run `pod lib lint Izeni.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Izeni"
  s.version          = "0.10.0"
  s.summary          = "Izeni's common iOS code."
  s.description      = <<-DESC
                       All of izeni's common code for iOS.
                       DESC
  s.homepage         = "https://github.com/izeni-team/izeni-ios"
  s.license          = 'MIT'
  s.author           = { "bhenderson@izeni.com" => "bhenderson@izeni.com" }
  s.source           = { :git => "https://github.com/izeni-team/izeni-ios.git" }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = ['Pod/Classes/**/*']
  s.resource_bundles = {
    'Izeni' => ['Pod/Assets/*.png']
  }

  s.frameworks = 'UIKit'
end
