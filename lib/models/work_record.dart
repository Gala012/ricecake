import 'dart:io';

import 'package:flutter/material.dart';

import 'slide_item.dart';

class WorkRecord {
  WorkRecord({
    required this.id,
    required this.title,
    required this.author,
    required this.tag,
    required this.templateId,
    this.coverPath,
    required this.slides,
    required this.isFavorite,
    required this.views,
    required this.isDraft,
    required this.createdAt,
    required this.updatedAt,
    this.coverColorValue,
  });

  final String id;
  final String title;
  final String author;
  final String tag;
  final String templateId;
  final String? coverPath;
  final List<SlideItem> slides;
  final bool isFavorite;
  final int views;
  final bool isDraft;
  final int createdAt;
  final int updatedAt;
  final int? coverColorValue;

  String? get effectiveCoverPath {
    final c = coverPath;
    if (c != null && c.isNotEmpty && File(c).existsSync()) return c;
    for (final s in slides) {
      if (s.path.isNotEmpty && File(s.path).existsSync()) return s.path;
    }
    return null;
  }

  Color get placeholderColor {
    if (coverColorValue != null) return Color(coverColorValue!);
    final h = id.hashCode.abs();
    const palette = <int>[0xFFFFE4E6, 0xFFFECDD3, 0xFFFFEDD5, 0xFFE0E7FF, 0xFFF3F4F6];
    return Color(palette[h % palette.length]);
  }

  static bool _omitAuthorInUi(String raw) {
    final a = raw.trim();
    if (a.isEmpty) return true;
    final String lower = a.toLowerCase();
    return a.startsWith('\u672c\u5730\u7528\u6237') || lower.startsWith('local user');
  }

  String get displayAuthorOrTag {
    if (_omitAuthorInUi(author)) return tag;
    return author.trim();
  }

  String get tagAndOptionalAuthorLine {
    if (_omitAuthorInUi(author)) return tag;
    return '$tag · ${author.trim()}';
  }

  static WorkRecord fromMap(Map<String, Object?> m) {
    final slidesJson = m['slides_json'] as String? ?? '[]';
    return WorkRecord(
      id: m['id']! as String,
      title: m['title']! as String,
      author: (m['author'] as String?) ?? 'Me',
      tag: m['tag']! as String,
      templateId: (m['template_id'] as String?) ?? (m['tag']! as String),
      coverPath: m['cover_path'] as String?,
      slides: SlideItem.listFromJson(slidesJson),
      isFavorite: ((m['is_favorite'] as num?)?.toInt() ?? 0) == 1,
      views: (m['views'] as int?) ?? 0,
      isDraft: ((m['is_draft'] as num?)?.toInt() ?? 0) == 1,
      createdAt: m['created_at']! as int,
      updatedAt: m['updated_at']! as int,
      coverColorValue: m['cover_color'] as int?,
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'title': title,
      'author': author,
      'tag': tag,
      'template_id': templateId,
      'cover_path': coverPath,
      'slides_json': SlideItem.encodeList(slides),
      'is_favorite': isFavorite ? 1 : 0,
      'views': views,
      'is_draft': isDraft ? 1 : 0,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'cover_color': coverColorValue,
    };
  }

  WorkRecord copyWith({
    String? title,
    String? author,
    String? tag,
    String? templateId,
    String? coverPath,
    List<SlideItem>? slides,
    bool? isFavorite,
    int? views,
    bool? isDraft,
    int? updatedAt,
    int? coverColorValue,
  }) {
    return WorkRecord(
      id: id,
      title: title ?? this.title,
      author: author ?? this.author,
      tag: tag ?? this.tag,
      templateId: templateId ?? this.templateId,
      coverPath: coverPath ?? this.coverPath,
      slides: slides ?? this.slides,
      isFavorite: isFavorite ?? this.isFavorite,
      views: views ?? this.views,
      isDraft: isDraft ?? this.isDraft,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now().millisecondsSinceEpoch,
      coverColorValue: coverColorValue ?? this.coverColorValue,
    );
  }
}
