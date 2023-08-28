Pod::Spec.new do |s|
  s.name             = 'xxHash'
  s.version          = '999.99.9'
  s.summary          = 'Swift wrapper for reference C implementation of xxHash hashes.'

  s.homepage         = 'https://github.com/tesseract-one/xxHash.swift'

  s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
  s.author           = { 'Tesseract Systems, Inc.' => 'info@tesseract.one' }
  s.source           = { :git => 'https://github.com/tesseract-one/xxHash.swift.git', :tag => s.version.to_s }

  s.swift_version    = '5.4'

  base_platforms     = { :ios => '11.0', :osx => '10.13', :tvos => '11.0' }
  s.platforms        = base_platforms.merge({ :watchos => '6.0' })
  
  s.source_files = 'Sources/xxHash/**/*.swift'
  
  # CxxHash headers include
  s.preserve_path = 'Sources/CxxHash'
  s.pod_target_xcconfig = {
    'SWIFT_INCLUDE_PATHS' => '$(inherited) "${PODS_TARGET_SRCROOT}/Sources"'
  }
  
  s.test_spec 'Tests' do |ts|
    ts.platforms = base_platforms
    ts.source_files = 'Tests/xxHashTests/*.swift'
  end
end
