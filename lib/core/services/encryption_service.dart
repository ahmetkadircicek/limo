import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart' show debugPrint;

/// AES Encryption Service for secure data transmission
class EncryptionService {
  static EncryptionService? _instance;
  static EncryptionService get instance => _instance ??= EncryptionService._();

  EncryptionService._();

  // Encryption key (in production, this should be stored securely)
  static const String _secretKey = 'your-secret-key-here-32-chars-long!';

  /// Encrypt data using AES-256-CBC
  static String encryptData(String data) {
    debugPrint(
      '🔐 [ENCRYPTION] Starting AES encryption for data length: ${data.length}',
    );

    try {
      debugPrint('🔐 [ENCRYPTION] Generating random IV...');
      // Generate a random IV (Initialization Vector)
      final iv = IV.fromSecureRandom(16);
      debugPrint('✅ [ENCRYPTION] IV generated successfully');

      debugPrint('🔐 [ENCRYPTION] Creating encryption key...');
      // Create encryption key from secret
      final key = Key.fromUtf8(_secretKey);

      debugPrint('🔐 [ENCRYPTION] Creating AES encrypter...');
      // Create encrypter
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

      debugPrint('🔐 [ENCRYPTION] Encrypting data...');
      // Encrypt the data
      final encrypted = encrypter.encrypt(data, iv: iv);
      debugPrint('✅ [ENCRYPTION] Data encrypted successfully');

      debugPrint('🔐 [ENCRYPTION] Combining IV and encrypted data...');
      // Combine IV and encrypted data (IV + encrypted data)
      final combined = iv.bytes + encrypted.bytes;

      debugPrint('🔐 [ENCRYPTION] Converting to base64...');
      // Convert to base64 for safe transmission
      final result = base64.encode(combined);
      debugPrint('✅ [ENCRYPTION] Encryption completed successfully');
      return result;
    } catch (e) {
      debugPrint('❌ [ENCRYPTION] Encryption failed: $e');
      throw Exception('Encryption failed: $e');
    }
  }

  /// Decrypt data using AES-256-CBC
  static String decryptData(String encryptedData) {
    try {
      // Decode from base64
      final combined = base64.decode(encryptedData);

      // Extract IV (first 16 bytes) and encrypted data
      final iv = IV(combined.sublist(0, 16));
      final encryptedBytes = combined.sublist(16);

      // Create encryption key from secret
      final key = Key.fromUtf8(_secretKey);

      // Create encrypter
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

      // Create encrypted object
      final encrypted = Encrypted(encryptedBytes);

      // Decrypt the data
      return encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      throw Exception('Decryption failed: $e');
    }
  }
}
