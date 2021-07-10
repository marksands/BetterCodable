Pod::Spec.new do |s|
	s.name         = 'BetterCodable'
	s.version      = '0.4.0'
	s.swift_versions = ['5.1']
	s.summary      = 'Better Codable through Property Wrappers'
	s.homepage     = 'https://github.com/marksands/BetterCodable'
	s.license      = { :type => 'MIT', :file => 'LICENSE' }
	s.author       = { 'Mark Sands' => 'http://marksands.github.io/' }
	s.social_media_url   = 'https://twitter.com/marksands'

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'
  s.tvos.deployment_target = '10.0'
  s.watchos.deployment_target = '3.0'

  s.source       = { :git => 'https://github.com/marksands/BetterCodable.git', :tag => s.version.to_s }
	s.source_files  = 'Sources/**/*.swift'
	s.frameworks  = 'Foundation'
end
