#
# Be sure to run `pod lib lint ITLinkRouter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ITLinkRouter"
  s.version          = "0.1.1"
  s.summary          = "A short description of ITLinkRouter."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                       DESC

  s.homepage         = "https://github.com/<GITHUB_USERNAME>/ITLinkRouter"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Alex Rudyak" => "al.rudyak@gmail.com" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/ITLinkRouter.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/ITLinkRouter.h'
  s.public_header_files = 'Pod/Classes/ITLinkRouter.h'
  s.resource_bundles = {
    'ITLinkRouter' => ['Pod/Assets/*.png']
  }
  
  s.subspec 'Core' do |c|
    c.source_files = 'Pod/Classes/Core/**/*.{h,m}'
    c.public_header_files = 'Pod/Classes/Core/**/*.h'
  end

  s.subspec 'BasicNode' do |n|
    n.source_files = 'Pod/Classes/Node/**/*.{h,m}'
    n.public_header_files = 'Pod/Classes/Node/*.h'
    n.dependency 'ITLinkRouter/Core'
  end


  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
