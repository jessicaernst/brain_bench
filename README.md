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
| `make test`           | Run all tests once (without coverage).                                                                      |
| `make test-once`      | Run all tests once and generate coverage data (`coverage/lcov.info`).                                       |
| `make test-watch`     | Watch for changes (`lib`, `test`) and rerun tests automatically (with coverage, requires `fswatch`).        |
| `make clean-coverage` | Delete the `coverage` directory.                                                                            |
| `make show-coverage`  | Toggle visibility of Coverage Gutters in VS Code (requires 'Coverage Gutters' extension).                   |
| `make open-coverage`  | Generate HTML coverage report from existing data and open it in the browser (requires `lcov`).              |
| `make coverage-report`| Run `test-once`, then generate the HTML report and open it in the browser (requires `lcov`).                |
| `make deep-clean`     | Perform full clean: Flutter, pub packages, iOS CocoaPods (incl. `pod install --repo-update` for Apple Silicon). |
| `make dev-clean`      | Switch to the `dev` Firebase environment and perform a full clean with CocoaPods reinstall.                 |


