
Pod::Spec.new do |s|

  s.name         = "ADCarouselView"
  s.version      = "1.0.1"
  s.summary      = "轮播图"

  s.description  = <<-DESC
                   用UICollectionView实现轮播图 
                   DESC

  s.homepage     = "https://github.com/tiancanfei/ADCarouselView"

  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "安德航" => "bjwltiankong@163.com" }

  s.platform     = :ios
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/tiancanfei/ADCarouselView.git", :tag => "#{s.version}" }

  s.source_files  = "ADCarouselView/ADCarouselView/*.{h,m}"
  # s.exclude_files = "Classes/Exclude"

  s.public_header_files = "ADCarouselView/ADCarouselView/*.h"

  # s.framework  = "UIKit"
  s.frameworks = "UIKit"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency 'SDWebImage', '~> 3.7.6'

end
