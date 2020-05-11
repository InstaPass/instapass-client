#!/usr/bin/env bash 

xcodebuild -configuration Release -workspace ./InstaPass-iOS/InstaPass.xcworkspace -scheme "InstaPass Watch" -allowProvisioningUpdates -allowProvisioningDeviceRegistration build