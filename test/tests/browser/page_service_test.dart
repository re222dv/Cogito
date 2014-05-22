library page_service_tests;

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';
import 'package:unittest/unittest.dart' hide expect;
import 'package:guinness/guinness.dart';
import 'package:cogito/cogito.dart';
import '../../helpers.dart';
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

var pageJson = {
    'data': {
        'nodes': [
            {
                'type': 'line',
                'x': 10,
                'y': 20,
                'scale': 3,
                'color': 'green',
                'width': 10,
                'start': {
                    'x': 0, 'y': 0
                },
                'end': {
                    'x': 200, 'y': 200
                }
            },
            {
                'type': 'arrow',
                'x': 10,
                'y': 20,
                'scale': 3,
                'color': 'green',
                'width': 10,
                'start': {
                    'x': 0, 'y': 0
                },
                'end': {
                    'x': 200, 'y': 200
                }
            },
            {
                'type': 'path',
                'x': 200,
                'y': 300,
                'scale': 3,
                'color': 'yellow',
                'width': 20,
                'path': 'M 0 0 L 100 100'
            },
            {
                'type': 'text',
                'x': 30,
                'y': 50,
                'scale': 3,
                'color': 'red',
                'size': 20,
                'text': 'Hello, Mongo!'
            },
            {
                'type': 'list',
                'x': 500,
                'y': 200,
                'scale': 3,
                'color': 'blue',
                'size': 20,
                'rows': [
                    'AngularDart',
                    'Dart',
                    'MongoDB'
                ]
            }
        ]
    }
};

var pageObject = new Page()
    ..nodes = [
        new LineNode.fromJson({
            'x': 10,
            'y': 20,
            'scale': 3,
            'color': 'green',
            'start': {
                'x': 0, 'y': 0
            },
            'end': {
                'x': 200, 'y': 200
            },
            'width': 10
        }),
        new ArrowNode.fromJson({
            'x': 10,
            'y': 20,
            'scale': 3,
            'color': 'green',
            'start': {
                'x': 0, 'y': 0
            },
            'end': {
                'x': 200, 'y': 200
            },
            'width': 10
        }),
        new PathNode.fromJson({
            'x': 200,
            'y': 300,
            'scale': 3,
            'width': 20,
            'color': 'yellow',
            'path': 'M 0 0 L 100 100',
        }),
        new TextNode.fromJson({
            'x': 30,
            'y': 50,
            'scale': 3,
            'color': 'red',
            'size': 20,
            'text': 'Hello, Mongo!',
        }),
        new ListNode.fromJson({
            'x': 500,
            'y': 200,
            'scale': 3,
            'color': 'blue',
            'size': 20,
            'rows': [
                'AngularDart',
                'Dart',
                'MongoDB'
            ],
        })
    ];

