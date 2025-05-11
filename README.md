# brain_bench

An Flutter knowledge check and learning App

## Packages used:

- Riverpod with code gen
- Freezed
- Hooks
- Localizations
- intl
- logging
- fluttergen
- svg


## 🧪 Testing & Code Coverage

This project uses Flutter's built-in Testing and automatic code coverage monitoring.

### Prerequisites

- Flutter SDK installed
- `fswatch` installed (for macOS):
  ```bash
  brew install fswatch
  ```
- lcov installed (for HTML coverage reports with make open-coverage or make coverage-report):
  ```bash
  brew install lcov
  ```


## 📦 Available Makefile Commands

| Command               | Description                                                                                                 |
|:----------------------|:------------------------------------------------------------------------------------------------------------|
| `make help`           | Displays a help message listing available commands and their descriptions.                                  |
| `make format`         | Formats all Dart code in the project using `dart format .`.                                                 |
| `make analyze`        | Analyzes the project's Dart code for errors, warnings, and lints using `flutter analyze`.                   |
| `make check-all`      | Runs `format`, `analyze`, and `test-once` sequentially.                                                     |
| `make build`          | Runs a one-time build using `build_runner` to generate necessary files (`.g.dart`, etc.).                   |
| `make watch`          | Watches for file changes and rebuilds automatically using `build_runner`.                                   |
| `make l10n`           | Generates localization files using `flutter gen-l10n`.                                                      |
| `make test`           | Run all tests once (without coverage).                                                                      |
| `make test-once`      | Run all tests once and generate coverage data (`coverage/lcov.info`).                                       |
| `make test-watch`     | Watch for changes (`lib`, `test`) and rerun tests automatically (with coverage, requires `fswatch`).        |
| `make filter-lcov`    | Filters generated Dart files from the `lcov.info` coverage report.                                          |
| `make clean-coverage` | Delete the `coverage` directory.                                                                            |
| `make clean-l10n`     | Deletes generated localization files from `lib/core/localization/generated`.                                |
| `make clean-generated`| Deletes all generated Dart files (`*.g.dart`, `*.freezed.dart`, `*.gen.dart`).                              |
| `make clean-build`    | Deletes Flutter build artifacts and the `.dart_tool` directory.                                             |
| `make clean`          | Alias for `clean-all-generated`, `clean-coverage`, and `clean-build`.                                       |
| `make show-coverage`  | Toggle visibility of Coverage Gutters in VS Code (requires 'Coverage Gutters' extension).                   |
| `make open-coverage`  | Generate HTML coverage report from existing data and open it in the browser (requires `lcov`).              |
| `make coverage-report`| Run `test-once`, then generate the HTML report and open it in the browser (requires `lcov`).                |
| `make deep-clean`     | Perform full clean: Flutter, pub packages, iOS CocoaPods (incl. `pod install --repo-update` for Apple Silicon). |
| `make dev-clean`      | Switch to the `dev` Firebase environment and perform a full clean with CocoaPods reinstall.                 |
