#!/usr/bin/env bash

source ~/.rvm/scripts/rvm
rvm use default
pod repo add-cdn trunk 'https://cdn.cocoapods.org/'
pod trunk push --allow-warnings