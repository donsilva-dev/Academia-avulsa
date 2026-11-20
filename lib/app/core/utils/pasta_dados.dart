import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class PastaDados {
  static const _raizWindows = r'D:\muscle_mania';

  static Future<File> arquivo({
    required String subpasta,
    required String nome,
  }) async {
    final Directory pasta;

    if (Platform.isWindows) {
      pasta = Directory('$_raizWindows\\$subpasta');
    } else {
      final base = await getApplicationSupportDirectory();
      pasta = Directory('${base.path}${Platform.pathSeparator}$subpasta');
    }

    if (!await pasta.exists()) {
      await pasta.create(recursive: true);
    }

    return File('${pasta.path}${Platform.pathSeparator}$nome');
  }
}
