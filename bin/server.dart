import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:RestLibrary/restlibrary.dart';
import 'package:cogito/cogito.dart';

Db db;

main() {
    db = new Db('mongodb://cogito:cogito@ds043997.mongolab.com:43997/cogito');

    var portEnv = Platform.environment['PORT'];
    var port = portEnv == null ? 9000 : int.parse(portEnv);

    new RestServer()
        ..static('../build/web')
        ..route(new Route('/page/{id}')
            ..get = servePage
            ..put = savePage)
        ..start(address: InternetAddress.ANY_IP_V4, port: port);
}

servePage(Request request) {
    return db.open().then((_) {
        DbCollection pages = db.collection('Pages');

        return pages.findOne().then((json) {
            db.close();
            return new Response(json);
        });
    });
}

savePage(Request request) {
    // Create a Page from the Json and then back to make sure we only get stuff that Page accepts.
    var page = new Page.fromJson(request.json);

    return db.open().then((_) {
        DbCollection pages = db.collection('Pages');

        return pages.update({}, page.toJson()).then((json) {
            db.close();
            return new Response(json);
        });
    });
}
