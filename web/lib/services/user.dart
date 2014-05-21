part of cogito_web;

@Injectable()
class UserService {
    final Cookies _cookies;
    final Http _http;
    final Router _router;

    UserService(this._cookies, this._http, this._router);

    Future<bool> isLoggedIn() {
        if (_cookies['email'] == null || _cookies['key'] == null) {
            return new Future.sync(() => false);
        }

        return _http.get('/api/checkAuth').then((response) {
            if (response.data['status'] == 'success') {
                return true;
            } else {
                return false;
            }
        }).catchError((_) => false);
    }

    Future<bool> login(User user) {
        if (!user.emailIsValid || !user.passwordIsValid) {
            return new Future.sync(() => false);
        }
        user.calculateHash();

        return _http.put('http://127.0.0.1:9000/api/auth', JSON.encode(user.toJson())).then((response) {

            if (response.data['status'] == 'success') {
                _cookies['email'] = user.email;
                _cookies['key'] = response.data['data'];
                return true;
            } else {
                return false;
            }
        }).catchError((_) => false);
    }

    void logout() {
        _cookies.remove('email');
        _cookies.remove('key');

        _router.go('login', {});
    }

    Future<String> register(User user) {
        if (!user.emailIsValid || !user.passwordIsValid) {
            return new Future.sync(() => 'not valid');
        }
        user.calculateHash();

        return _http.post(
            'http://127.0.0.1:9000/api/auth',
            JSON.encode(user.toJson())
        ).then((response) => response.data);
    }
}
