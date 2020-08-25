part of '../transform.dart';

const _baiduFactor = pi * 3000.0 / 180.0;

Position _BD09ToGCJ02(Position coord) {
  final x = coord.longitude - 0.0065;
  final y = coord.latitude - 0.006;
  final z = sqrt(x * x + y * y) - 0.00002 * sin(y * _baiduFactor);
  final theta = atan2(y, x) - 0.000003 * cos(x * _baiduFactor);
  final newLng = z * cos(theta);
  final newLat = z * sin(theta);
  return Position(newLng, newLat);
}

Position _GCJ02ToBD09(Position coord) {
  final z = sqrt(coord.longitude * coord.longitude + coord.latitude * coord.latitude) + 0.00002 * sin(coord.latitude * _baiduFactor);
  final theta = atan2(coord.latitude, coord.longitude) + 0.000003 * cos(coord.longitude * _baiduFactor);

  final newLng = z * cos(theta) + 0.0065;
  final newLat = z * sin(theta) + 0.006;

  return Position(newLng, newLat);
}
