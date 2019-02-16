# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

inhibit_all_warnings!

target "minifeed" do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for minifeed
  pod "Alamofire"
  pod "SwiftyJSON"
  pod "SwifterSwift"
  pod "SnapKit"
  pod "SVProgressHUD"
  pod "IQKeyboardManagerSwift"
  pod "RxSwift"
  pod "RxCocoa"
  pod "Bugsnag"

  target "minifeedTests" do
    inherit! :search_paths
    pod "Mockingjay"
  end

  target "minifeedUITests" do
    inherit! :search_paths
  end
end
