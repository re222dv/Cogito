part of cogito_web;

@Injectable()
class PageService {
    final Http _http;

    PageService(Http this._http);

    Future<Page> getPage() => _http.get('/page/1').then((HttpResponse response) {
        if (response.status == 200) {
            return new Page.fromJson(response.data['data']);
        } else {
            return new Page();
        }
    }).catchError((_) => new Page());

    Future<bool> savePage(Page page) => _http.put('/page/1', JSON.encode(page.toJson()))
            .then((HttpResponse response) {
        return response.status == 200;
    }).catchError((_) => false);
}
