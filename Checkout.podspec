Pod::Spec.new do |s|
  s.name = 'Checkout'
  s.version = '4.1.0'
  s.summary = 'Checkout SDK for iOS'

  s.description = <<-DESC
TODO: Add long description of the pod here.
                  DESC

  s.homepage = 'https://github.com/checkout/frames-ios'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { "Checkout.com Integration" => "integration@checkout.com" }
  s.source       = { :git => "https://github.com/checkout/frames-ios.git", :tag => s.version }

  s.ios.deployment_target = '11.0'
  s.swift_version = "5.7"

  s.source_files = 'Checkout/Checkout/Source/**/*'

  s.dependency 'CheckoutEventLoggerKit', '~> 1.2.4'

end
