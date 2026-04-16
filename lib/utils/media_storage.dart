import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class MediaStorage {
  static Future<String> copyPickToWorkDir(String workId, String sourcePath, {String? suggestedName}) async {
    final Directory docs = await getApplicationDocumentsDirectory();
    final Directory dir = Directory(p.join(docs.path, 'rice_cake', 'media', workId));
    await dir.create(recursive: true);
    final String base = suggestedName != null && suggestedName.isNotEmpty
        ? suggestedName
        : p.basename(sourcePath);
    final String unique = '${DateTime.now().microsecondsSinceEpoch}_$base';
    final String destPath = p.join(dir.path, unique);
    await File(sourcePath).copy(destPath);
    return destPath;
  }
}
