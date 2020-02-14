Pod::Spec.new do |s|

  s.name                = "FLDiagnostic"
  s.version             = "1.0.3"
  s.summary             = "Summary"
  s.description         = "Description"
  s.resources = "FLDiagnostic/**/*.{xcassets}"
  s.homepage     = 'http://arcsinus.ru'
  s.license             = "MIT"
  s.author              = "Arcsinus"
  s.platform            = :ios, "10.0"
  s.source = { :git => "https://github.com/blinovarcsinus/FLDiagnostic.git", 
             :tag => "#{s.version}" }
  s.source_files        = "FLDiagnostic", "FLDiagnostic/**/*.{h,m,swift,storyboard}"
  s.swift_version       = "5.0"

  s.dependency 'SnapKit', '~> 5.0.0'
  s.dependency 'RxSwift', '~> 5'
  s.dependency 'RxCocoa', '~> 5'
  s.dependency 'Alamofire', '~> 4.8.2'
  s.dependency 'RxReachability', '~> 1.0.0'
  s.dependency 'RxOptional', '~> 4.1.0'
  s.dependency 'RxKeyboard', '~> 1.0.0'
  s.dependency 'RxCoreMotion', '~> 1.2.1'
  s.dependency 'RxDataSources', '~> 4.0'
  s.dependency 'RxAppState', '~> 1.6.0'
  s.dependency 'Mute', '~> 0.5'
  s.dependency 'SVProgressHUD'
end
