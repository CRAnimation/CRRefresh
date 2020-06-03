#
#  Be sure to run `pod spec lint CRRefresh.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name          = "CRRefresh"
  s.version       = "1.1.3"
  s.summary       = "An easy way to use pull-to-refresh"
  s.homepage      = "https://github.com/CRAnimation/CRRefresh"
  s.license       = 'MIT'
  s.author        = { "W_C__L" => "wangchonglei93@icloud.com" }
  s.platform      = :ios, "8.0" 
  s.swift_version = '5.0'  
  s.source        = { :git => "https://github.com/CRAnimation/CRRefresh.git", :tag => s.version.to_s }
  s.source_files  = ['CRRefresh/CRRefresh/*.{swift}','CRRefresh/CRRefresh/Animators/**/*.{swift}']
  s.resources     = 'CRRefresh/CRRefresh/Animators/**/*.{bundle}'
  s.frameworks    = "UIKit"
  s.requires_arc  = true

end
