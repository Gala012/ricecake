import 'dart:convert';

class SlideItem {
  SlideItem({required this.path, this.caption = ''});

  final String path;
  final String caption;

  Map<String, dynamic> toJson() => <String, dynamic>{'path': path, 'caption': caption};

  static SlideItem fromJson(Map<String, dynamic> j) {
    return SlideItem(
      path: j['path'] as String,
      caption: (j['caption'] as String?) ?? '',
    );
  }

  static List<SlideItem> listFromJson(String raw) {
    if (raw.isEmpty || raw == '[]') return <SlideItem>[];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((dynamic e) => fromJson(e as Map<String, dynamic>)).toList();
  }

  static String encodeList(List<SlideItem> slides) {
    return jsonEncode(slides.map((SlideItem e) => e.toJson()).toList());
  }
}
