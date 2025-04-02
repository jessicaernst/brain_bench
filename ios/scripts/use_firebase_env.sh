#!/bin/sh

# Nimm das Environment entweder aus ENV oder dem ersten Argument
ENV="${FIREBASE_ENV:-$1}"

# Fallback falls ENV leer ist
if [ -z "$ENV" ]; then
  echo "⚠️  No FIREBASE_ENV or argument provided. Defaulting to 'dev'"
  ENV="dev"
fi

echo "⚙️  Applying Firebase config for environment: $ENV"

# Android
cp "android/app/google-services-$ENV.json" "android/app/google-services.json"

# iOS
cp "ios/Runner/GoogleService-Info-$ENV.plist" "ios/Runner/GoogleService-Info.plist"
cp "ios/Runner/info-$ENV.plist" "ios/Runner/Info.plist"

echo "✅ Firebase and Info.plist copied for '$ENV'"

