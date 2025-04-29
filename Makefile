.PHONY: test test-watch test-once clean-coverage show-coverage open-coverage coverage-report

# Runs tests once WITHOUT generating coverage.
test:
	@echo "🧪 Running Flutter Tests once (no coverage)..."
	flutter test

# Runs tests once and generates the coverage report in the 'coverage/' directory.
test-once:
	@echo "🚀 Running Flutter Tests once with Coverage..."
	flutter test --coverage

# Runs tests continuously in watch mode (WITH coverage).
# It uses 'fswatch' to monitor the 'lib' and 'test' directories for changes.
# When a change is detected, it removes the old coverage report,
# reruns 'flutter test --coverage', and prints a success or failure message.
test-watch:
	@echo "👀 Watching Flutter Tests with Coverage..."
	# Ensure a clean start by removing any previous coverage results.
	@rm -rf coverage
	# Watch 'lib' and 'test' folders, on change (-o), pipe output to xargs.
	# xargs takes each changed file path (-n1 -I{}) and executes the bash command.
	# The bash command runs tests with coverage and prints colored status messages.
	@fswatch -o lib test | xargs -n1 -I{} bash -c 'flutter test --coverage && echo "\033[0;32m✅ All Tests Passed\033[0m" || echo "\033[0;31m❌ Tests Failed\033[0m"'

# Deletes the 'coverage/' directory, removing all generated coverage reports.
clean-coverage:
	@echo "🧹 Cleaning coverage folder..."
	@rm -rf coverage

# Attempts to toggle the visibility of coverage highlighting in Visual Studio Code.
# This requires the 'Coverage Gutters' extension to be installed and the
# 'coverage-gutters.toggleCoverage' command to be accessible via the 'code' CLI.
# This might require specific VS Code setup or keybindings.
show-coverage:
	@echo "📊 Toggling Coverage Gutters in VS Code (if mapped)..."
	code --command coverage-gutters.toggleCoverage

# Generates an HTML report from the existing coverage/lcov.info file
# using 'genhtml' (requires lcov package) and opens the main index.html
# file in the default web browser.
open-coverage:
	@echo "📂 Generating HTML Coverage Report..."
	genhtml coverage/lcov.info -o coverage/html
	@echo "🌐 Opening HTML Report in browser..."
	open coverage/html/index.html

# Convenience target: First runs the tests once to generate coverage data,
# then generates the HTML report and opens it in the browser.
coverage-report:
	@make test-once
	@make open-coverage

