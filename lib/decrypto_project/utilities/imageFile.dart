import 'dart:io';
import 'dart:ui' as ui show Codec;

import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart' hide Key;
import 'package:flutter/material.dart' hide Key;

@immutable
class EncryptedFileImage extends ImageProvider<EncryptedFileImage> {
  /// The file to decode into an image.
  final File file;

  /// The scale to place in the [ImageInfo] object of the image.
  final double scale;

  /// Creates an object that decodes a [File] as an image.
  /// The arguments must not be null.
  const EncryptedFileImage(
    this.file, {
    this.scale = 1.0,
  });

  @override
  Future<EncryptedFileImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<EncryptedFileImage>(this);
  }

  @override
  ImageStreamCompleter load(EncryptedFileImage key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      debugLabel: key.file.path,
      informationCollector: () => <DiagnosticsNode>[
        ErrorDescription('Path: ${file.path}'),
      ],
    );
  }

  Future<ui.Codec> _loadAsync(
      EncryptedFileImage key, DecoderCallback decode) async {
    final iv = IV(Uint8List.fromList([1]));
    final key = Key.fromUtf8("G-KaPdSgUkXp2s5v");
    final encryptedBytes = await file.readAsBytes();
    final bytes = AES(key).decrypt(Encrypted(encryptedBytes), iv: iv);

    if (bytes.lengthInBytes == 0) {
      // The file may become available later.
      PaintingBinding.instance.imageCache.evict(key);
      throw StateError('$file is empty and cannot be loaded as an image.');
    }

    return decode(bytes);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is EncryptedFileImage &&
        other.file.path == file.path &&
        other.scale == scale;
  }

  @override
  int get hashCode => hashValues(file.path, scale);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'FileImage')}("${file.path}", scale: $scale)';
}
