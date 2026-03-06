import Foundation
import Security

// MARK: - Keychain Helper

/// Wraps Security framework Keychain operations for storing sensitive credentials.
/// Tokens stored here are protected by the device's Secure Enclave and are not
/// included in unencrypted iCloud backups.
enum KeychainHelper {
    private static let service = "com.openclaw.mobile"

    /// Saves a string value securely in the Keychain.
    /// Replaces any existing value for the same key.
    @discardableResult
    static func save(_ value: String, forKey key: String) -> Bool {
        let data = Data(value.utf8)
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key
        ]
        // Remove any existing item first so the add always succeeds
        SecItemDelete(query as CFDictionary)

        var attributes = query
        attributes[kSecValueData] = data
        // Only readable when device is unlocked; never migrated to other devices
        attributes[kSecAttrAccessible] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly

        let status = SecItemAdd(attributes as CFDictionary, nil)
        return status == errSecSuccess
    }

    /// Loads a string value from the Keychain. Returns nil if not found.
    static func load(forKey key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    /// Deletes a value from the Keychain.
    @discardableResult
    static func delete(forKey key: String) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}
