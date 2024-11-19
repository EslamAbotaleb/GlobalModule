#
# Be sure to run `pod lib lint GlobalModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |spec|
    spec.name             = 'GlobalModule'
    spec.version          = '0.0.1'
    spec.summary          = 'A GlobalModule is a set of essential helpers for iOS projects'
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!

    spec.homepage         = 'https://github.com/EslamAbotaleb/GlobalModule'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    spec.license          = { :type => 'MIT', :file => 'LICENSE' }
    spec.author           = { 'EslamAbotaleb' => 'eslamabotaleb07@gmail.com' }
    # s.source           = { :git => 'https://github.com/EslamAbotaleb/GlobalModule.git', :tag => s.version.to_s }
    spec.source           = { :git => 'https://github.com/EslamAbotaleb/GlobalModule.git', :tag => spec.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    spec.source_files = 'GlobalModule/Classes/**/*.{swift}'
    spec.ios.deployment_target = '12.0'
    spec.platform = :ios, '12.0'
    spec.requires_arc = true
    spec.swift_versions = ['4', '4.2', '5', '5.1', '5.2', '5.6', "5.9"]
    # s.resource_bundles = {
    #   'GlobalModule' => ['GlobalModule/Assets/*.png']
    # }
    spec.subspec 'Core' do |core|
        core.dependency 'Alamofire'
        core.dependency 'RxSwift'
        core.dependency 'RxCocoa'
        core.dependency 'RxAlamofire'
        core.pod_target_xcconfig = { 'IPHONEOS_DEPLOYMENT_TARGET' => '12.0' }
    end
    spec.default_subspec = 'Core'
    spec.frameworks = 'UIKit'
    # s.public_header_files = 'Pod/Classes/**/*.h'
end
