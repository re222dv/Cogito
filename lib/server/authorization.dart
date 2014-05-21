part of cogito_server;

/**
 * Route handlers for everything that have to do with authorization
 */
class Authorization {
    final DB db;

    Authorization(this.db);

    /**
     * Gets the cookie from the [request] named [name].
     *
     * Throws [AuthorizationException] if it's missing.
     */
    _getCookie(request, name) =>
        request.cookies.firstWhere((c) => c.name == name,
                                   orElse: () => throw new AuthorizationException('authFail', 'no $name'));

    /**
     * A route [Preprocessor] for assuring that access to following routes are authorized.
     *
     * Throws [AuthorizationException] on failure
     */
    checkLogin(HttpRequest request) {
        var email = _getCookie(request, 'email').value;
        var key = _getCookie(request, 'key').value;

        var user = new User()..email = email;

        if (!user.emailIsValid) {
            throw new AuthorizationException('authFail', 'invalid email');
        }

        return db.open().then((_) {
            DbCollection users = db.collection('Users');

            return users.findOne({'email': user.email}).then((dbUser) {
                if (dbUser == null || key != user.getKey(dbUser)) {
                    throw new AuthorizationException('authFail', 'auth failed');
                }
            });
        }).whenComplete(db.close);
    }

    /**
     * A route [Processor] to login a user.
     *
     * Requires a valid email and a SHA256 hash that matches a registered user.
     *
     * Throws [AuthorizationException] on failure
     */
    login(Request request) {
        var user = new User.fromJson(request.json);

        if (!user.emailIsValid || !user.hashIsValid) {
            return new Response('invalid data', status: Status.ERROR);
        }

        return db.open().then((_) {
            DbCollection users = db.collection('Users');

            return users.findOne({'email': user.email}).then((dbUser) {

                if (dbUser != null && user.verifyHash(dbUser)) {
                    return new Response(user.getKey(dbUser));
                } else {
                    throw new AuthorizationException('authFail', 'login failed');
                }
            });
        }).whenComplete(db.close);
    }

    /**
     * A route [Processor] for registering a user.
     *
     * Requires a valid and unique email and a SHA256 hash.
     */
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
                        return new Response('user created');
                    });
                } else {
                    return new Response('email exists', status: Status.ERROR);
                }
            });
        }).whenComplete(db.close);
    }

    /**
     * A route [Processor] for checking if a user is logged in.
     *
     * Put if after the [checkLogin] [Preprocessor].
     */
    success(Request request) => new Response('success');
}
