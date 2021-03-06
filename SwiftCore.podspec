#
# Be sure to run `pod lib lint SwiftCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftCore'
  s.version          = '0.1.0'
  s.summary          = 'A short description of SwiftCore.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/tritheman/SwiftCore'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tritheman' => 'tri.dang2@tiki.vn' }
  s.source           = { :git => 'https://github.com/tritheman/SwiftCore.git', :tag => s.version.to_s }
  s.platform     = :ios, "9.0"
  s.static_framework = true
  s.swift_version = '5.0'
  s.resources = 'SwiftCore/**/*.{xib,plist,bundle,xcassets,storyboard,png,jpeg,pdf}'
  s.exclude_files = "SwiftCore.podspec", "SwiftCore/Info.plist"
  s.xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }
  s.xcconfig = { 'GCC_PRECOMPILE_PREFIX_HEADER' => 'NO' }
  s.ios.deployment_target = '9.0'

  s.source_files = 'SwiftCore/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SwiftCore' => ['SwiftCore/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