main() {
    unittestConfiguration.timeout = new Duration(seconds: 3);

    group('PageService', () {
        PageService service;
        MockHttpBackend http;

        setUp(() {
            // Prepare Angular for testing
            setUpInjector();

            // Make required classes available for dependency injection
            module((Module _) => _
                ..bind(HttpService)
                ..bind(MockHttpBackend)
                ..bind(NotificationService)
                ..bind(PageService)
                ..bind(Router, toImplementation: MockRouter));

            // Acquire a PageService and MockHttpBackend instance
            inject((PageService _service, MockHttpBackend _http) {
                service = _service;
                http = _http;
            });
        });

        tearDown(() {
            tearDownInjector();

            http.verifyNoOutstandingExpectation();
            http.verifyNoOutstandingRequest();
        });

        test('should get a page correctly', () {
            http.whenGET('/api/page/1').respond(200, JSON.encode(pageJson));

            service.getPage().then(expectAsync((page) {
                LineNode line = page.nodes[0];
                ArrowNode arrow = page.nodes[1];
                PathNode path = page.nodes[2];
                TextNode text = page.nodes[3];
                ListNode list = page.nodes[4];

                expect(line.x).toEqual(10);
                expect(line.y).toEqual(20);
                expect(list.scale).toEqual(3);
                expect(line.color).toEqual('green');
                expect(line.start).toEqual(new Point(0, 0));
                expect(line.end).toEqual(new Point(200, 200));
                expect(line.width).toEqual(10);

                expect(arrow.x).toEqual(10);
                expect(arrow.y).toEqual(20);
                expect(list.scale).toEqual(3);
                expect(arrow.color).toEqual('green');
                expect(arrow.start).toEqual(new Point(0, 0));
                expect(arrow.end).toEqual(new Point(200, 200));
                expect(arrow.width).toEqual(10);

                expect(path.x).toEqual(200);
                expect(path.y).toEqual(300);
                expect(list.scale).toEqual(3);
                expect(path.color).toEqual('yellow');
                expect(path.path).toEqual('M 0 0 L 100 100');
                expect(path.width).toEqual(20);

                expect(text.x).toEqual(30);
                expect(text.y).toEqual(50);
                expect(list.scale).toEqual(3);
                expect(text.color).toEqual('red');
                expect(text.text).toEqual('Hello, Mongo!');
                expect(text.size).toEqual(20);

                expect(list.x).toEqual(500);
                expect(list.y).toEqual(200);
                expect(list.scale).toEqual(3);
                expect(list.color).toEqual('blue');
                expect(list.rows).toEqual(['AngularDart', 'Dart', 'MongoDB']);
                expect(list.size).toEqual(20);
            }));

            return asyncExpectation(() {
                http.flush();
            });
        });

        test('should save a page correctly', () {
            http.expectPUT('/api/page/1', JSON.encode(pageJson['data'])).respond(pageJson);

            service.savePage(pageObject);

            return asyncExpectation(() {
                http.flush();

                return asyncExpectation(() {
                    expect(goSpy).not.toHaveBeenCalled();
                });
            });
        });

        test('should return saved page on success', () {
            http.expectPUT('/api/page/1', JSON.encode(pageJson['data'])).respond(pageJson);

            service.savePage(pageObject).then(expectAsync((page) {
                LineNode line = page.nodes[0];
                ArrowNode arrow = page.nodes[1];
                PathNode path = page.nodes[2];
                TextNode text = page.nodes[3];
                ListNode list = page.nodes[4];

                expect(line.x).toEqual(10);
                expect(line.y).toEqual(20);
                expect(list.scale).toEqual(3);
                expect(line.color).toEqual('green');
                expect(line.start).toEqual(new Point(0, 0));
                expect(line.end).toEqual(new Point(200, 200));
                expect(line.width).toEqual(10);

                expect(arrow.x).toEqual(10);
                expect(arrow.y).toEqual(20);
                expect(list.scale).toEqual(3);
                expect(arrow.color).toEqual('green');
                expect(arrow.start).toEqual(new Point(0, 0));
                expect(arrow.end).toEqual(new Point(200, 200));
                expect(arrow.width).toEqual(10);

                expect(path.x).toEqual(200);
                expect(path.y).toEqual(300);
                expect(list.scale).toEqual(3);
                expect(path.color).toEqual('yellow');
                expect(path.path).toEqual('M 0 0 L 100 100');
                expect(path.width).toEqual(20);

                expect(text.x).toEqual(30);
                expect(text.y).toEqual(50);
                expect(list.scale).toEqual(3);
                expect(text.color).toEqual('red');
                expect(text.text).toEqual('Hello, Mongo!');
                expect(text.size).toEqual(20);

                expect(list.x).toEqual(500);
                expect(list.y).toEqual(200);
                expect(list.scale).toEqual(3);
                expect(list.color).toEqual('blue');
                expect(list.rows).toEqual(['AngularDart', 'Dart', 'MongoDB']);
                expect(list.size).toEqual(20);
            }));;

            return asyncExpectation(() {
                http.flush();
            });
        });

        test('it should handle login error', () {
            http.whenGET('/api/page/1').respond(401, null);

            service.getPage().catchError(expectAsync((_) {}));

            return asyncExpectation(() {
                http.flush();

                return asyncExpectation(() {
                    expect(goSpy).toHaveBeenCalledOnce();
                });
            });
        });
    });
}
