part of cogito_server;

/**
 * Route handlers for everything that have to do with [Page]s
 */
class Page {
    DB db;

    Page(this.db);

    /**
     * A route [Processor] to save a [Page] to the database.
     */
    save(Request request) {
        // Create a Page from the Json and then back to make sure we only get stuff that Page accepts.
        var page = new Page.fromJson(request.json);

        return db.open().then((_) {
            DbCollection pages = db.collection('Pages');

            return pages.update({}, page.toJson()).then((json) {
                db.close();
                return new Response(json);
            });
        });
    }

    /**
     * A route [Processor] to serve a [Page] from the database.
     */
    serve(Request request) {
        return db.open().then((_) {
            DbCollection pages = db.collection('Pages');

            return pages.findOne().then((json) {
                db.close();
                return new Response(json);
            });
        });
    }
}
