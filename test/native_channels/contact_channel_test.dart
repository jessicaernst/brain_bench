// Adjust the import path based on your project structure
import 'package:brain_bench/core/native_channels/contact_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Ensure Flutter bindings are initialized for platform channel mocking
  TestWidgetsFlutterBinding.ensureInitialized();

  // Define the channel consistently with the class
  const MethodChannel channel =
      MethodChannel('de.jessicaernst.brainbench/contacts');

  // Helper function to set up the mock handler for the channel
  void setupMockHandler(Future<dynamic> Function(MethodCall call)? handler) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, handler);
  }

  // Clear the mock handler after each test to prevent interference
  tearDown(() {
    setupMockHandler(null);
  });

  group('ContactChannel', () {
    group('getUserContactFromDevice', () {
      test(
          'should return DeviceContactInfo when native call succeeds with full data',
          () async {
        // Arrange: Mock a successful response with name and image
        final mockResponse = <String, String?>{
          'name': 'Test User',
          'imageBase64': 'base64string123',
        };
        setupMockHandler((MethodCall methodCall) async {
          if (methodCall.method == 'getUserContact') {
            return mockResponse;
          }
          return null; // Should not happen in this test
        });

        // Act: Call the method under test
        final result = await ContactChannel.getUserContactFromDevice();

        // Assert: Verify the result is correct
        expect(result, isA<DeviceContactInfo>());
        expect(result?.name, 'Test User');
        expect(result?.imageBase64, 'base64string123');
      });

      test(
          'should return DeviceContactInfo with null fields when native call succeeds with missing data',
          () async {
        // Arrange: Mock a successful response but with null values
        final mockResponse = <String, String?>{
          'name': null,
          'imageBase64': null,
        };
        setupMockHandler((MethodCall methodCall) async {
          if (methodCall.method == 'getUserContact') {
            return mockResponse;
          }
          return null;
        });

        // Act
        final result = await ContactChannel.getUserContactFromDevice();

        // Assert
        expect(result, isA<DeviceContactInfo>());
        expect(result?.name, isNull);
        expect(result?.imageBase64, isNull);
      });

      test(
          'should return DeviceContactInfo with mixed null/non-null fields when native call succeeds',
          () async {
        // Arrange: Mock a successful response with only name
        final mockResponse = <String, String?>{
          'name': 'Only Name',
          'imageBase64': null,
        };
        setupMockHandler((MethodCall methodCall) async {
          if (methodCall.method == 'getUserContact') {
            return mockResponse;
          }
          return null;
        });

        // Act
        final result = await ContactChannel.getUserContactFromDevice();

        // Assert
        expect(result, isA<DeviceContactInfo>());
        expect(result?.name, 'Only Name');
        expect(result?.imageBase64, isNull);
      });

      test(
          'should return null when native call returns null (e.g., no contact found)',
          () async {
        // Arrange: Mock the native method returning null
        setupMockHandler((MethodCall methodCall) async {
          if (methodCall.method == 'getUserContact') {
            return null;
          }
          return null;
        });

        // Act
        final result = await ContactChannel.getUserContactFromDevice();

        // Assert
        expect(result, isNull);
      });

      test(
          'should return null when PlatformException with PERMISSION_DENIED occurs',
          () async {
        // Arrange: Mock the native method throwing a specific PlatformException
        setupMockHandler((MethodCall methodCall) async {
          if (methodCall.method == 'getUserContact') {
            throw PlatformException(
                code: 'PERMISSION_DENIED',
                message: 'Permission denied by user');
          }
          return null;
        });

        // Act
        final result = await ContactChannel.getUserContactFromDevice();

        // Assert
        expect(result, isNull);
      });

      test('should return null when PlatformException with FETCH_ERROR occurs',
          () async {
        // Arrange: Mock the native method throwing a specific PlatformException
        setupMockHandler((MethodCall methodCall) async {
          if (methodCall.method == 'getUserContact') {
            throw PlatformException(
                code: 'FETCH_ERROR', message: 'Error during fetch');
          }
          return null;
        });

        // Act
        final result = await ContactChannel.getUserContactFromDevice();

        // Assert
        expect(result, isNull);
      });

      test(
          'should return null when PlatformException with PERMISSION_ERROR occurs',
          () async {
        // Arrange: Mock the native method throwing a specific PlatformException
        setupMockHandler((MethodCall methodCall) async {
          if (methodCall.method == 'getUserContact') {
            throw PlatformException(
                code: 'PERMISSION_ERROR',
                message: 'Error during permission request');
          }
          return null;
        });

        // Act
        final result = await ContactChannel.getUserContactFromDevice();

        // Assert
        expect(result, isNull);
      });

      test('should return null when an unknown PlatformException occurs',
          () async {
        // Arrange: Mock the native method throwing an unknown PlatformException
        setupMockHandler((MethodCall methodCall) async {
          if (methodCall.method == 'getUserContact') {
            throw PlatformException(
                code: 'UNEXPECTED_NATIVE_ERROR',
                message: 'Something went wrong');
          }
          return null;
        });

        // Act
        final result = await ContactChannel.getUserContactFromDevice();

        // Assert
        expect(result, isNull);
      });

      test(
          'should return null when a generic Exception occurs during channel communication',
          () async {
        // Arrange: Mock the native method throwing a generic Exception
        setupMockHandler((MethodCall methodCall) async {
          if (methodCall.method == 'getUserContact') {
            throw Exception('Some generic error');
          }
          return null;
        });

        // Act
        final result = await ContactChannel.getUserContactFromDevice();

        // Assert
        expect(result, isNull);
      });
    });
  });
}
