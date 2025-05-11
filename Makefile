# Declare targets that are not actual files, ensuring they always run.
.PHONY: test test-watch test-once clean-coverage show-coverage open-coverage coverage-report filter-lcov deep-clean dev-clean build watch format analyze check-all l10n clean-l10n clean-generated clean-build clean firebase-dev firebase-prod help

# Filters generated Dart files (.g.dart, .freezed.dart, .gen.dart) from the lcov.info coverage report.
# Ensures the 'remove_from_coverage' tool is globally activated first.
filter-lcov:
	@echo "🧹 Filtering generated files from coverage..."
	dart pub global list | grep remove_from_coverage >/dev/null || dart pub global activate remove_from_coverage
	dart pub global run remove_from_coverage:remove_from_coverage \
		-f coverage/lcov.info \
		-r '\.g\.dart$$|\.freezed\.dart$$|\.gen\.dart$$'

# Runs Flutter tests once without generating code coverage.
test:
	@echo "🧪 Running Flutter Tests once (no coverage)..."
	flutter test

# Runs Flutter tests once, generates code coverage data (lcov.info),
# and then filters generated files from the coverage report.
test-once:
	@echo "🚀 Running Flutter Tests once with Coverage..."
	flutter test --coverage
	@$(MAKE) filter-lcov

# Watches for file changes in 'lib' and 'test' directories.
# Automatically re-runs tests with coverage on any change, filters the report on success,
# and prints a success or failure message. Cleans previous coverage first.
test-watch:
	@echo "👀 Watching Flutter Tests with Coverage..."
	@rm -rf coverage
	@fswatch -o lib test | xargs -n1 -I{} bash -c 'flutter test --coverage && make filter-lcov && echo "\033[0;32m✅ All Tests Passed\033[0m" || echo "\033[0;31m❌ Tests Failed\033[0m"'

# Removes the 'coverage' directory, cleaning up all generated coverage data.
clean-coverage:
	@echo "🧹 Cleaning coverage folder..."
	@rm -rf coverage

# Toggles the visibility of code coverage highlighting in VS Code gutters.
# Checks if the 'code' command is available in the PATH first.
# Requires the 'Coverage Gutters' extension.
show-coverage:
	@echo "📊 Toggling Coverage Gutters in VS Code..."
	@if command -v code >/dev/null 2>&1; then \
		echo "   Found 'code' command. Attempting to toggle..."; \
		code --command coverage-gutters.toggleCoverage; \
	else \
		echo "⚠️ 'code' command not found in PATH. Cannot toggle VS Code coverage gutters."; \
		echo "   Ensure VS Code command line tools are installed and in your PATH."; \
		echo "   See: https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line (Mac)"; \
		echo "   or https://code.visualstudio.com/docs/setup/linux#_launching-from-the-command-line (Linux)"; \
	fi

# Generates an HTML code coverage report from 'lcov.info' using genhtml
# and opens the main 'index.html' file in the default web browser.
open-coverage:
	@echo "📂 Generating HTML Coverage Report..."
	genhtml coverage/lcov.info -o coverage/html
	@echo "🌐 Opening HTML Report in browser..."
	open coverage/html/index.html

# Convenience target: Runs tests with coverage (`test-once`),
# then generates and opens the HTML coverage report (`open-coverage`).
coverage-report:
	@$(MAKE) test-once
	@$(MAKE) open-coverage

# Performs a deep clean of Flutter project including iOS CocoaPods,
# regenerates pub packages and reinstalls pods (macOS/Apple Silicon compatible).
deep-clean:
	@echo "🧹 Performing deep clean (Flutter + iOS pods)..."
	flutter clean
	flutter pub get
	cd ios && rm -rf Pods Podfile.lock build && arch -x86_64 pod install --repo-update && cd ..

# Switches to the 'dev' Firebase environment and performs a deep clean.
# Cleans previous builds and dependencies, reinstalls CocoaPods, and prepares the dev setup.
dev-clean:
	@echo "🔁 Switching to 'dev' Firebase environment with deep clean..."
	./scripts/use_firebase_env.sh dev --clean
	flutter pub get
	cd ios && rm -rf Pods Podfile.lock build && arch -x86_64 pod install --repo-update && cd ..

# Builds the project using build_runner, deleting any conflicting outputs.
# This is a one-time build, not a watch.
build:
	@echo "Running a one-time build..."
	dart run build_runner build --delete-conflicting-outputs

# Watches for changes in the project and rebuilds automatically.
# This is a continuous watch, not a one-time build.
watch:
	@echo "Starting build_runner watch..."
	dart run build_runner watch --delete-conflicting-outputs

# Formats all Dart code in the project.
format:
	@echo "🎨 Formatting Dart code..."
	dart format .

# Analyzes the project's Dart code for errors, warnings, and lints.
analyze:
	@echo "🔍 Analyzing Dart code..."
	flutter analyze

# Runs format, analyze, and test-once sequentially.
check-all: format analyze test-once
	@echo "✅ All checks passed!"

# Generates localization files.
l10n:
	@echo "🌍 Generating localization files..."
	flutter gen-l10n

# Deletes generated localization files.
clean-l10n:
	@echo "🧹 Cleaning generated localization files..."
	@rm -rf lib/core/localization/generated # Adjust path if necessary

# Deletes all generated Dart files (.g.dart, .freezed.dart, .gen.dart).
clean-generated:
	@echo "🧹 Cleaning all generated Dart files..."
	@find . -name '*.g.dart' -delete
	@find . -name '*.freezed.dart' -delete
	@find . -name '*.gen.dart' -delete

# Deletes Flutter build artifacts (runs flutter clean).
clean-build:
	@echo "🧹 Cleaning Flutter build artifacts..."
	flutter clean

# Runs all specific clean targets.
clean: clean-generated clean-l10n clean-coverage clean-build
	@echo "🧹 All specified generated files and build artifacts cleaned."

# Displays a help message listing available commands and their descriptions.
help:
	@echo "BrainBench Makefile - Available Commands:"
	@echo ""
	@echo "  Formatting & Analysis:"
	@echo "    make format             - Formats all Dart code."
	@echo "    make analyze            - Analyzes Dart code for errors and warnings."
	@echo "    make check-all          - Runs format, analyze, and test-once."
	@echo ""
	@echo "  Building:"
	@echo "    make build              - Runs a one-time build_runner build."
	@echo "    make watch              - Starts build_runner watch mode."
	@echo "    make l10n               - Generates localization files."
	@echo ""
	@echo "  Testing & Coverage:"
	@echo "    make test               - Runs tests (no coverage)."
	@echo "    make test-once          - Runs tests once with coverage and filters report."
	@echo "    make test-watch         - Watches for changes and reruns tests with coverage."
	@echo "    make filter-lcov        - Filters generated files from lcov.info."
	@echo "    make clean-coverage     - Removes the coverage directory."
	@echo "    make show-coverage      - Toggles coverage gutters in VS Code."
	@echo "    make open-coverage      - Generates and opens HTML coverage report."
	@echo "    make coverage-report    - Runs test-once and then open-coverage."
	@echo ""
	@echo "  Cleaning:"
	@echo "    make clean-l10n         - Cleans generated localization files."
	@echo "    make clean-generated    - Cleans all .g.dart, .freezed.dart, .gen.dart files."
	@echo "    make clean-build        - Runs flutter clean."
	@echo "    make clean              - Runs clean-generated, clean-l10n, clean-coverage, and clean-build."
	@echo "    make deep-clean         - Performs a full Flutter clean and CocoaPods reinstall."
	@echo "    make dev-clean          - Switches to Firebase dev and performs a deep clean."
	@echo ""