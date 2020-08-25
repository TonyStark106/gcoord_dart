import 'dart:convert';
import 'package:test/test.dart';
import 'package:gcoord_dart/gcoord_dart.dart';
import 'package:extended_math/extended_math.dart';
import 'package:geo/geo.dart';
import 'cities_test.dart';

class Case {
  final Position WGS84;
  final Position GCJ02;
  final Position BD09;

  Case(this.WGS84, this.GCJ02, this.BD09);
}

Position _createPosition(List<double> pArr) => Position(pArr[0], pArr[1]);

void main() {
  test('', () async {
    await testTransform();
  });
}

Future<List<Case>> getCaseList() async {
  final cases = json.decode(citiesText)
      .map((c) {
    final temp = c['coords'];
    return Case(
      _createPosition(List.from(temp['WGS84'])),
      _createPosition(List.from(temp['GCJ02'])),
      _createPosition(List.from(temp['BD09'])),
    );
  })
      .toList(growable: false);
  return List.castFrom(cases);
}

void println(String text) {
  if (text != null) { print(text); }
  print('\n');
}

void testTransformInstance(List<Case> cases, CRS crsFrom, CRS crsTo) async {
  final start = DateTime.now().millisecondsSinceEpoch;
  final data = Vector(cases.map((c) {
    Position a, b;
    switch (crsTo) {
      case CRS.WGS84:
        a = c.WGS84;
        break;
      case CRS.GCJ02:
        a = c.GCJ02;
        break;
      case CRS.BD09:
        a = c.BD09;
        break;
    }
    switch (crsFrom) {
      case CRS.WGS84:
        b = c.WGS84;
        break;
      case CRS.GCJ02:
        b = c.GCJ02;
        break;
      case CRS.BD09:
        b = c.BD09;
        break;
    }
    final res = transform(b, crsFrom, crsTo);
    final distance = computeDistanceBetween(LatLng(a.latitude, a.longitude), LatLng(res.latitude, res.longitude));
    return distance;
  }).toList());
  final end = DateTime.now().millisecondsSinceEpoch;
  final time = end - start;
  final c = Dispersion(data);
  final m = c.expectedValue();
  final v = c.variance();
  expect(m < 2, isTrue);
  expect(v < 1, isTrue);
  print('$crsFrom -> $crsTo');
  print('mean: ${m}m');
  print('variance: ${v}m²');
  print('time: ${time}ms');
}

void testTransform() async {
  for (final crsFrom in CRS.values) {
    for (final crsTo in CRS.values) {
      if (crsFrom == crsTo) continue;
      final cases = await getCaseList();
      await testTransformInstance(cases, crsFrom, crsTo);
      println(null);
    }
  }
}
