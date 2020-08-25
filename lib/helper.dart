part of 'transform.dart';

bool _isInChinaBbox(double lng, double lat) {
  return (lat >= 0.8293 && lat <= 55.8271) && (lng >= 72.004 && lng <= 137.8347);
}
