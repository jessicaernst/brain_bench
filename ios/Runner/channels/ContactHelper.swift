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
        // Extract email from arguments
        let arguments = call.arguments as? [String: Any]
        let email = arguments?["email"] as? String
        getUserContact(email: email, result: result)
      default:
        result(FlutterMethodNotImplemented)
    }
  }

  private static func getUserContact(email: String?, result: @escaping FlutterResult) {
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
      let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactImageDataKey, CNContactEmailAddressesKey] as [CNKeyDescriptor]
      let request = CNContactFetchRequest(keysToFetch: keys)
      
      var foundContact: CNContact?

      if let userEmail = email, !userEmail.isEmpty {
          // If email is provided, try to find a contact matching that email
          // Note: CNContact.predicateForContacts(matchingEmailAddress:) is not directly available.
          let trimmedUserEmail = userEmail.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
          
          // We need to enumerate and check email addresses.
          // Set predicate to nil to fetch all contacts, then we will filter by email manually.
          request.predicate = nil 
          do {
              try store.enumerateContacts(with: request) { contact, stop in
                  for emailEntry in contact.emailAddresses {
                      // Check if the email entry matches the provided email
                      let contactEmail = (emailEntry.value as String).trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                      // Compare the trimmed email addresses
                      if contactEmail == trimmedUserEmail {
                          foundContact = contact
                          stop.pointee = true 
                          return
                      }
                  }
              }
          } catch {
              result(FlutterError(code: "ENUMERATION_ERROR", message: "Failed during contact enumeration by email", details: error.localizedDescription))
              return
          }
      }

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
      } else {
          // If no contact with image data was found (and no error occurred)
          result(nil) // Indicate that no suitable contact was found or matched
      }
    }
  }
}
