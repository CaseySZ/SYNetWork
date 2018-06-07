#
#  Be sure to run `pod spec lint SYNetWork.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "SYNetWork"
  s.summary      = "network frame base on AFNetwork"
  s.version      = "1.1.0"
  s.license      = "MIT"
  s.author       = { "sunyong445" => "512776506@qq.com" } # 作者信息
  
  s.homepage     = "https://github.com/sunyong445"
  
  s.platform     = :ios, "7.0" #平台及支持的最低版本
  s.source       = { :git => "https://github.com/sunyong445/SYNetWorkDemo.git", :tag => "v#{s.version}" }
  
  s.source_files = "SYNetWorkDemo/SYNetWork/*.{h,m}"
  
  s.requires_arc = true # 是否启用ARC
  s.platform     = :ios, "7.0" #平台及支持的最低版本
  s.social_media_url   = "https://github.com/sunyong445" # 个人主页
  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"
  
  s.frameworks = "Foundation", "UIKit"
  s.dependency "AFNetwork"
  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
