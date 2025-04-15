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

    // Request access to the user's contacts (required to access even their own card)
    store.requestAccess(for: .contacts) { granted, error in
      guard granted else {
        result(FlutterError(code: "PERMISSION_DENIED", message: "No access to contacts", details: nil))
        return
      }

      // Define the contact fields to fetch: first name, last name, and profile image
      let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactImageDataKey] as [CNKeyDescriptor]
      let request = CNContactFetchRequest(keysToFetch: keys)

      var foundContact: CNContact?

      // Iterate through contacts and stop at the first one that has an image
      // ⚠️ This is intended to retrieve the user's own contact card ("Me" card),
      // assuming it is properly set and includes an image
      try? store.enumerateContacts(with: request) { contact, stop in
        if contact.contactType == .person && contact.imageData != nil {
          foundContact = contact
          stop.pointee = true
        }
      }

      // Return nil if no suitable contact was found
      guard let contact = foundContact else {
        result(nil)
        return
      }

      // Build the result: full name and base64-encoded image
      let name = "\(contact.givenName) \(contact.familyName)"
      let imageBase64 = contact.imageData?.base64EncodedString() ?? ""

      // Return the contact data to Flutter
      result([
        "name": name,
        "imageBase64": imageBase64
      ])
    }
  }
}
