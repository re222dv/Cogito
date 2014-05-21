part of cogito_web;

@Injectable()
class PageService {
    final Http _http;
    final NotificationService _notification;

    bool get haveLocal => window.localStorage.containsKey('page');

    PageService(this._http, this._notification);

    Future<Page> getPage() => _http.get('/api/page/1').then((HttpResponse response) {
        if (response.status == 200) {
            window.localStorage.remove('page');
            return new Page.fromJson(response.data['data']);
        } else {
            return new Page();
        }
    });

    Page getLocalPage() => new Page.fromJson(JSON.decode(window.localStorage['page']));

    Future<bool> savePage(Page page) {
        window.localStorage['page'] = JSON.encode(page.toJson());

        return _http.put('/api/page/1', JSON.encode(page.toJson())).then((HttpResponse response) {
            if (response.status == 200) {
                window.localStorage.remove('page');
                _notification.notify('Saved');
            } else {
                _notification.notify('Save Failed!');
            }

            return response.status == 200;
        }).catchError((_) {
            _notification.notify('Save Failed!');

            return false;
        });
    }
}
