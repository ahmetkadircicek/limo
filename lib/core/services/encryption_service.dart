import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:limo/core/utils/logger_service.dart';
import 'package:limo/shared/constants/app_constants.dart';
import 'package:pointycastle/export.dart';

/// Service for encrypting and decrypting API data using AES-256-CBC
/// Compatible with Node.js backend encryption service
class EncryptionService {
  static const String _tag = 'ENCRYPTION_SERVICE';
  static const int _ivLength = 16;
  static const int _keyLength = 32; // 256 bit

  /// Initialize encryption service with key from environment
  static Future<void> initialize() async {
    final key = AppConstants.aesKey;

    if (key.isNotEmpty) {
      final keyBytes = base64Decode(key);
      LoggerService.info(
        'AES key loaded successfully: ${key.substring(0, 8)}...${key.substring(key.length - 8)} (${keyBytes.length} bytes)',
        tag: _tag,
      );

      // Log key details
      LoggerService.debug('Full AES key (base64): $key', tag: _tag);
    } else {
      LoggerService.error('AES key is empty or not loaded', tag: _tag);
    }
  }

  /// Get current key bytes for cryptographic operations
  static Uint8List _getKeyBytes() {
    return base64Decode(AppConstants.aesKey);
  }

  /// Encrypt text data
  static String encrypt(String plaintext) {
    try {
      LoggerService.info(
        'Encrypting data with AES: ${plaintext.length} characters',
        tag: _tag,
      );
      final result = _encryptAES(plaintext);
      LoggerService.success(
        'Data encrypted successfully with AES: ${result.length} characters',
        tag: _tag,
      );
      return result;
    } catch (e) {
      LoggerService.error('AES encryption failed: $e', error: e, tag: _tag);
      rethrow;
    }
  }

  /// Decrypt text data
  static String decrypt(String encryptedData) {
    try {
      LoggerService.info(
        'Decrypting data with AES: ${encryptedData.length} characters',
        tag: _tag,
      );
      final result = _decryptAES(encryptedData);
      LoggerService.success(
        'Data decrypted successfully with AES: ${result.length} characters',
        tag: _tag,
      );
      return result;
    } catch (e) {
      LoggerService.error('AES decryption failed: $e', error: e, tag: _tag);
      rethrow;
    }
  }

  /// Encrypt JSON data
  static String encryptJson(Map<String, dynamic> data) {
    final jsonString = jsonEncode(data);
    return encrypt(jsonString);
  }

  /// Decrypt JSON data
  static Map<String, dynamic>? decryptJson(String encryptedData) {
    try {
      final decryptedString = decrypt(encryptedData);
      return jsonDecode(decryptedString) as Map<String, dynamic>;
    } catch (e) {
      LoggerService.error('JSON decryption failed: $e', error: e, tag: _tag);
      return null;
    }
  }

  /// Decrypt raw encrypted data and return as Map<String, dynamic>
  /// This method handles the case where response body is raw encrypted data
  static Map<String, dynamic>? decryptRawResponse(String encryptedData) {
    try {
      LoggerService.info(
        'Decrypting raw encrypted response: ${encryptedData.length} characters',
        tag: _tag,
      );

      // Clean and sanitize input before decryption
      final cleanedInput = _cleanInput(encryptedData);
      LoggerService.debug(
        'Input cleaned: ${encryptedData.length} -> ${cleanedInput.length} characters',
        tag: _tag,
      );

      // Decrypt the cleaned data
      final decryptedString = _decryptAES(cleanedInput);

      // Parse the decrypted JSON
      final decryptedData = jsonDecode(decryptedString) as Map<String, dynamic>;

      LoggerService.success(
        'Raw encrypted response decrypted and parsed successfully',
        tag: _tag,
      );

      return decryptedData;
    } catch (e) {
      LoggerService.error(
        'Raw response decryption failed: $e',
        error: e,
        tag: _tag,
      );
      return null;
    }
  }

