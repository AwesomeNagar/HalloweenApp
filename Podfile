source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

target 'HalloweenMapApp' do
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'SQLite.swift', '0.12.0'
end
post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end
