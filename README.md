# gcoord_dart

![.github/workflows/test.yml](https://github.com/TonyStark106/gcoord_dart/workflows/.github/workflows/test.yml/badge.svg)
![LICENSE](https://img.shields.io/github/license/tonystark106/gcoord_dart?style=flat-square)
[![pub](https://img.shields.io/pub/v/gcoord_dart?style=flat-square)](https://pub.dartlang.org/packages/gcoord_dart)
[![support](https://img.shields.io/badge/platform-flutter%7Cflutter%20web%7Cdart%20vm-ff69b4.svg?style=flat-square)](https://github.com/tonystark106/gcoord_dart)

**gcoord_dart** 是一个处理地理坐标系的 Dart 库，用来修正百度地图、高德地图及其它互联网地图坐标系不统一的问题。

本项目基于 hujiulong 的 [gcoord](https://github.com/hujiulong/gcoord) 进行重写，实现了 WGS84, GCJ02, BD09 之间的转换。

## Get started

```yaml
dependencies:
  gcoord_dart: 0.2.3
```

## Usage

```dart
import 'package:gcoord_dart/gcoord_dart.dart';

main() {
  final source = Position(114.0578659, 22.5431014);
  final result = transform(
      source,     // 源坐标
      CRS.GCJ02,  // 源坐标系
      CRS.WGS84   // 目标坐标系
  );
  print(result);  // { longitude: 114.05275829055421, latitude: 22.545827976721522 }
}
```
