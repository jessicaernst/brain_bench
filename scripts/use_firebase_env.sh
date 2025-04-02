#!/bin/bash

ENV=$1

echo "🛠  Applying Firebase config for environment: $ENV"

# Android
cp android/app/google-services-$ENV.json android/app/google-services.json

# iOS
cp ios/Runner/GoogleService-Info-$ENV.plist ios/Runner/GoogleService-Info.plist

echo "✅ Firebase config copied for $ENV"