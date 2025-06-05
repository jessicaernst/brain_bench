import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

final _logger = Logger('ContactChannel');

/// Represents the contact information fetched from the native device.
class DeviceContactInfo {
  final String? name;
  final String? imageBase64; // Base64 encoded image data as a String

  DeviceContactInfo({this.name, this.imageBase64});

  @override
  String toString() {
    return 'DeviceContactInfo(name: ${name ?? "N/A"}, imageAvailable: ${imageBase64 != null && imageBase64!.isNotEmpty})';
  }
}

/// Handles communication with the native iOS code to fetch user contact details.
class ContactChannel {
  /// The name of the method channel. MUST match the one used in AppDelegate.swift.
  static const String _channelName = 'de.jessicaernst.brainbench/contacts';

  /// The MethodChannel instance used to communicate with the native platform.
  static const MethodChannel _channel = MethodChannel(_channelName);

  /// Fetches the user's contact info (name and image as base64) from the native side (iOS).
  ///
  /// Invokes the 'getUserContact' method on the native channel.
  /// Returns a [DeviceContactInfo] object containing the name and base64 image string
  /// if successful and contact info is available.
  /// Returns null if permission is denied, no contact is found/set up, or an error occurs.
  static Future<DeviceContactInfo?> getUserContactFromDevice({
    String? userEmail,
  }) async {
    try {
      _logger.info(
        'Invoking native method "getUserContact" on channel "$_channelName" with email: ${userEmail ?? "N/A"}.',
      );

      // Invoke the method. Expect a Map<String, String?> or null from Swift.
      // Using Map<Object?, Object?> for broader compatibility initially.
      final result = await _channel.invokeMethod<Map<Object?, Object?>>(
        'getUserContact',
        // Pass the email as an argument to the native method
        // The native side (Swift) will expect a dictionary with an "email" key.
        {'email': userEmail},
      );

      if (result == null) {
        // This likely means no contact was found or set up on the device.
        _logger.info(
          '"getUserContact" returned null. No contact found or permission issue previously handled by native code.',
        );
        return null;
      }

      // Safely cast the results from the map.
      final name = result['name'] as String?;
      final imageBase64 = result['imageBase64'] as String?;

      final contactInfo = DeviceContactInfo(
        name: name,
        imageBase64: imageBase64,
      );

      _logger.info('"getUserContact" successful. Result: $contactInfo');
      return contactInfo;
    } on PlatformException catch (e) {
      // Handle errors sent from the native side
      _logger.severe(
        'PlatformException while calling "getUserContact": ${e.code} - ${e.message}',
        e,
      );
      if (e.code == 'PERMISSION_DENIED') {
        _logger.warning(
          'Contact permission was denied by the user (reported by native code).',
        );
      } else if (e.code == 'PERMISSION_ERROR') {
        _logger.warning(
          'Error during contact permission request (reported by native code).',
        );
      } else if (e.code == 'FETCH_ERROR') {
        _logger.warning(
          'Error fetching contact data (reported by native code).',
        );
      }
      return null; // Return null on known errors or permission denial.
    } catch (e, st) {
      _logger.severe('Unexpected error calling "getUserContact": $e', e, st);
      return null;
    }
  }
}
