Pod::Spec.new do |s|

  s.name         = "GISTFramework"
  s.version      = "6.0"
  s.summary      = "GISTFramework is bottom architecture layer of iOS apps."
  s.swift_version = ['5.0', '5.2', '5.3']

  s.description  = <<-DESC
                   GISTFramework is a bottom layer architecture of all iOS apps. it has all basic features and reusable classes that an iOS app may require. We made it open source to be used by others.
                   DESC

  s.homepage     = "https://github.com/cubixInc/GIST-Framework"

  s.license      = { :type => "GNU AGPLv3", :file => "LICENSE" }

  s.author             = "Cubix.co Inc."

  s.ios.deployment_target = "13.0"
  #s.osx.deployment_target = "10.15"

  s.source       = { :git => "https://github.com/cubixInc/GIST-Framework.git", :tag => s.version.to_s }

  s.subspec 'GISTCore' do |sp|
    sp.source_files = 'GISTFramework/Classes/GISTCore/**/*.{swift}'

    sp.dependency 'PhoneNumberKit', '~> 3.3.1'
  end

  s.subspec 'BaseClasses' do |sp|
    sp.source_files = 'GISTFramework/Classes/BaseClasses/**/*.{swift}'
    sp.dependency 'GISTFramework/GISTCore'
    sp.dependency 'GISTFramework/Extensions'
    sp.dependency 'GISTFramework/SyncEngine'
  end

  s.subspec 'Controls' do |sp|
    sp.source_files = 'GISTFramework/Classes/Controls/**/*.{swift}'
    sp.dependency 'GISTFramework/GISTCore'
    sp.dependency 'GISTFramework/BaseClasses'
    sp.dependency 'GISTFramework/Extensions'
    sp.dependency 'GISTFramework/SyncEngine'
    sp.dependency 'InputMask', '~> 6.0.0'
  end

  s.subspec 'Extensions' do |sp|
    sp.source_files = 'GISTFramework/Classes/Extensions/**/*.{swift}'
    sp.dependency 'GISTFramework/GISTCore'
    sp.dependency 'GISTFramework/SyncEngine'
  end

  s.subspec 'SyncEngine' do |sp|
    sp.source_files = 'GISTFramework/Classes/SyncEngine/**/*.{swift}'
    sp.dependency 'GISTFramework/GISTCore'
    sp.dependency 'UIColor_Hex_Swift', '~> 5.1.0'
  end

  s.subspec 'GISTSocial' do |sp|
    sp.source_files = 'GISTFramework/Classes/GISTSocial/**/*.{swift}'

    sp.dependency 'GISTFramework/GISTCore'
    sp.dependency 'GISTFramework/BaseClasses'
    sp.dependency 'GISTFramework/Extensions'
    sp.dependency 'GISTFramework/Controls'
    sp.dependency 'GISTFramework/SyncEngine'
    sp.dependency 'Alamofire', '~> 5.3.0'
    sp.dependency 'ObjectMapper', '~> 4.2.0'
    sp.dependency 'AFDateHelper', '~> 4.3.0'
    sp.dependency 'IQKeyboardManagerSwift', '~> 6.5.6'

  end

  s.pod_target_xcconfig = {
    'OTHER_SWIFT_FLAGS[config=Debug]' => '-DDEBUG',
  }

  s.resource_bundle = {
    'GISTFrameworkBundle' => 'GISTFramework/Resourses/*.*'
  }

end
