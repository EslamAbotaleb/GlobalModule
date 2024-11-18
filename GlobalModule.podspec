#
# Be sure to run `pod lib lint GlobalModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GlobalModule'
  s.version          = '0.0.1'
  s.summary          = 'A GlobalModule is a set of essential helpers for iOS projects'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.homepage         = 'https://github.com/EslamAbotaleb/GlobalModule'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'EslamAbotaleb' => 'eslamabotaleb07@gmail.com' }
  s.source           = { :git => 'https://github.com/EslamAbotaleb/GlobalModule.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.source_files = 'GlobalModule/Classes/**/*.{swift}'
  s.ios.deployment_target = '12.0'
  s.platform = :ios, '12.0'
  s.requires_arc = true
  s.swift_versions = ['4', '4.2', '5', '5.1', '5.2', '5.6', "5.9"]
  # s.resource_bundles = {
  #   'GlobalModule' => ['GlobalModule/Assets/*.png']
  # }
    s.subspec 'Core' do |core|
     core.dependency 'Alamofire'
     core.dependency 'RxSwift'
     core.dependency 'RxCocoa'
     core.dependency 'RxAlamofire'
    end
    s.default_subspec = 'Core'
  # s.public_header_files = 'Pod/Classes/**/*.h'
    s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
