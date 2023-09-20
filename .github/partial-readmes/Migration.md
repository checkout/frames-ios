# Migrating from 3.X.X to 4.X.X 
3DS and Apple Pay processing remain unaffected so using them should still work the same. 

If you're using Frames iOS from versions prior to v4 (we would strongly recommend using the latest release), this update will bring breaking changes that'll require a little development time.

Because of our efforts to greatly improve the UI of the Frames and enabling you to customise it to such extents, the approach required is very different. This will require you to:
- remove usage of Frames older version from your code base. This may be an opportunity to remove a screen as well, or a few other objects that were created only to support older Frames integration!
- [Get started](https://github.com/checkout/frames-ios/blob/feature/partial-readmes/.github/partial-readmes/GetStarted.md)


We would like to point out the great benefits that we think v4+ brings to our SDK, like:

- customisable UI focussed on enabling your users to seamlessly transition through the payment flow
- updated and improved validation logic, in line with our supported card payment methods
- using our updated UIs provides added security benefits to your customers
