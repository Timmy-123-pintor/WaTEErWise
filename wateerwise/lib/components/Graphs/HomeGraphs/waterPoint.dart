import 'package:collection/collection.dart';

class WaterPoint {
  final double x;
  final double y;
  WaterPoint({required this.x, required this.y});
}

List<WaterPoint> get waterPoints {
  final data = <double>[2, 4, 6, 11, 3, 6, 4];
  return data
      .mapIndexed(
          ((index, element) => WaterPoint(x: index.toDouble(), y: element)))
      .toList();
}
