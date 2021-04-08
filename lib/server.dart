import 'dart:io' show Platform;
import 'dart:async' show runZonedGuarded;
import 'dart:convert';

import 'package:path/path.dart' show join, dirname;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';
import 'package:shelf_router/shelf_router.dart';

void main() {
  // Assumes the server lives in bin/ and that `pub build` ran
  // var pathToBuild = join(dirname(Platform.script.toFilePath()),
  //     '..', 'build/web');

  var pathToBuild = join(dirname(Platform.script.toFilePath()), 'www');

  var staticFileHandler = createStaticHandler(pathToBuild,
      defaultDocument: 'app.html');
  var handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(staticFileHandler);

  var router = Router();
  router.get('/user/<user>', _user);


  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 8080 : int.parse(portEnv);

  runZonedGuarded(() {
    io.serve(handler, '0.0.0.0', port);
    print("Serving $pathToBuild on port $port");
  },
  (e, stackTrace) {
    print('Error => $e $stackTrace');
  });
}

Response _user(Request request, String user) {
  var data = <String, dynamic>{'name': 'yao', 'group': 'ZII'};
  return Response.ok(
    json.encode(data),
    headers: {'Content-Type': 'application/json'},
  );
}
