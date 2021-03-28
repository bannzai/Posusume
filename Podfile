# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
source 'https://cdn.cocoapods.org/'

install! 'cocoapods', incremental_installation: true, integrate_targets: false

target 'posusume' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks! :linkage => :static

  # Pods for posusume
  pod 'Firebase/Core'
  pod 'Firebase/Storage'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
  pod 'Firebase/MLVision'
  pod 'Firebase/Auth'

  target 'posusumeTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'posusumeUITests' do
    # Pods for testing
  end

end
