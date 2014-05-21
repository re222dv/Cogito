library http_service_tests;

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';
import 'package:unittest/unittest.dart' hide expect;
import 'package:guinness/guinness.dart';
import '../../helpers.dart';
import 'package:cogito/cogito.dart';
import '../../../web/lib/cogito.dart';

SpyFunction goSpy;

class MockRouter implements Router {

    MockRouter() {
        goSpy = guinness.createSpy('goSpy');
    }

    go(String routePath, Map parameters, {Route startingFrom, bool replace: false}) =>
        goSpy(routePath, parameters, startingFrom, replace);

    // Ignore warnings about unimplemented methods
    noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

main() {
    unittestConfiguration.timeout = new Duration(seconds: 3);

    describe('HttpService', () {
        HttpService service;
        MockHttpBackend http;

        beforeEach(() {
            // Prepare Angular for testing
            setUpInjector();

            // Make required classes available for dependency injection
            module((Module _) => _
                ..bind(HttpService)
                ..bind(MockHttpBackend)
                ..bind(NotificationService)
                ..bind(PageService)
                ..bind(Router, toImplementation: MockRouter));

            // Acquire a HttpService and MockHttpBackend instance
            inject((HttpService _service, MockHttpBackend _http) {
                service = _service;
                http = _http;
            });
        });

        afterEach(() {
            tearDownInjector();

            http.verifyNoOutstandingExpectation();
            http.verifyNoOutstandingRequest();
        });

        it('should get an address correctly', () {
            http.expectGET('/api/test').respond(200, 'data');

            service.get('/api/test').then(expectAsync((response) {
                expect(response is HttpResponse).toEqual(true);
                expect(response.status).toEqual(200);
                expect(response.data).toEqual('data');
            }));

            return asyncExpectation(() {
                http.flush();
            });
        });

        it('should redirect on get auth fail', () {
            http.expectGET('/api/test').respond(401, 'data');

            service.get('/api/test').then(expectAsync((_) {}));

            return asyncExpectation(() {
                http.flush();

                return asyncExpectation(() {
                    expect(goSpy).toHaveBeenCalledOnce();
                });
            });
        });

        it('should put to an address correctly', () {
            http.expectPUT('/api/test', JSON.encode({'data': 'data'})).respond(200, 'data');

            service.put('/api/test', JSON.encode({'data': 'data'})).then(expectAsync((response) {
                expect(response is HttpResponse).toEqual(true);
                expect(response.status).toEqual(200);
                expect(response.data).toEqual('data');
            }));

            return asyncExpectation(() {
                http.flush();
            });
        });

        it('should redirect on put auth fail', () {
            http.expectPUT('/api/test').respond(401, 'data');

            service.put('/api/test', JSON.encode({'data': 'data'})).then(expectAsync((_) {}));

            return asyncExpectation(() {
                http.flush();

                return asyncExpectation(() {
                    expect(goSpy).toHaveBeenCalledOnce();
                });
            });
        });
    });
}
