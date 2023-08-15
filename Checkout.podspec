Pod::Spec.new do |s|
  s.name = 'Checkout'
  s.version = '4.2.0'
  s.summary = 'Checkout SDK for iOS'

  s.description = <<-DESC
    Checkout Core functionality can only be used with the right level of PCI Compliance.
    Please contact us for more details.
                  DESC

  s.homepage = 'https://github.com/checkout/frames-ios'
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.author   = { "Checkout.com Integration" => "integration@checkout.com" }
  s.source   = { :git => "https://github.com/checkout/frames-ios.git", :tag => s.version }

  s.ios.deployment_target = '11.0'
  s.swift_version = "5.7"

  s.source_files = 'Checkout/Source/**/*.swift'
  s.exclude_files = "Checkout/Samples/**"

  s.dependency 'CheckoutEventLoggerKit', '~> 1.2.4'

end
