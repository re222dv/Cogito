part of cogito_web;

/**
 * Handles all interactions with the authorization system.
 */
@Injectable()
class UserService {
    final Cookies _cookies;
    final Http _http;
    final Router _router;

    UserService(this._cookies, this._http, this._router);

    /**
     * Checks if the user is logged in by checking if cookies exists, and if they do, if they are correct.
     */
    Future<bool> isLoggedIn() {
        if (_cookies['email'] == null || _cookies['key'] == null) {
            return new Future.sync(() => false);
        }

        return _http.get('/api/checkAuth')
            .then((response) {
                return response.data['status'] == 'success';
            }).catchError((_) => false);
    }

    /**
     * Tries to log in the user if the provided values are valid.
     *
     * Returns true on success.
     */
    Future<bool> login(User user) {
        if (!user.emailIsValid || !user.passwordIsValid) {
            return new Future.sync(() => false);
        }
        user.calculateHash();

        return _http.put('/api/auth', JSON.encode(user.toJson()))
            .then((response) {
                _cookies['email'] = user.email;
                _cookies['key'] = response.data['data'];
                return true;
            }).catchError((_) => false,
                          test: (response) => response is HttpResponse && response.status == 401);
    }

    /**
     * Logs out the user and redirects to login screen.
     */
    void logout() {
        _cookies.remove('email');
        _cookies.remove('key');

        _router.go('login', {});
    }

    /**
     * Tries to register the user if the provided values are valid.
     *
     * Returns the response from the server.
     */
    Future<String> register(User user) {
        if (!user.emailIsValid || !user.passwordIsValid) {
            return new Future.sync(() => 'not valid');
        }
        user.calculateHash();

        return _http.post('/api/auth', JSON.encode(user.toJson()))
            .then((response) => response.data);
    }
}
