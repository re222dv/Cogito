library page_service_tests;

import 'dart:async';
import 'dart:convert';
import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';
import 'package:unittest/unittest.dart' hide expect;
import 'package:guinness/guinness.dart';
import 'package:cogito/simplify/simplify.dart';
import 'package:cogito/cogito.dart';
import '../../../web/lib/cogito.dart';

main() {
    unittestConfiguration.timeout = new Duration(seconds: 3);

    group('PageService', () {
        PageService service;

        setUp(() {
            // Prepare Angular for testing
            setUpInjector();

            // Make required classes available for dependency injection
            module((Module _) => _
                ..bind(MockHttpBackend)
                ..bind(PageService));

            // Acquire a PageService instance and mock HttpBackend
            inject((PageService _service, MockHttpBackend http) {
                service = _service;

                http.whenGET('/page/1').respond(200, '''{
                    "data": {
                        "nodes": [
                            {
                                "type": "line",
                                "x": 10,
                                "y": 20,
                                "color": "green",
                                "width": 10,
                                "start": {
                                    "x": 0, "y": 0
                                },
                                "end": {
                                    "x": 200, "y": 200
                                }
                            },
                            {
                                "type": "arrow",
                                "x": 10,
                                "y": 20,
                                "color": "green",
                                "width": 10,
                                "start": {
                                    "x": 0, "y": 0
                                },
                                "end": {
                                    "x": 200, "y": 200
                                }
                            },
                            {
                                "type": "path",
                                "x": 200,
                                "y": 300,
                                "width": 20,
                                "color": "yellow",
                                "path": "M 0 0 L 100 100"
                            },
                            {
                                "type": "text",
                                "x": 30,
                                "y": 50,
                                "color": "red",
                                "size": 20,
                                "text": "Hello, Mongo!"
                            },
                            {
                                "type": "basicList",
                                "x": 500,
                                "y": 200,
                                "color": "blue",
                                "size": 20,
                                "rows": [
                                    "AngularDart",
                                    "Dart",
                                    "MongoDB"
                                ]
                            }
                        ]
                    }
                }''');
            });
        });

        tearDown(tearDownInjector);

        test('should get a page correctly', () {
            inject((MockHttpBackend http) {
                service.getPage().then(expectAsync((page) {
                    Line line = page.nodes[0];
                    Arrow arrow = page.nodes[1];
                    Path path = page.nodes[2];
                    Text text = page.nodes[3];
                    BasicList list = page.nodes[4];

                    expect(line.x).toEqual(10);
                    expect(line.y).toEqual(20);
                    expect(line.color).toEqual('green');
                    expect(line.start).toEqual(new Point()
                        ..x = 0
                        ..y = 0);
                    expect(line.end).toEqual(new Point()
                        ..x = 200
                        ..y = 200);
                    expect(line.width).toEqual(10);

                    expect(arrow.x).toEqual(10);
                    expect(arrow.y).toEqual(20);
                    expect(arrow.color).toEqual('green');
                    expect(arrow.start).toEqual(new Point()
                        ..x = 0
                        ..y = 0);
                    expect(arrow.end).toEqual(new Point()
                        ..x = 200
                        ..y = 200);
                    expect(arrow.width).toEqual(10);

                    expect(path.x).toEqual(200);
                    expect(path.y).toEqual(300);
                    expect(path.color).toEqual('yellow');
                    expect(path.path).toEqual('M 0 0 L 100 100');
                    expect(path.width).toEqual(20);

                    expect(text.x).toEqual(30);
                    expect(text.y).toEqual(50);
                    expect(text.color).toEqual('red');
                    expect(text.text).toEqual('Hello, Mongo!');
                    expect(text.size).toEqual(20);

                    expect(list.x).toEqual(500);
                    expect(list.y).toEqual(200);
                    expect(list.color).toEqual('blue');
                    expect(list.rows).toEqual(['AngularDart', 'Dart', 'MongoDB']);
                    expect(list.size).toEqual(20);
                }));

                Timer.run(() {
                    http.flush();
                });
            });
        });

        test('should save a page correctly', () {
            inject((MockHttpBackend http) {
                http.expectPUT('/page/1', JSON.encode({
                    "nodes": [
                        {
                            "type": "line",
                            "x": 10,
                            "y": 20,
                            "color": "green",
                            "width": 10,
                            "start": {
                                "x": 0, "y": 0
                            },
                            "end": {
                                "x": 200, "y": 200
                            }
                        },
                        {
                            "type": "arrow",
                            "x": 10,
                            "y": 20,
                            "color": "green",
                            "width": 10,
                            "start": {
                                "x": 0, "y": 0
                            },
                            "end": {
                                "x": 200, "y": 200
                            }
                        },
                        {
                            "type": "path",
                            "x": 200,
                            "y": 300,
                            "color": "yellow",
                            "width": 20,
                            "path": "M 0 0 L 100 100"
                        },
                        {
                            "type": "text",
                            "x": 30,
                            "y": 50,
                            "color": "red",
                            "size": 20,
                            "text": "Hello, Mongo!"
                        },
                        {
                            "type": "basicList",
                            "x": 500,
                            "y": 200,
                            "color": "blue",
                            "size": 20,
                            "rows": [
                                "AngularDart",
                                "Dart",
                                "MongoDB"
                            ]
                        }
                    ]
                }));

                service.savePage(new Page()
                    ..nodes = [
                        new Line.fromJson({
                            'x': 10,
                            'y': 20,
                            'color': 'green',
                            'start': {
                                'x': 0, 'y': 0
                            },
                            'end': {
                                'x': 200, 'y': 200
                            },
                            'width': 10
                        }),
                        new Arrow.fromJson({
                            'x': 10,
                            'y': 20,
                            'color': 'green',
                            'start': {
                                'x': 0, 'y': 0
                            },
                            'end': {
                                'x': 200, 'y': 200
                            },
                            'width': 10
                        }),
                        new Path.fromJson({
                            'x': 200,
                            'y': 300,
                            'color': 'yellow',
                            'path': 'M 0 0 L 100 100',
                            'width': 20
                        }),
                        new Text.fromJson({
                            'x': 30,
                            'y': 50,
                            'color': 'red',
                            'text': 'Hello, Mongo!',
                            'size': 20
                        }),
                        new BasicList.fromJson({
                            'x': 500,
                            'y': 200,
                            'color': 'blue',
                            'rows': [
                                'AngularDart',
                                'Dart',
                                'MongoDB'
                            ],
                            'size': 20
                        })
                    ]
                );
            });
        });
    });
}
