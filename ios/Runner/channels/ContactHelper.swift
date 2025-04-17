//
//  ContactHelper.swift
//  Runner
//
//  Created by Jessica Ernst on 15.04.25.
//


import Contacts
import Flutter

class ContactHelper {
  static func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "getUserContact":
        getUserContact(result: result)
      default:
        result(FlutterMethodNotImplemented)
    }
  }

  private static func getUserContact(result: @escaping FlutterResult) {
    let store = CNContactStore()

    // Request access to the user's contacts
    store.requestAccess(for: .contacts) { granted, error in
      guard granted else {
        // Return error if permission is denied, include details if available
        result(FlutterError(code: "PERMISSION_DENIED", message: "No access to contacts", details: error?.localizedDescription))
        return
      }

      // Define the contact fields to fetch: first name, last name, and profile image.
      // We are NOT fetching CNContactTypeKey anymore to avoid the potential crash.
      let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactImageDataKey] as [CNKeyDescriptor]
      let request = CNContactFetchRequest(keysToFetch: keys)

      var foundContact: CNContact? = nil
      var enumerationError: Error? = nil // Variable to store potential errors during enumeration

      // Use do-catch to handle errors that might occur during the enumeration process itself
      do {
          // Iterate through contacts.
          // ⚠️ WARNING: This logic finds the *first* contact with image data,
          // which is NOT guaranteed to be the user's "Me" card.
          try store.enumerateContacts(with: request) { contact, stop in
              // Check only if image data exists.
              // Accessing contact.contactType is avoided here to prevent the crash.
              if contact.imageData != nil {
                  foundContact = contact
                  stop.pointee = true // Stop after finding the first match
              }
          }
      } catch let error {
          // Catch errors specifically from the enumerateContacts call
          enumerationError = error
      }

      // --- Process the result ---
      if let contact = foundContact {
          // If a contact with image data was found
          let name = "\(contact.givenName) \(contact.familyName)"
          // Safely get base64 string, default to empty string if nil (though we checked for non-nil imageData)
          let imageBase64 = contact.imageData?.base64EncodedString() ?? ""

          // Return the contact data to Flutter
          result([
              "name": name,
              "imageBase64": imageBase64
          ])
      } else if let error = enumerationError {
          // If an error occurred during the enumeration process
          result(FlutterError(code: "ENUMERATION_ERROR", message: "Failed during contact enumeration", details: error.localizedDescription))
      } else {
          // If no contact with image data was found (and no error occurred)
          result(nil) // Indicate that no suitable contact was found
      }
    }
  }
}
