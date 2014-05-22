part of cogito_web;

/**
 * Handles loading and saving of [Page] objects.
 */
@Injectable()
class PageService {
    final HttpService _http;
    final NotificationService _notification;

    bool get haveLocal => window.localStorage.containsKey('page');

    PageService(this._http, this._notification);

    /**
     * Gets a [Page] from the server and on success deletes the local version, if it exists.
     */
    Future<Page> getPage() => _http.get('/api/page/1').then((HttpResponse response) {
        if (!response is HttpResponse || !response.data is Map || !response.data.containsKey('data')) {
            throw 'Loading failed';
        }

        window.localStorage.remove('page');
        return new Page.fromJson(response.data['data']);
    });

    /**
     * Gets a [Page] from localStorage.
     */
    Page getLocalPage() => new Page.fromJson(JSON.decode(window.localStorage['page']));

    /**
     * Saves a [Page] to the server, or if that fails, localStorage.
     *
     * Will notify the user of what happens.
     *
     * Returns true when saving on the server succeeded.
     */
    Future<bool> savePage(Page page) {
        window.localStorage['page'] = JSON.encode(page.toJson());

        return _http.put('/api/page/1', JSON.encode(page.toJson())).then((_) {
            window.localStorage.remove('page');
            _notification.notify('Saved');
        }).catchError((_) {
            _notification.notify('Save Failed!');

            return false;
        }, test: (response) => response is HttpResponse);
    }
}
