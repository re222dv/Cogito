import 'package:mongo_dart/mongo_dart.dart';
import 'package:RestLibrary/restlibrary.dart';

Db db;

main() {
    db = new Db('mongodb://cogito:cogito@ds043997.mongolab.com:43997/cogito');

    new RestServer()
        ..static('../build/web')
        ..route(new Route('/page/{id}')
            ..get = servePage)
        ..start(port: 9000);
 }

servePage(Request request) {
    return db.open().then((c) {
        DbCollection pages = db.collection('Pages');

        return pages.findOne().then((json) {
            db.close();
            return new Response(json);
        });
    });
}
