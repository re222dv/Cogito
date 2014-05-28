library page_routes_tests;

import 'dart:async';
import 'dart:io';
import 'package:mock/mock.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:RestLibrary/restlibrary.dart';
import 'package:unittest/unittest.dart' hide expect;
import 'package:guinness/guinness.dart';
import 'package:cogito/server.dart';


class MockDb extends Mock implements Db {
    static MockCollection mockCollection;

    SpyFunction openSpy = guinness.createSpy('openSpy').andCallFake(() => new Future.sync(() {}));
    SpyFunction closeSpy = guinness.createSpy('closeSpy');
    SpyFunction collectionSpy = guinness.createSpy('collectionSpy').andCallFake((_) => mockCollection);

    MockDb() {
        mockCollection = new MockCollection();
    }

    open({writeConcern: null}) => openSpy();
    close() => closeSpy();
    collection(name) => collectionSpy(name);

    // Ignore warnings about unimplemented methods
    noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}


class MockCollection extends Mock implements DbCollection {
    static var fakedFind = null;
    static var updateCallback = (_) => null;

    SpyFunction findOneSpy = guinness.createSpy('findOneSpy').andCallFake((_) => new Future.sync(() => fakedFind));
    SpyFunction updateSpy = guinness.createSpy('updateSpy').andCallFake((o) => new Future.sync(() => updateCallback(o)));

    MockCollection() {
        fakedFind = null;
        updateCallback = (_) => null;
    }

    findOne([query]) => findOneSpy(query);
    update(query, object, {writeConcern: null, upsert: null, multiUpdate: null}) => updateSpy(object);

    // Ignore warnings about unimplemented methods
    noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}


class MockRequest extends Mock implements Request {
    var httpRequest = new MockHttpRequest();
    var json;

    // Ignore warnings about unimplemented methods
    noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}


class MockHttpRequest extends Mock implements HttpRequest {
    Map<String, String> session = {};

    // Ignore warnings about unimplemented methods
    noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}


main() {
    unittestConfiguration.timeout = new Duration(seconds: 3);

    describe('Page routes', () {
        PageRoutes page;
        MockDb db;
        Request request;

        beforeEach(() {
            db = new MockDb();
            page = new PageRoutes(db);

            request = new MockRequest();
        });

        describe('save', () {

            beforeEach(() {
                request.httpRequest.session['UID'] = '123';
                request.json = new Page().toJson()
                    ..['invalid'] = 'invalid';
            });

            it('should use the Pages collection', () {
                var response = page.save(request);

                return response.then(expectAsync((response) {
                    expect(db.collectionSpy).toHaveBeenCalledOnceWith('Pages');

                    expect(db.closeSpy).toHaveBeenCalledOnce();
                }));
            });

            it('should save a validated page', () {
                MockCollection.updateCallback = expectAsync((object) {
                    expect(object).toEqual({'nodes': [], 'user': '123'});
                });

                return page.save(request);
            });

            it('should return the saved page on success', () {
                var response = page.save(request);

                return response.then(expectAsync((response) {
                    expect(response.data).toEqual({'nodes': [], 'user': '123'});
                    expect(response.status).toEqual(Status.SUCCESS);
                }));
            });

        });

        describe('serve', () {

            beforeEach(() {
                MockCollection.fakedFind = {'page': 'page'};
            });

            it('should use the Pages collection', () {
                var response = page.serve(request);

                return response.then(expectAsync((response) {
                    expect(db.collectionSpy).toHaveBeenCalledOnceWith('Pages');

                    expect(db.closeSpy).toHaveBeenCalledOnce();
                }));
            });

            it('should serve the page on success', () {
                var response = page.serve(request);

                return response.then(expectAsync((response) {
                    expect(response.data).toEqual({'page': 'page'});
                    expect(response.status).toEqual(Status.SUCCESS);

                    expect(db.closeSpy).toHaveBeenCalledOnce();
                }));
            });
        });
    });
}
