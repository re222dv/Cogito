part of cogito_web;

/**
 * A wrapper for Angulars [Http] to handle login redirection.
 */
@Injectable()
class HttpService {
    final Http _http;
    final Router _router;

    HttpService(this._http, this._router);

    /**
     * Shortcut method for GET requests.  See [Http.call] for a complete description
     * of parameters.
     */
    Future<HttpResponse> get(String url, {
    String data,
    Map<String, dynamic> params,
    Map<String, String> headers,
    xsrfHeaderName,
    xsrfCookieName,
    interceptors,
    cache,
    timeout
    }) => _http.get(url, data: data, params: params,
                    headers: headers, xsrfHeaderName: xsrfHeaderName,
                    xsrfCookieName: xsrfCookieName, interceptors: interceptors,
                    cache: cache, timeout: timeout)
               .catchError((_) => _router.go('login', {}),
                           test: (HttpResponse response) => response.status == 401);

    /**
     * Shortcut method for PUT requests.  See [Http.call] for a complete description
     * of parameters.
     */
    Future<HttpResponse> put(String url, String data, {
    Map<String, dynamic> params,
    Map<String, String> headers,
    xsrfHeaderName,
    xsrfCookieName,
    interceptors,
    cache,
    timeout
    }) => _http.put(url, data, params: params,
                    headers: headers, xsrfHeaderName: xsrfHeaderName,
                    xsrfCookieName: xsrfCookieName, interceptors: interceptors,
                    cache: cache, timeout: timeout)
                .catchError((_) => _router.go('login', {}),
                            test: (HttpResponse response) => response.status == 401);
}
