Pod::Spec.new do |s|
  s.name         = "Frames"
  s.version      = "3.4.2"
  s.summary      = "Checkout API Client, Payment Form UI and Utilities in Swift"
  s.description  = <<-DESC
  Checkout API Client and Payment Form Utilities in Swift.
  This library contains methods to implement a payment form as well as UI elements.
                   DESC
  s.homepage     = "https://github.com/checkout/frames-ios.git"
  s.swift_version = "5.0"
  s.license      = "MIT"
  s.author       = { "Checkout.com Integration" => "integration@checkout.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/checkout/frames-ios.git", :tag => "#{s.version}" }

  s.source_files = 'Source/**/*.swift'
  s.exclude_files = "Classes/Exclude"
  s.resources = 'Source/Resources/**/*'

  s.dependency 'PhoneNumberKit', '~> 3.3.0'
  s.dependency 'Alamofire', '~> 5.4.0'
  s.dependency 'CheckoutEventLoggerKit', '~> 1.0.2'

  s.test_spec do |t|
    t.source_files = 'Tests/**/*.swift'
    t.dependency 'Mockingjay', '~> 3.0.0-alpha.1'
    t.exclude_files = 'Tests/LinuxMain.swift'
    t.resources = 'Tests/Fixtures/*'
  end

  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'arm64 armv7 x86_64' }
end
