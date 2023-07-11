import 'package:collection/collection.dart';

class BillPoint {
  final double x;
  final double y;
  BillPoint({required this.x, required this.y});
}

List<BillPoint> get billPoints {
  final data = <double>[
    0,
    100,
    200,
    300,
    400,
  ];
  return data
      .mapIndexed(
          ((index, element) => BillPoint(x: index.toDouble(), y: element)))
      .toList();
}
