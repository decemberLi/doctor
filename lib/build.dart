// Ensure that the build script itself is not opted in to null safety,
// instead of taking the language version from the current package.
//
// @dart=2.9
//
// ignore_for_file: directives_ordering
import 'dart:io' as _i7;
import 'dart:isolate' as _i5;

import 'package:build_runner/build_runner.dart' as _i6;
import 'package:build_runner_core/build_runner_core.dart' as _i1;
import 'package:yyy_route_annotation/src/route_serializable.dart' as _i4;

final _builders = <_i1.BuilderApplication>[
  _i1.apply(r'yyy_route_annotation:routePageSerializable',
      [_i4.routePageSerializable], _i1.toRoot(),
      hideOutput: false),
  _i1.apply(r'yyy_route_annotation:routeSerializable', [_i4.routeSerializable],
      _i1.toRoot(),
      hideOutput: false),
];
void main(List<String> args, [_i5.SendPort sendPort]) async {
  var result = await _i6.run(args, _builders);
  sendPort?.send(result);
  _i7.exitCode = result;
}
