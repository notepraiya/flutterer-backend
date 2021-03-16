import 'dart:io' show Platform;
import 'dart:async' show runZonedGuarded;
import 'package:path/path.dart' show join, dirname;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

void main() {
  // Assumes the server lives in bin/ and that `pub build` ran
  // var pathToBuild = join(dirname(Platform.script.toFilePath()),
  //     '..', 'build/web');

  var pathToBuild = join(dirname(Platform.script.toFilePath()),'/');

  var handler = createStaticHandler(pathToBuild,
      defaultDocument: 'app.html');

  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 80 : int.parse(portEnv);

  runZonedGuarded(() {
    io.serve(handler, '0.0.0.0', port);
    print("Serving $pathToBuild on port $port");
  },
  (e, stackTrace) {
    print('Error => $e $stackTrace');
  });
}
