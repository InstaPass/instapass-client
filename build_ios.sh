#!/usr/bin/env bash 

xcodebuild -configuration Release -workspace ./InstaPass-iOS/InstaPass.xcworkspace -scheme "InstaPass" -allowProvisioningUpdates -allowProvisioningDeviceRegistration build