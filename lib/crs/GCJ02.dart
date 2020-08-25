part of '../transform.dart';

const double _a = 6378245;
const double _ee = 0.006693421622965823;

Position _GCJ02ToWGS84(Position coord) {
  var lng = coord.longitude;
  var lat = coord.latitude;

  if (!_isInChinaBbox(lng, lat)) return Position(lng, lat);

  var wgsLng = coord.longitude;
  var wgsLat = coord.latitude;

  var temp = _WGS84ToGCJ02(Position(wgsLng, wgsLat));

  var iLng = temp.longitude;
  var iLat = temp.latitude;

  var dx = iLng - lng;
  var dy = iLat - lat;

  while (dx.abs() > 1e-6 || dy.abs() > 1e-6) {
    wgsLng -= dx;
    wgsLat -= dy;
    final temp = _WGS84ToGCJ02(Position(wgsLng, wgsLat));
    dx = temp.longitude - lng;
    dy = temp.latitude - lat;
  }

  return Position(wgsLng, wgsLat);
}

Position _WGS84ToGCJ02(Position coord) {
  var lng = coord.longitude;
  var lat = coord.latitude;
  if (!_isInChinaBbox(lng, lat)) return Position(lng, lat);

  var temp = _delta(lng, lat);

  var dLng = temp.longitude;
  var dLat = temp.latitude;

  return Position(lng + dLng, lat + dLat);
}

double _transformLat(double x, double y) {
  var ret = -100 + 2 * x + 3 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(x.abs());
  ret += (20 * sin(6 * x * pi) + 20 * sin(2 * x * pi)) * 2 / 3;
  ret += (20 * sin(y * pi) + 40 * sin(y / 3 * pi)) * 2 / 3;
  ret += (160 * sin(y / 12 * pi) + 320 * sin(y * pi / 30)) * 2 / 3;
  return ret;
}

double _transformLng(double x, double y) {
  var ret = 300 + x + 2 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(x.abs());
  ret += (20 * sin(6 * x * pi) + 20 * sin(2 * x * pi)) * 2 / 3;
  ret += (20 * sin(x * pi) + 40 * sin(x / 3 * pi)) * 2 / 3;
  ret += (150 * sin(x / 12 * pi) + 300 * sin(x / 30 * pi)) * 2 / 3;
  return ret;
}

Position _delta(double lng, double lat) {
  var dLng = _transformLng(lng - 105, lat - 35);
  var dLat = _transformLat(lng - 105, lat - 35);
  final radLat = lat / 180 * pi;
  var magic = sin(radLat);

  magic = 1 - _ee * magic * magic;

  final sqrtMagic = sqrt(magic);
  dLng = (dLng * 180) / (_a / sqrtMagic * cos(radLat) * pi);
  dLat = (dLat * 180) / ((_a * (1 - _ee)) / (magic * sqrtMagic) * pi);

  return Position(dLng, dLat);
}
