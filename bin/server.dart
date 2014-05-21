import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:RestLibrary/restlibrary.dart';
import 'package:cogito/server.dart';

const STATIC_PATH = '../web';

main() {
    var db = new Db('mongodb://cogito:cogito@ds043997.mongolab.com:43997/cogito');

    var address = InternetAddress.ANY_IP_V4;
    var portEnv = Platform.environment['PORT'];
    var port = portEnv != null ? int.parse(portEnv) : 9000;

    var authorization = new Authorization(db);
    var page = new Page(db);

    new RestServer()
        ..clientRoutes = ['/page']
        ..static(STATIC_PATH, jailRoot: false)
        ..route(new Route('/api/auth')
            ..post = authorization.register
            ..put = authorization.login)
        ..preprocessor(authorization.checkLogin)
        ..route(new Route('/api/checkAuth')
            ..get = authorization.success)
        ..route(new Route('/api/page/{id}')
            ..get = page.serve
            ..put = page.save)
        ..start(address: address, port: port);

    print('Listening on ${address.address}:$port');
}
