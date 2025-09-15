import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageProcessorPage extends StatelessWidget {
  const ImageProcessorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AES-256 암복호화 테스트')),
      body: Center(
        child: ElevatedButton(
          child: const Text('로컬 파일 암복호화 실행'),
          onPressed: () async {
            const key = 'my-32-length-super-secret-key!'; // 32자
            const originalPath = r'C:\Users\snaptag_dev1\Snaptag\testImage\embeddingImage.bmp'; // 원본 로컬 이미지 경로

            final messenger = ScaffoldMessenger.of(context);

            try {
              final tempSubdir = await _createRandomTempSubdir();

              final encryptedPath = p.join(tempSubdir.path, 'encrypted.dat');
              final decryptedPath = p.join(tempSubdir.path, 'decrypted_image.png');

              // 1. 원본 이미지 파일 읽기
              final originalBytes = await File(originalPath).readAsBytes();

              // 2. 암호화 저장 (IV 포함)
              await saveEncrypted(originalBytes, encryptedPath, key);
              messenger.showSnackBar(SnackBar(content: Text('암호화 완료: $encryptedPath')));

              // 3. 복호화 + 시간 측정
              final stopwatch = Stopwatch()..start();
              final decrypted = await loadAndDecrypt(encryptedPath, key);
              stopwatch.stop();

              await File(decryptedPath).writeAsBytes(decrypted);

              messenger.showSnackBar(SnackBar(
                content: Text('복호화 완료 (${stopwatch.elapsedMilliseconds}ms): $decryptedPath'),
              ));
              print('복호화 완료 (${stopwatch.elapsedMilliseconds}ms): $decryptedPath');
            } catch (e) {
              messenger.showSnackBar(SnackBar(content: Text('오류 발생: $e')));
            }
          },
        ),
      ),
    );
  }

  Future<Directory> _createRandomTempSubdir() async {
    final tempDir = await getTemporaryDirectory();
    final random = _generateRandomString(11);
    final subdir = Directory(p.join(tempDir.path, random));
    if (!await subdir.exists()) {
      await subdir.create(recursive: true);
    }
    return subdir;
  }

  String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  Future<void> saveEncrypted(Uint8List data, String path, String keyString) async {
    final key = encrypt.Key.fromUtf8(keyString.padRight(32, '0'));
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    final encrypted = encrypter.encryptBytes(data, iv: iv);
    final output = iv.bytes + encrypted.bytes;
    await File(path).writeAsBytes(output);
  }

  Future<Uint8List> loadAndDecrypt(String path, String keyString) async {
    final fileBytes = await File(path).readAsBytes();
    final iv = encrypt.IV(fileBytes.sublist(0, 16));
    final encryptedBytes = fileBytes.sublist(16);

    final key = encrypt.Key.fromUtf8(keyString.padRight(32, '0'));
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    final decrypted = encrypter.decryptBytes(
      encrypt.Encrypted(encryptedBytes),
      iv: iv,
    );
    return Uint8List.fromList(decrypted);
  }
}
