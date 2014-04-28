part of cogito_web;

@Injectable()
class PageService {
    final Http _http;

    PageService(Http this._http);

    Future<Page> getPage() => _http.get('/page/1').then((HttpResponse response) {
        return new Page.fromJson(response.data['data']);
    });
}
