#!/bin/bash

# 1. Get ENV from environment variable or first argument
ENV="${FIREBASE_ENV:-$1}"
FORCE_CLEAN=$2 # e.g., ./script.sh test true

# 2. If ENV is still empty, determine it based on the Git branch
if [ -z "$ENV" ]; then
  BRANCH=$(git rev-parse --abbrev-ref HEAD)
  echo "🔍 Detected Git Branch: $BRANCH"

  case "$BRANCH" in
    main)
      ENV="prod"
      ;;
    test)
      ENV="test"
      ;;
    develop|feature/*)
      ENV="dev"
      ;;
    *)
      echo "⚠️  Unknown branch '$BRANCH', defaulting to 'dev'"
      ENV="dev"
      ;;
  esac
fi

STAGE_FILE=".last_firebase_env"

# 3. Load last known stage
if [ -f "$STAGE_FILE" ]; then
  LAST_ENV=$(cat "$STAGE_FILE")
else
  LAST_ENV=""
fi

# 4. Now apply the environment
echo "⚙️  Applying Firebase config for environment: $ENV"

# Copy the environment-specific Google services files
cp "android/app/google-services-$ENV.json" "android/app/google-services.json"
cp "ios/Runner/GoogleService-Info-$ENV.plist" "ios/Runner/GoogleService-Info.plist"
# Copy the environment-specific Info.plist (might contain bundle IDs, etc.)
cp "ios/Runner/info-$ENV.plist" "ios/Runner/Info.plist"

echo "✅ Firebase and Info.plist copied for '$ENV'"

# 5. Clean & Pub get only if ENV has changed or if forced
if [ "$LAST_ENV" != "$ENV" ] || [ "$FORCE_CLEAN" = "true" ]; then
  echo "🔁 Stage changed or forced. Running flutter clean & pub get..."
  flutter clean
  flutter pub get
  # Store the currently applied environment for the next run
  echo "$ENV" > "$STAGE_FILE"
else
  echo "✔️  No stage change. Skipping clean/pub get."
fi
