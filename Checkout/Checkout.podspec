Pod::Spec.new do |s|
  s.name         = "Checkout"
  s.summary      = "Checkout Core Features that can only be used with the right level of PCI Compliance. Please contact us for the details."
  s.version      = "4.2.0"
  s.homepage     = "https://github.com/checkout/frames-ios"
  s.swift_version = "5.0"
  s.author       = { "Checkout.com Integration" => "integration@checkout.com" }
  s.platform     = :ios, "12.0"
  s.source       = { :path => "./Source" }
  s.license      = "MIT"

  s.source_files = 'Source/**/*.swift'
  s.exclude_files = "Samples/**"

  s.dependency 'CheckoutEventLoggerKit'

end
