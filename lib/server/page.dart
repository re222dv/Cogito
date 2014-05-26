part of cogito_server;

/**
 * Route handlers for everything that have to do with [Page]s
 */
class PageRoutes {
    final Db db;

    PageRoutes(this.db);

    /**
     * A route [Processor] to save a [Page] to the database.
     */
    save(Request request) {
        // Create a Page from the Json and then back to make sure we only get stuff that Page accepts.
        var page = new Page.fromJson(request.json);

        return db.open().then((_) {
            DbCollection pages = db.collection('Pages');

            page.user = request.httpRequest.session['UID'];

            return pages.update({'user': page.user}, page.toJson(), upsert: true)
                .then((_) => new Response(page.toJson()));
        }).whenComplete(db.close);
    }

    /**
     * A route [Processor] to serve a [Page] from the database.
     */
    serve(Request request) {
        return db.open().then((_) {
            DbCollection pages = db.collection('Pages');

            var uid = request.httpRequest.session['UID'];

            return pages.findOne({'user': uid}).then((json) {
                if (json == null) {
                    json = new Page()
                        ..user = uid
                        ..toJson();
                }

                return new Response(json);
            });
        }).whenComplete(db.close);
    }
}
