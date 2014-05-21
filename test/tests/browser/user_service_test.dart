library user_service_tests;

import 'dart:async';
import 'dart:convert';
import 'dart:html';
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

    group('UserService', () {
        UserService service;
        MockHttpBackend http;
        Cookies cookies;

        setUp(() {
            // Prepare Angular for testing
            setUpInjector();

            // Make required classes available for dependency injection
            module((Module _) => _
                ..bind(MockHttpBackend)
                ..bind(NotificationService)
                ..bind(UserService)
                ..bind(Router, toImplementation: MockRouter));

            // Acquire a UserService, MockHttpBackend and Cookies instance
            inject((UserService _service, MockHttpBackend _http, Cookies _cookies) {
                service = _service;
                http = _http;
                cookies = _cookies;
            });
        });

        tearDown(() {
            tearDownInjector();

            http.verifyNoOutstandingExpectation();
            http.verifyNoOutstandingRequest();
        });

        group('isLoggedIn', () {

            setUp(() {
                cookies['email'] = 'test@example.com';
                cookies['key'] = '3e624bee6f82b83206b7bfa02a4176d9f6c86141456d63d4f6a723428c19c2d8';
            });

            test('should return true when logged in', () {
                http.whenGET('/api/checkAuth').respond(200, JSON.encode({'status': 'success'}));

                service.isLoggedIn().then(expectAsync((result) {
                    expect(result).toEqual(true);
                }));

                return asyncExpectation(http.flush);
            });

            test('should return false when no cookies exists', () {
                cookies.remove('email');
                cookies.remove('key');

                service.isLoggedIn().then(expectAsync((result) {
                    expect(result).toEqual(false);
                }));
            });

            test('should return false when cookie data is wrong', () {
                http.whenGET('/api/checkAuth').respond(401, null);

                service.isLoggedIn().then(expectAsync((result) {
                    expect(result).toEqual(false);
                }));

                return asyncExpectation(http.flush);
            });
        });

        group('login', () {

            test('should set cookies and return true login succeeds', () {
                http.whenPUT('/api/auth').respond(200, JSON.encode({
                    'data': '3e624bee6f82b83206b7bfa02a4176d9f6c86141456d63d4f6a723428c19c2d8',
                    'status': 'success'
                }));

                var user = new User()
                    ..email = 'test@example.com'
                    ..password = 'password';

                service.login(user).then(expectAsync((result) {
                    expect(result).toEqual(true);
                    expect(cookies['email']).toEqual('test@example.com');
                    expect(cookies['key']).toEqual('3e624bee6f82b83206b7bfa02a4176d9f6c86141456d63d4f6a723428c19c2d8');
                }));

                return asyncExpectation(http.flush);
            });

            test('should return false when login fails', () {
                http.whenPUT('/api/auth').respond(401, null);

                var user = new User()
                    ..email = 'test@example.com'
                    ..password = 'password';

                service.login(user).then(expectAsync((result) {
                    expect(result).toEqual(false);
                }));

                return asyncExpectation(http.flush);
            });

            test('should validate email and password before trying', () {
                var user = new User()
                    ..password = 'password';

                service.login(user).then(expectAsync((result) {
                    expect(result).toEqual(false);
                }));

                user = new User()
                    ..email = 'test@example.com';

                service.login(user).then(expectAsync((result) {
                    expect(result).toEqual(false);
                }));
            });

            test('should hash and clear password before trying', () {
                http.expectPUT('/api/auth', JSON.encode({
                    'email': 'test@example.com',
                    'hash': 'c172813bb88ce7fc26d8b25e13f4f1dfd07f5d188347bfd3972bfc37355fa7f1'
                })).respond(JSON.encode({'data': 'success'}));

                var user = new User()
                    ..email = 'test@example.com'
                    ..password = 'password';

                service.login(user).then(expectAsync((result) {
                    expect(user.password).toEqual('');
                }));

                return asyncExpectation(http.flush);
            });
        });

        group('logout', () {

            test('should clear cookies and redirect', () {
                cookies['email'] = 'test@example.com';
                cookies['key'] = '3e624bee6f82b83206b7bfa02a4176d9f6c86141456d63d4f6a723428c19c2d8';

                service.logout();

                expect(cookies['email']).toBeNull();
                expect(cookies['key']).toBeNull();

                expect(goSpy).toHaveBeenCalledOnce();
            });
        });

        group('register', () {

            test('should return returned data on success', () {
                http.whenPOST('/api/auth').respond(200, JSON.encode({'data': 'success'}));

                var user = new User()
                    ..email = 'test@example.com'
                    ..password = 'password';

                service.register(user).then(expectAsync((result) {
                    expect(result).toEqual({'data': 'success'});
                }));

                return asyncExpectation(http.flush);
            });

            test('should return returned response on success', () {
                http.whenPOST('/api/auth').respond(400, JSON.encode({'data': 'failure'}));

                var user = new User()
                    ..email = 'test@example.com'
                    ..password = 'password';

                service.register(user).catchError(expectAsync((result) {
                    expect(result is HttpResponse).toEqual(true);
                    expect(result.data).toEqual(JSON.encode({'data': 'failure'}));
                }));

                return asyncExpectation(http.flush);
            });

            test('should validate email and password before trying', () {
                var user = new User()
                    ..password = 'password';

                service.register(user).then(expectAsync((result) {
                    expect(result).toEqual('not valid');
                }));

                user = new User()
                    ..email = 'test@example.com';

                service.register(user).then(expectAsync((result) {
                    expect(result).toEqual('not valid');
                }));
            });

            test('should hash and clear password before trying', () {
                http.expectPOST('/api/auth', JSON.encode({
                    'email': 'test@example.com',
                    'hash': 'c172813bb88ce7fc26d8b25e13f4f1dfd07f5d188347bfd3972bfc37355fa7f1'
                })).respond('');

                var user = new User()
                    ..email = 'test@example.com'
                    ..password = 'password';

                service.register(user).then(expectAsync((_) {
                    expect(user.password).toEqual('');
                }));

                return asyncExpectation(http.flush);
            });
        });
    });
}
