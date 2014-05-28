library authorization_routes_tests;

import 'dart:async';
import 'dart:io';
import 'package:mock/mock.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:RestLibrary/restlibrary.dart';
import 'package:unittest/unittest.dart' hide expect;
import 'package:guinness/guinness.dart';
import 'package:cogito/server.dart';

const EMAIL = 'test@example.com';
const SHA256_HASH = '772c4d2d6cde7d787d1153a4383c1456d3e037518c223e8611147dc0eeb8534e';
const BCRYPT_HASH = '\$2a\$10\$QGguLbA2M/Tu8MReu.oec.dan5FNnU4wvQX3EjBeL46.vjGupDbNO';
const API_KEY = 'cc4a649456ace3a8e6d784813c591e204106689505b4730ed0760ca445e8a96d';


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
    static var insertCallback = (_) => null;

    SpyFunction findOneSpy = guinness.createSpy('findOneSpy').andCallFake((_) => new Future.sync(() => fakedFind));
    SpyFunction insertSpy = guinness.createSpy('insertSpy').andCallFake((o) => new Future.sync(() => insertCallback(o)));

    MockCollection() {
        fakedFind = null;
        insertCallback = (_) => null;
    }

    findOne([query]) => findOneSpy(query);
    insert(object, {writeConcern: null}) => insertSpy(object);

    // Ignore warnings about unimplemented methods
    noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}


class MockRequest extends Mock implements Request {
    var json;

    // Ignore warnings about unimplemented methods
    noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}


class MockHttpRequest extends Mock implements HttpRequest {
    List<Cookie> cookies = [];
    Map<String, String> session = {};

    // Ignore warnings about unimplemented methods
    noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}


