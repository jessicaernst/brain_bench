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
    store.requestAccess(for: .contacts) { granted, error in
      guard granted else {
        result(FlutterError(code: "PERMISSION_DENIED", message: "No access to contacts", details: nil))
        return
      }

      let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactImageDataKey] as [CNKeyDescriptor]
      let request = CNContactFetchRequest(keysToFetch: keys)

      var foundContact: CNContact?

      try? store.enumerateContacts(with: request) { contact, stop in
        if contact.contactType == .person && contact.imageData != nil {
          foundContact = contact
          stop.pointee = true
        }
      }

      guard let contact = foundContact else {
        result(nil)
        return
      }

      let name = "\(contact.givenName) \(contact.familyName)"
      let imageBase64 = contact.imageData?.base64EncodedString() ?? ""

      result([
        "name": name,
        "imageBase64": imageBase64
      ])
    }
  }
}