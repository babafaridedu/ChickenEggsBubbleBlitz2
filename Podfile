# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'ChickenEggs BubbleBlitz' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Use the Skillz pod
  pod 'Skillz'

end

post_install do |installer|
bitcode_strip_path = `xcrun --find bitcode_strip`.strip
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      config.build_settings['GCC_TREAT_WARNINGS_AS_ERRORS'] = 'NO'
      config.build_settings['SWIFT_TREAT_WARNINGS_AS_ERRORS'] = 'NO'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end

# Удаляем bitcode только из KochavaCore
  Dir.glob("Pods/**/KochavaCore.framework/KochavaCore").each do |binary|
    puts "Stripping bitcode from #{binary}"
    system("#{bitcode_strip_path} #{binary} -r -o #{binary}")
  end

end
