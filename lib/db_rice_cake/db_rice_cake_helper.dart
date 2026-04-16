import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/slide_item.dart';
import '../models/work_record.dart';

class DbRiceCakeHelper {
  DbRiceCakeHelper._();
  static final DbRiceCakeHelper instance = DbRiceCakeHelper._();

  Database? _db;

  Future<void> init() async {
    final dir = await getDatabasesPath();
    _db = await openDatabase(
      p.join(dir, 'rice_cake.db'),
      version: 5,
      onCreate: (Database db, int version) async {
        await _createSettings(db);
        await _createWorks(db);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await _createWorksLegacy(db);
          await _seedWorksIfEmptyLegacy(db);
        }
        if (oldVersion < 3) {
          await _migrateWorksToV3(db);
        }
        if (oldVersion < 4) {
          await db.delete(
            'works',
            where: 'id IN (?, ?, ?, ?)',
            whereArgs: <Object>['w1', 'w2', 'w3', 'w4'],
          );
        }
        if (oldVersion < 5) {
          await _migrateWorksLocaleToEnglish(db);
        }
      },
    );
  }

  static Future<void> _createSettings(Database db) async {
    await db.execute('''
      CREATE TABLE app_settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  static Future<void> _createWorksLegacy(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS works (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        author TEXT NOT NULL DEFAULT 'Me',
        tag TEXT NOT NULL,
        template_id TEXT NOT NULL,
        cover_path TEXT,
        slides_json TEXT NOT NULL DEFAULT '[]',
        likes INTEGER NOT NULL DEFAULT 0,
        views INTEGER NOT NULL DEFAULT 0,
        is_draft INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        cover_color INTEGER
      )
    ''');
  }

  static Future<void> _createWorks(Database db) async {
    await db.execute('''
      CREATE TABLE works (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        author TEXT NOT NULL DEFAULT 'Me',
        tag TEXT NOT NULL,
        template_id TEXT NOT NULL,
        cover_path TEXT,
        slides_json TEXT NOT NULL DEFAULT '[]',
        views INTEGER NOT NULL DEFAULT 0,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        is_draft INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        cover_color INTEGER
      )
    ''');
  }

  static Future<void> _migrateWorksToV3(Database db) async {
    final List<Map<String, Object?>> tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='works'",
    );
    if (tables.isEmpty) {
      await _createWorks(db);
      return;
    }
    await db.execute('''
CREATE TABLE works_new (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  author TEXT NOT NULL DEFAULT 'Me',
  tag TEXT NOT NULL,
  template_id TEXT NOT NULL,
  cover_path TEXT,
  slides_json TEXT NOT NULL DEFAULT '[]',
  views INTEGER NOT NULL DEFAULT 0,
  is_favorite INTEGER NOT NULL DEFAULT 0,
  is_draft INTEGER NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  cover_color INTEGER
)
''');
    await db.execute('''
INSERT INTO works_new (id, title, author, tag, template_id, cover_path, slides_json, views, is_favorite, is_draft, created_at, updated_at, cover_color)
SELECT id, title, author, tag, template_id, cover_path, slides_json, COALESCE(views, 0), 0, is_draft, created_at, updated_at, cover_color FROM works
''');
    await db.execute('DROP TABLE works');
    await db.execute('ALTER TABLE works_new RENAME TO works');
  }

  static Future<void> _migrateWorksLocaleToEnglish(Database db) async {
    const List<List<String>> pairs = <List<String>>[
      <String>['\u4eb2\u5b50', 'Family'],
      <String>['\u751f\u65e5', 'Birthday'],
      <String>['\u751f\u6d3b', 'Life'],
      <String>['\u65c5\u6e38', 'Travel'],
      <String>['\u805a\u4f1a', 'Gathering'],
      <String>['\u98ce\u666f', 'Landscape'],
      <String>['\u8282\u65e5', 'Holiday'],
    ];
    for (final List<String> p in pairs) {
      final String cn = p[0];
      final String en = p[1];
      await db.update('works', <String, Object?>{'tag': en}, where: 'tag = ?', whereArgs: <Object>[cn]);
      await db.update(
        'works',
        <String, Object?>{'template_id': en},
        where: 'template_id = ?',
        whereArgs: <Object>[cn],
      );
    }
    await db.update(
      'works',
      <String, Object?>{'author': 'Me'},
      where: 'author = ?',
      whereArgs: <Object>['\u6211'],
    );
    await db.update(
      'works',
      <String, Object?>{'title': 'Untitled montage'},
      where: 'title = ?',
      whereArgs: <Object>['\u672a\u547d\u540d\u5f71\u96c6'],
    );
  }

  static Future<void> _seedWorksIfEmptyLegacy(Database db) async {
    final n = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM works'));
    if (n != null && n > 0) {
      return;
    }
  }

  Database get db {
    final d = _db;
    if (d == null) {
      throw StateError('Database not initialized. Call init() first.');
    }
    return d;
  }

  Future<String?> getSetting(String key) async {
    final rows = await db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: <Object>[key],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['value'] as String?;
  }

  Future<void> setSetting(String key, String value) async {
    await db.insert(
      'app_settings',
      <String, Object>{'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String> createDraftWork({required String tag, String? title}) async {
    final String id = 'w_${DateTime.now().millisecondsSinceEpoch}';
    final int now = DateTime.now().millisecondsSinceEpoch;
    await db.insert('works', <String, Object?>{
      'id': id,
      'title': title ?? 'Untitled montage',
      'author': 'Me',
      'tag': tag,
      'template_id': tag,
      'cover_path': null,
      'slides_json': SlideItem.encodeList(<SlideItem>[]),
      'views': 0,
      'is_favorite': 0,
      'is_draft': 1,
      'created_at': now,
      'updated_at': now,
    });
    return id;
  }

  Future<WorkRecord?> getWork(String id) async {
    final rows = await db.query('works', where: 'id = ?', whereArgs: <Object>[id], limit: 1);
    if (rows.isEmpty) return null;
    return WorkRecord.fromMap(rows.first);
  }

  Future<void> saveWork(WorkRecord record) async {
    await db.insert(
      'works',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteWork(String id) async {
    await db.delete('works', where: 'id = ?', whereArgs: <Object>[id]);
  }

  Future<List<WorkRecord>> listWorks({
    bool? isDraft,
    bool? favoriteOnly,
    int? limit,
    String orderBy = 'created_at DESC',
  }) async {
    final List<String> clauses = <String>[];
    final List<Object> args = <Object>[];
    if (isDraft != null) {
      clauses.add('is_draft = ?');
      args.add(isDraft ? 1 : 0);
    }
    if (favoriteOnly == true) {
      clauses.add('is_favorite = 1');
    }
    final String where = clauses.isEmpty ? '' : clauses.join(' AND ');
    final rows = await db.query(
      'works',
      where: where.isEmpty ? null : where,
      whereArgs: args.isEmpty ? null : args,
      orderBy: orderBy,
      limit: limit,
    );
    return rows.map(WorkRecord.fromMap).toList();
  }

  Future<List<String>> distinctPublishedTags() async {
    final rows = await db.rawQuery(
      'SELECT DISTINCT tag FROM works WHERE is_draft = 0 AND tag IS NOT NULL AND tag != ? ORDER BY tag ASC',
      <Object>[''],
    );
    return rows
        .map((Map<String, Object?> e) => e['tag'] as String)
        .where((String s) => s.trim().isNotEmpty)
        .toList();
  }

  Future<int> countWorks({required bool draft}) async {
    final n = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM works WHERE is_draft = ?', <Object>[draft ? 1 : 0]),
    );
    return n ?? 0;
  }

  Future<int> countFavoriteWorks() async {
    final n = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM works WHERE is_draft = 0 AND is_favorite = 1'),
    );
    return n ?? 0;
  }

  Future<int> countDistinctDaysWithWorks() async {
    final rows = await db.rawQuery(
      'SELECT COUNT(DISTINCT date(created_at/1000, "unixepoch")) AS c FROM works WHERE is_draft = 0',
    );
    return Sqflite.firstIntValue(rows) ?? 0;
  }

  Future<List<int>> weeklyCreateCounts() async {
    final List<int> out = <int>[];
    final DateTime today = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      final DateTime day = DateTime(today.year, today.month, today.day).subtract(Duration(days: i));
      final int start = day.millisecondsSinceEpoch;
      final int end = day.add(const Duration(days: 1)).millisecondsSinceEpoch;
      final n = Sqflite.firstIntValue(
        await db.rawQuery(
          'SELECT COUNT(*) FROM works WHERE is_draft = 0 AND created_at >= ? AND created_at < ?',
          <Object>[start, end],
        ),
      );
      out.add(n ?? 0);
    }
    return out;
  }
}