  /// Clean and sanitize input string before decryption
  static String _cleanInput(String input) {
    String cleaned = input;

    // Remove leading/trailing whitespace
    cleaned = cleaned.trim();

    // Remove surrounding quotes if present
    if (cleaned.startsWith('"') && cleaned.endsWith('"')) {
      cleaned = cleaned.substring(1, cleaned.length - 1);
      LoggerService.debug('Removed surrounding quotes from input', tag: _tag);
    }

    // Remove any remaining quotes
    cleaned = cleaned.replaceAll('"', '');

    // Remove any remaining whitespace
    cleaned = cleaned.trim();

    // Validate base64 format after cleaning
    final base64Regex = RegExp(r'^[A-Za-z0-9+/=]+$');
    if (!base64Regex.hasMatch(cleaned)) {
      LoggerService.warning(
        'Input is not valid base64 format after cleaning',
        tag: _tag,
      );
    }

    return cleaned;
  }

  /// Internal AES encryption
  static String _encryptAES(String plaintext) {
    final key = _getKeyBytes();
    final data = utf8.encode(plaintext);

    // Log key information for debugging
    LoggerService.debug(
      'Using AES key: ${base64Encode(key).substring(0, 8)}...${base64Encode(key).substring(base64Encode(key).length - 8)} (length: ${key.length} bytes)',
      tag: _tag,
    );

    // Generate random IV
    final random = Random.secure();
    final iv = Uint8List(_ivLength);
    for (int i = 0; i < _ivLength; i++) {
      iv[i] = random.nextInt(256);
    }

    // Log IV for debugging
    LoggerService.debug('Generated IV: ${base64Encode(iv)}', tag: _tag);

    // Initialize cipher
    final cipher = CBCBlockCipher(AESEngine());
    final params = ParametersWithIV(KeyParameter(key), iv);
    cipher.init(true, params);

    // Add PKCS7 padding
    final blockSize = 16;
    final paddingLength = blockSize - (data.length % blockSize);
    final paddedData = Uint8List(data.length + paddingLength);
    paddedData.setRange(0, data.length, data);
    paddedData.fillRange(data.length, paddedData.length, paddingLength);

    // Encrypt
    final output = Uint8List(paddedData.length);
    int offset = 0;
    for (int i = 0; i < paddedData.length; i += blockSize) {
      final block = paddedData.sublist(i, i + blockSize);
      offset += cipher.processBlock(block, 0, output, offset);
    }

    // Format as iv:encrypted
    final ivBase64 = base64Encode(iv);
    final ciphertextBase64 = base64Encode(output);
    return '$ivBase64:$ciphertextBase64';
  }

  /// Internal AES decryption
  static String _decryptAES(String encryptedData) {
    // Parse iv:encrypted format
    final parts = encryptedData.split(':');
    if (parts.length != 2) {
      throw Exception('Invalid encrypted data format');
    }

    final iv = base64Decode(parts[0]);
    final ciphertext = base64Decode(parts[1]);
    final key = _getKeyBytes();

    // Initialize cipher
    final cipher = CBCBlockCipher(AESEngine());
    final params = ParametersWithIV(KeyParameter(key), Uint8List.fromList(iv));
    cipher.init(false, params);

    // Decrypt
    final output = Uint8List(ciphertext.length);
    int offset = 0;
    for (int i = 0; i < ciphertext.length; i += 16) {
      final block = ciphertext.sublist(i, i + 16);
      offset += cipher.processBlock(block, 0, output, offset);
    }

    // Remove PKCS7 padding
    final paddingLength = output[output.length - 1];
    final unpadded = output.sublist(0, output.length - paddingLength);

    return utf8.decode(unpadded);
  }

  /// Create encrypted API request payload
  static Map<String, dynamic> encryptRequest(Map<String, dynamic> data) {
    final encryptedData = encryptJson(data);
    return {'encryptedData': encryptedData};
  }

  /// Decrypt API response payload
  static Map<String, dynamic>? decryptResponse(Map<String, dynamic> response) {
    if (!response.containsKey('encryptedData')) {
      LoggerService.warning(
        'Response does not contain encryptedData field',
        tag: _tag,
      );
      return null;
    }

    final encryptedData = response['encryptedData'] as String;
    return decryptJson(encryptedData);
  }

  /// Get encryption service information
  static Map<String, dynamic> getEncryptionInfo() {
    return {
      'enabled': AppConstants.aesKey.isNotEmpty,
      'algorithm': 'AES-256-CBC',
      'iv_length': _ivLength,
      'key_length_bytes': _keyLength,
      'version': '1.0',
    };
  }
}
