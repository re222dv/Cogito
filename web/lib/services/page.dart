part of cogito_web;

@Injectable()
class PageService {
    final Http _http;
    final NotificationService _notification;

    PageService(this._http, this._notification);

    Future<Page> getPage() => _http.get('/api/page/1').then((HttpResponse response) {
        if (response.status == 200) {
            return new Page.fromJson(response.data['data']);
        } else {
            return new Page();
        }
    }).catchError((_) => new Page());

    Future<bool> savePage(Page page) => _http.put('/api/page/1', JSON.encode(page.toJson()))
            .then((HttpResponse response) {
        if (response.status == 200) {
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
