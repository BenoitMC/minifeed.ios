# Uncomment the next line to define a global platform for your project
platform :ios, "12.0"

inhibit_all_warnings!

target "minifeed" do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for minifeed
  pod "Alamofire"
  pod "SwiftyJSON"
  pod "SwifterSwift", "5.1.0"
  pod "SnapKit"
  pod "SVProgressHUD"
  pod "IQKeyboardManagerSwift"
  pod "RxSwift"
  pod "RxCocoa"
  pod "Bugsnag"
end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "12.0"
       end
    end
  end
end
