part of 'transform.dart';

class Position {
  final double longitude;
  final double latitude;

  Position(this.longitude, this.latitude);

  @override
  String toString() {
    return '{ longitude: ${longitude}, latitude: ${latitude} }';
  }
}
