#!/bin/sh

FRAMES_JSON=Frames.json
CHECKOUT_JSON=Checkout.json

# generate sourcekitten JSONs for modules
echo "Parsing Frames"
sourcekitten doc -- -workspace "iOS Example Frame/iOS Example Frame.xcworkspace" -scheme Frames -destination generic/platform=iOS > $FRAMES_JSON
echo ""

echo "Parsing Checkout"
sourcekitten doc -- -workspace Checkout/CocoapodsSample/CheckoutCocoapodsSample.xcworkspace -scheme Checkout -destination generic/platform=iOS > $CHECKOUT_JSON
echo ""

# combine JSONs to build jazzy docs
echo "Building docs"
jazzy --sourcekitten-sourcefile $FRAMES_JSON,$CHECKOUT_JSON
echo ""

# cleanup JSONs
echo "Cleaning up..."
rm $FRAMES_JSON
rm $CHECKOUT_JSON

echo "Done!"
