Pod::Spec.new do |s|
  s.name = 'AKTransliteration'
  s.platform = :ios
  s.version = '0.0.1'
  s.summary = 'Simple rule based transliteration for iOS in Objective-C'
  s.homepage = 'https://github.com/blackm00n/AKTransliteration'
  s.license = 'MIT'
  s.author = { 'Aleksey Kozhevnikov' => 'aleksey.kozhevnikov@gmail.com' }
  s.source = { :git => 'https://github.com/blackm00n/AKTransliteration.git', :tag => "v#{s.version.to_s}" }
  s.source_files = 'AKTransliteration'
  s.resources = 'AKTransliteration/*.plist'
  s.prefix_header_file = 'AKTransliteration/AKTransliteration-Prefix.pch'
  s.requires_arc = true
end
