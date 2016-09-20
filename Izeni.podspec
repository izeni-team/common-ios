Pod::Spec.new do |s|
  s.name             = "Izeni"
  s.version          = "0.11.2"
  s.summary          = "Izeni's common iOS code."
  s.description      = <<-DESC
                       All of izeni's common code for iOS. Includes extensions and subclasses of base classes.
                       DESC
  s.homepage         = "https://github.com/izeni-team/izeni-ios"
  s.license          = 'MIT'
  s.author           = { "bhenderson@izeni.com" => "bhenderson@izeni.com" }
  s.source           = { :git => "https://github.com/izeni-team/izeni-ios.git" }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = ['Pod/Classes/**/*']

  s.frameworks = 'UIKit'
end
