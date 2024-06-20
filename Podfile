# Uncomment the next line to define a global platform for your project
#platform :ios, '14.2'

target 'IMAB' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for IMAB
  
  pod 'Firebase/Firestore'
  
   pod 'Firebase/Analytics'
   
   pod 'Firebase/DynamicLinks'
   
   pod 'Firebase/Auth'

   pod 'Firebase/Storage'
   
   pod 'Firebase/Messaging'

   pod 'FirebaseFirestoreSwift'

   pod 'FBSDKLoginKit'
   
   pod 'GoogleSignIn'
  
  pod 'MBProgressHUD'
  
  pod 'SDWebImage'
  
  pod 'CropViewController'
  
  pod 'IQKeyboardManagerSwift'
  
  pod 'MHLoadingButton'
  
  pod 'DropDown'
  
  pod 'TTGSnackbar'
  
  pod 'GooglePlaces'
  
  pod 'lottie-ios'
  
  pod 'RevenueCat'
  
  pod 'GeoFire/Utils'
end



post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.2'
          xcconfig_path = config.base_configuration_reference.real_path
          xcconfig = File.read(xcconfig_path)
          xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
          File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
          end
      end
  end
