#!/bin/sh

ENV="${FIREBASE_ENV:-$1}"
FORCE_CLEAN=$2 # z.B. ./script.sh test true

if [ -z "$ENV" ]; then
  echo "⚠️  No FIREBASE_ENV or argument provided. Defaulting to 'dev'"
  ENV="dev"
fi

STAGE_FILE=".last_firebase_env"

if [ -f "$STAGE_FILE" ]; then
  LAST_ENV=$(cat "$STAGE_FILE")
else
  LAST_ENV=""
fi

echo "⚙️  Applying Firebase config for environment: $ENV"

cp "android/app/google-services-$ENV.json" "android/app/google-services.json"
cp "ios/Runner/GoogleService-Info-$ENV.plist" "ios/Runner/GoogleService-Info.plist"
cp "ios/Runner/info-$ENV.plist" "ios/Runner/Info.plist"

echo "✅ Firebase and Info.plist copied for '$ENV'"

if [ "$LAST_ENV" != "$ENV" ] || [ "$FORCE_CLEAN" = "true" ]; then
  echo "🔁 Stage changed or forced. Running flutter clean & pub get..."
  flutter clean
  flutter pub get
  echo "$ENV" > "$STAGE_FILE"
else
  echo "✔️  No stage change. Skipping clean/pub get."
fi