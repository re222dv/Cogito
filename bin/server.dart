import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:RestLibrary/restlibrary.dart';
import 'package:cogito/cogito.dart';

const STATIC_PATH = '../web';

Db db;

main() {
    db = new Db('mongodb://cogito:cogito@ds043997.mongolab.com:43997/cogito');

    var address = InternetAddress.ANY_IP_V4;
    var portEnv = Platform.environment['PORT'];
    var port = portEnv == null ? 9000 : int.parse(portEnv);

    new RestServer()
        ..clientRoutes = ['/page']
        ..static(STATIC_PATH, jailRoot: false)
        ..route(new Route('/api/auth')
            ..post = register
            ..put = login)
        ..preprocessor(checkLogin)
        ..route(new Route('/api/checkAuth')
            ..get = success)
        ..route(new Route('/api/page/{id}')
            ..get = servePage
            ..put = savePage)
        ..start(address: address, port: port);

    print('Listening on ${address.address}:$port');
}

register(Request request) {
    var user = new User.fromJson(request.json);

    if (!user.emailIsValid || !user.hashIsValid) {
        return new Response('invalid data', status: Status.ERROR);
    }

    return db.open().then((_) {
        DbCollection users = db.collection('Users');

        return users.findOne({'email': user.email}).then((dbUser) {
            if (dbUser == null) {
                user.strengthenHash();

                return users.insert(user.toJson()).then((_) {
                    db.close();
                    return new Response('user created');
                });
            } else {
                db.close();
                return new Response('email exists', status: Status.ERROR);
            }
        });
    });
}

login(Request request) {
    var user = new User.fromJson(request.json);

    if (!user.emailIsValid || !user.hashIsValid) {
        return new Response('invalid data', status: Status.ERROR);
    }

    return db.open().then((_) {
        DbCollection users = db.collection('Users');

        return users.findOne({'email': user.email}).then((dbUser) {
            db.close();

            if (dbUser != null && user.verifyHash(dbUser)) {
                return new Response(user.getKey(dbUser));
            } else {
                throw new AuthorizationException('authFail', 'login failed');
            }
        });
    });
}

checkLogin(HttpRequest request) {
    var email = request.cookies.firstWhere((c) => c.name == 'email',
                                           orElse: () => throw new AuthorizationException('authFail', 'no email')
                                          ).value;
    var key = request.cookies.firstWhere((c) => c.name == 'key',
                                          orElse: () => throw new AuthorizationException('authFail', 'no key')
                                         ).value;

    var user = new User()..email = email;

    if (!user.emailIsValid) {
        return new Response('invalid email', status: Status.ERROR);
    }

    return db.open().then((_) {
        DbCollection users = db.collection('Users');

        return users.findOne({'email': user.email}).then((dbUser) {
            db.close();

            if (dbUser != null) {
                if (key != user.getKey(dbUser)) {
                    throw new AuthorizationException('authFail', 'bad key');
                }
            } else {
                throw new AuthorizationException('authFail', 'invalid email');
            }
        });
    });
}

success(Request request) {
    return new Response('success');
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
