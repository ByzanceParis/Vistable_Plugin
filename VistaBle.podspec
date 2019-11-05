
  Pod::Spec.new do |s|
    s.name = 'VistaBle'
    s.version = '0.0.1'
    s.summary = 'BLE Connection'
    s.license = 'MIT'
    s.homepage = 'https://github.com/ByzanceParis/Vistable_Plugin'
    s.author = 'tom'
    s.source = { :git => 'https://github.com/ByzanceParis/Vistable_Plugin', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '12.4'
    s.dependency 'Capacitor'
  end