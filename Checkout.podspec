Pod::Spec.new do |s|
  s.name = 'Checkout'
  s.version = '3.5.3'
  s.summary = 'Checkout SDK for iOS'

  s.description = <<-DESC
TODO: Add long description of the pod here.
                  DESC

  s.homepage = 'https://github.com/checkout/frames-ios'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { "Checkout.com Integration" => "integration@checkout.com" }
  s.source       = { :git => "https://github.com/checkout/frames-ios.git", :tag => s.version }

  s.ios.deployment_target = '10.0'
  s.swift_version = "5.0"

  s.source_files = 'Checkout/Checkout/Source/**/*'

  s.dependency 'CheckoutEventLoggerKit', '1.2.0'

  s.test_spec 'Tests' do |t|
    t.source_files = 'Checkout/Checkout/Test/**/*'
    t.requires_app_host = true
    t.scheme = { :launch_arguments => ['COCOAPODS'] }
  end

  s.test_spec 'Integration-Tests' do |t|
    t.source_files = 'Checkout/Checkout/Integration/**/*'
    t.requires_app_host = true
    t.scheme = { :launch_arguments => ['COCOAPODS'] }
  end
end
