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
  s.version          = "0.6.4"
  s.summary          = "Izeni's common iOS code."
  s.description      = <<-DESC
                       All of izeni's common code for iOS.
                       Most Recent Change (0.6.4) - IZImagePicker - Fix UIImagePickerController source type for camera to be .Camera, removed extra print() statements
                       DESC
  s.homepage         = "https://dev.izeni.net/bhenderson/ios-common/"
  s.license          = 'MIT'
  s.author           = { "bhenderson@izeni.com" => "bhenderson@izeni.com" }
  s.source           = { :git => "https://dev.izeni.net/tallred/IOS-Common-Private-Pod.git" }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'Izeni' => ['Pod/Assets/*.png']
  }

  #s.library = 'sqlite3.0'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SwiftyJSON'
  s.dependency 'EDQueue'
  s.dependency 'PEPhotoCropEditor'
  s.dependency 'SCNetworkReachability'
  s.dependency 'Alamofire'
end
