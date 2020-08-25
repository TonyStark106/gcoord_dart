import 'dart:math';
part 'helper.dart';
part 'constants.dart';
part 'template.dart';
part 'crs/BD09.dart';
part 'crs/GCJ02.dart';

Position transform(Position input, CRS crsFrom, CRS crsTo) {
  switch (crsFrom) {
    case CRS.WGS84:
      switch (crsTo) {
        case CRS.WGS84:
          return input;
        case CRS.GCJ02:
          return _WGS84ToGCJ02(input);
        case CRS.BD09:
          return _GCJ02ToBD09(_WGS84ToGCJ02(input));
      }
      break;
    case CRS.GCJ02:
      switch (crsTo) {
        case CRS.WGS84:
          return _GCJ02ToWGS84(input);
        case CRS.GCJ02:
          return input;
        case CRS.BD09:
          return _GCJ02ToBD09(input);
      }
      break;
    case CRS.BD09:
      switch (crsTo) {
        case CRS.WGS84:
          return _GCJ02ToWGS84(_BD09ToGCJ02(input));
        case CRS.GCJ02:
          return _BD09ToGCJ02(input);
        case CRS.BD09:
          return input;
      }
      break;
  }
  return null;
}