main() {
    unittestConfiguration.timeout = new Duration(seconds: 3);

    describe('Authorization routes', () {
        Authorization authorization;
        MockDb db;
        Request request;
        Map dbUser;
        Map user;

        beforeEach(() {
            db = new MockDb();
            authorization = new Authorization(db);

            dbUser = {
                'email': EMAIL,
                'hash': BCRYPT_HASH,
            };
            user = {
                'email': EMAIL,
                'hash': SHA256_HASH,
            };
            request = new MockRequest()
                ..json = user;
        });

        describe('checkLogin', () {
            HttpRequest request;

            beforeEach(() {
                MockCollection.fakedFind = dbUser;

                request = new MockHttpRequest();
                request.cookies
                    ..add(new Cookie('email', EMAIL))
                    ..add(new Cookie('key', API_KEY));
            });

            it('should requre an email cookie', () {
                request.cookies.removeAt(0);

                try {
                    expect(authorization.checkLogin(request)).toThrow();
                } catch (e) {
                    expect(e is AuthorizationException).toEqual(true);
                    expect(e.error).toEqual('authFail');
                    expect(e.description).toEqual('no email');
                }
            });

            it('should requre a key cookie', () {
                request.cookies.removeAt(1);

                try {
                    expect(authorization.checkLogin(request)).toThrow();
                } catch (e) {
                    expect(e is AuthorizationException).toEqual(true);
                    expect(e.error).toEqual('authFail');
                    expect(e.description).toEqual('no key');
                }
            });



            it('should validate the user before logging in', () {
                var emails = [
                    '',
                    'name'
                ];

                emails.forEach((email) {
                    request.cookies[0].value = email;

                    try {
                        expect(authorization.checkLogin(request)).toThrow();
                    } catch (e) {
                        expect(e is AuthorizationException).toEqual(true);
                        expect(e.error).toEqual('authFail');
                        expect(e.description).toEqual('invalid email');
                    }
                });
            });

            it('should use the Users collection', () {
                var response = authorization.checkLogin(request);

                return response.then(expectAsync((response) {
                    expect(db.collectionSpy).toHaveBeenCalledOnceWith('Users');

                    expect(db.closeSpy).toHaveBeenCalledOnce();
                }));
            });

            it('should return null on success', () {
                var response = authorization.checkLogin(request);

                return response.then(expectAsync((response) {
                    expect(response).toBeNull();

                    expect(db.closeSpy).toHaveBeenCalledOnce();
                }));
            });

            it('should throw AuthorizationException on unkown email', () {
                MockCollection.fakedFind = null;
                var response = authorization.checkLogin(request);

                return response.catchError((e) {
                    expect(e is AuthorizationException).toEqual(true);
                    expect(e.error).toEqual('authFail');
                    expect(e.description).toEqual('auth failed');

                    expect(MockDb.mockCollection.findOneSpy).toHaveBeenCalledOnce();
                    expect(MockDb.mockCollection.findOneSpy.mostRecentCall.positionalArguments.first)
                    .toEqual({'email': EMAIL});

                    expect(db.closeSpy).toHaveBeenCalledOnce();
                });
            });

            it('should throw AuthorizationException on bad key', () {
                request.cookies[1].value = '772c4d2d6cde7d787d1153a4383c1456d3e037518c223e8611147dc0eeb8534f';
                var response = authorization.checkLogin(request);

                return response.catchError((e) {
                    expect(e is AuthorizationException).toEqual(true);
                    expect(e.error).toEqual('authFail');
                    expect(e.description).toEqual('auth failed');

                    expect(db.closeSpy).toHaveBeenCalledOnce();
                });
            });
        });

        describe('login', () {

            beforeEach(() {
                MockCollection.fakedFind = dbUser;
            });

            it('should validate the user before logging in', () {
                var users = [
                    {
                        'email': '',
                        'hash': '',
                    },
                    {
                        'email': EMAIL,
                        'hash': '',
                    },
                    {
                        'email': '',
                        'hash': SHA256_HASH,
                    },
                    {
                        'email': EMAIL,
                        'hash': 'dsdhfksdjfjsdbdjfhgdfjkhgbdfhgbdfjkgb',
                    },
                    {
                        'email': 'asjkdbsadjk',
                        'hash': SHA256_HASH,
                    },
                ];

                users.forEach(expectAsync((user) {
                    var request = new MockRequest()..json = user;
                    var response = authorization.login(request);

                    expect(response.data).toEqual('invalid data');
                    expect(response.status).toEqual(Status.ERROR);
                }, count: users.length));
            });

            it('should use the Users collection', () {
                var response = authorization.login(request);

                return response.then(expectAsync((response) {
                    expect(db.collectionSpy).toHaveBeenCalledOnceWith('Users');

                    expect(db.closeSpy).toHaveBeenCalledOnce();
                }));
            });

            it('should respond with an API key on success', () {
                var response = authorization.login(request);

                return response.then(expectAsync((response) {
                    expect(response.data).toEqual(API_KEY);
                    expect(response.status).toEqual(Status.SUCCESS);

                    expect(db.closeSpy).toHaveBeenCalledOnce();
                }));
            });

            it('should throw AuthorizationException on unkown email', () {
                MockCollection.fakedFind = null;
                var response = authorization.login(request);

                return response.catchError((e) {
                    expect(e is AuthorizationException).toEqual(true);
                    expect(e.error).toEqual('authFail');
                    expect(e.description).toEqual('login failed');

                    expect(MockDb.mockCollection.findOneSpy).toHaveBeenCalledOnce();
                    expect(MockDb.mockCollection.findOneSpy.mostRecentCall.positionalArguments.first)
                        .toEqual({'email': EMAIL});


                    expect(db.closeSpy).toHaveBeenCalledOnce();
                });
            });

            it('should throw AuthorizationException on bad hash', () {
                user['hash'] = '772c4d2d6cde7d787d1153a4383c1456d3e037518c223e8611147dc0eeb8534f';
                var response = authorization.login(request);

                return response.catchError((e) {
                    expect(e is AuthorizationException).toEqual(true);
                    expect(e.error).toEqual('authFail');
                    expect(e.description).toEqual('login failed');

                    expect(db.closeSpy).toHaveBeenCalledOnce();
                });
            });

        });

        describe('register', () {
            it('should validate the user before registrating', () {
                var users = [
                    {
                        'email': '',
                        'hash': '',
                    },
                    {
                        'email': EMAIL,
                        'hash': '',
                    },
                    {
                        'email': '',
                        'hash': SHA256_HASH,
                    },
                    {
                        'email': EMAIL,
                        'hash': 'dsdhfksdjfjsdbdjfhgdfjkhgbdfhgbdfjkgb',
                    },
                    {
                        'email': 'asjkdbsadjk',
                        'hash': SHA256_HASH,
                    },
                ];

                users.forEach(expectAsync((user) {
                    var request = new MockRequest()..json = user;
                    var response = authorization.register(request);

                    expect(response.data).toEqual('invalid data');
                    expect(response.status).toEqual(Status.ERROR);
                }, count: users.length));
            });

            it('should use the Users collection', () {
                var response = authorization.register(request);

                return response.then(expectAsync((response) {
                    expect(db.collectionSpy).toHaveBeenCalledOnceWith('Users');

                    expect(db.closeSpy).toHaveBeenCalledOnce();
                }));
            });

            it('should respond with "email exists" if an user with that email does', () {
                MockCollection.fakedFind = user;

                var response = authorization.register(request);

                return response.then(expectAsync((response) {
                    expect(response.data).toEqual('email exists');
                    expect(response.status).toEqual(Status.ERROR);

                    expect(MockDb.mockCollection.findOneSpy).toHaveBeenCalledOnce();
                    expect(MockDb.mockCollection.findOneSpy.mostRecentCall.positionalArguments.first)
                        .toEqual({'email': EMAIL});

                    expect(db.closeSpy).toHaveBeenCalledOnce();
                }));
            });

            it('should strengthen hash before inserting user', () {
                MockCollection.insertCallback = expectAsync((object) {
                    expect(object['email']).toEqual(EMAIL);
                    expect(object['hash']).not.toEqual(SHA256_HASH);
                });

                return authorization.register(request);
            });

            it('should return success after inserting user', () {
                var response = authorization.register(request);
                return response.then(expectAsync((response) {
                    expect(response.data).toEqual('user created');
                    expect(response.status).toEqual(Status.SUCCESS);

                    expect(db.closeSpy).toHaveBeenCalledOnce();
                }));
            });
        });

        describe('success', () {
            it('should just return success', () {
                var response = authorization.success(request);

                expect(response.data).toEqual('success');
                expect(response.status).toEqual(Status.SUCCESS);
            });
        });
    });
}
