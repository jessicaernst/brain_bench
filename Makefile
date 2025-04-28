.PHONY: test-watch test-once clean-coverage

# Läuft Tests einmal und erstellt Coverage
test-once:
	@echo "🚀 Running Flutter Tests once with Coverage..."
	flutter test --coverage

# Läuft Tests im Watch Mode, automatisch bei Dateiänderungen
test-watch:
	@echo "👀 Watching Flutter Tests with Coverage..."
	@rm -rf coverage
	@fswatch -o lib test | xargs -n1 -I{} bash -c 'flutter test --coverage && echo "\033[0;32m✅ All Tests Passed\033[0m" || echo "\033[0;31m❌ Tests Failed\033[0m"'

# Löscht das Coverage-Verzeichnis
clean-coverage:
	@echo "🧹 Cleaning coverage folder..."
	@rm -rf coverage