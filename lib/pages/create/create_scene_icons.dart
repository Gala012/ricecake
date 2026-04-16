import 'package:flutter/material.dart';

IconData sceneIconForTag(String tag) {
  switch (tag) {
    case 'Family':
      return Icons.family_restroom_rounded;
    case 'Birthday':
      return Icons.cake_rounded;
    case 'Life':
      return Icons.home_rounded;
    case 'Travel':
      return Icons.flight_takeoff_rounded;
    case 'Gathering':
      return Icons.celebration_rounded;
    case 'Landscape':
      return Icons.landscape_rounded;
    case 'Holiday':
      return Icons.auto_awesome_rounded;
    default:
      return Icons.movie_creation_rounded;
  }
}

Color sceneTintForTag(String tag) {
  final int h = tag.hashCode.abs();
  const List<double> stops = <double>[0.0, 0.08, 0.04, 0.12, 0.06, 0.1, 0.05];
  return Color.lerp(
        const Color(0xFFFFF1F2),
        const Color(0xFFE11D48),
        stops[h % stops.length],
      ) ??
      const Color(0xFFFFF1F2);
}
