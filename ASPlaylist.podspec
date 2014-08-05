Pod::Spec.new do |spec|
  spec.name         = 'ASPlaylist'
  spec.version      = '0.0.1'
  spec.license      = 'MIT'
  spec.summary      = 'persistent playlist manager for music files'
  spec.homepage     = 'https://github.com/albertschulz/ASPlaylist'
  spec.author       = 'Albert Schulz'
  spec.source_files = 'ASPlaylist/*.{h,m}'
  spec.requires_arc = true
  spec.platform     = :ios
  spec.ios.deployment_target = '6.0'
  spec.source       = {
    :git => "https://github.com/albertschulz/ASPlaylist.git",
    :tag => "0.0.2"
  }
  spec.dependency   'EGODatabase'
end
