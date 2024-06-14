# integration test app

For testing Passage Flutter sdk on web,android and iOS


# Running Tests

# For Web Tests:
Start the ChromeDriver: chromedriver --port=4444
Install Node.js packages: 'npm install' and then start the proxy server: 'node proxy_server.js'

Run the tests with Flutter:

'flutter drive --driver=test_driver/integration_test.dart --target=integration_test/magic_link_test.dart -d chrome --web-port 4200'


# For Android/iOS Tests:
You can run tests directly from VS Code.
Or, you can run the tests from the command line: flutter test integration_test/magic_link_test.dart and then choose your emulator.
