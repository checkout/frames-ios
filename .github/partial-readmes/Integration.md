# Integration

We've done our best to support the most common distribution methods on iOS. We are in strong favour of [SPM](#Swift-Package-Manager) (Swift Package Manager) but if for any reason this doesn't work for you, we also support [Cocoapods](#Cocoapods).

### Swift Package Manager
[Swift Package Manager](https://swift.org/package-manager/) integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies. It should work out of the box on latest Xcode projects since Xcode 11 and has had a lot of community support, seeing huge adoption over the recent years. This is our preferred distribution method for Frames iOS and is the easiest one to integrate, keep updated and build around.

If you've never used it before, get started with Apple's step by step guide into [adding package dependencies to your app](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app) . Just use this repository's URL (https://github.com/checkout/frames-ios) when adding dependency.


### CocoaPods
[CocoaPods](http://cocoapods.org) is the traditional dependency manager for Apple projects. We do support it, but recommend using SPM given it is Apple's preferred dependency manager.

Make sure cocoapods is installed on your machine by running
```bash
$ pod --version
```
Any version newer than **1.10.0** is a good sign. If not installed, or unsupported, follow [Cocoapods Getting Started](https://guides.cocoapods.org/using/getting-started.html)

Once Cocoapods of a valid version is on your machine, to integrate Frames into your Xcode project, update your `Podfile`:
```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'
use_frameworks!

# PhoneNumberKit has stopped publishing Cocoapods releases to Public Registry
# This workaround enables application to get the releases straight from source repository 
pod 'PhoneNumberKit', :git => 'https://github.com/marmelroy/PhoneNumberKit'

target '<Your Target Name>' do
    pod 'Frames', '~> 4.0'
end
```

Then, run the following command in terminal:

```bash
$ pod install
```

To update your existing Cocoapod dependencies, use:
```bash
$ pod update
```
