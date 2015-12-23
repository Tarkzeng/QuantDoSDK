#
# Be sure to run `pod lib lint QuantDoSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "QuantDoSDK"
  s.version          = "0.1.0"
  s.summary          = "A light framework for QuantDo company."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = "给公司用的一个网络请求封装framework，主要用来验证怎么用cocoapods来制作有依赖第三方库的framework。"

  s.homepage         = "https://github.com/Tarkzeng/QuantDoSDK"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Tark" => "tark_zeng@163.com" }
  s.source           = { :git => "https://github.com/Tarkzeng/QuantDoSDK.git", :tag => s.version.to_s }
 # s.source           = { :git => "/Users/zengtark/QuantDoSDK", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'QuantDoSDK' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking'
end
