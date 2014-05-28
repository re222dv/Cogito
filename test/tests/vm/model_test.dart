library model_tests;

import 'dart:math';
import 'package:unittest/unittest.dart' hide expect;
import 'package:guinness/guinness.dart';
import 'package:cogito/cogito.dart';

main() {
    unittestConfiguration.timeout = new Duration(seconds: 3);

    describe('Model', () {

        describe('fromJson', () {
            it('should be able to parse a Page', () {
                var page = new Page.fromJson({
                    'nodes': [
                        {
                            'type': 'line',
                            'x': 10,
                            'y': 20,
                            'scale': 2,
                            'color': 'green',
                            'start': {
                                'x': 0, 'y': 0
                            },
                            'end': {
                                'x': 200, 'y': 200
                            },
                            'width': 10
                        },
                        {
                            'type': 'arrow',
                            'x': 10,
                            'y': 20,
                            'scale': 2,
                            'color': 'green',
                            'start': {
                                'x': 0, 'y': 0
                            },
                            'end': {
                                'x': 200, 'y': 200
                            },
                            'width': 10
                        },
                        {
                            'type': 'path',
                            'x': 200,
                            'y': 300,
                            'scale': 2,
                            'width': 20,
                            'color': 'yellow',
                            'path': 'M 0 0 L 100 100'
                        },
                        {
                            'type': 'text',
                            'x': 30,
                            'y': 50,
                            'scale': 2,
                            'size': 20,
                            'color': 'red',
                            'text': 'Hello, Mongo!'
                        },
                        {
                            'type': 'list',
                            'x': 500,
                            'y': 200,
                            'scale': 2,
                            'size': 20,
                            'color': 'blue',
                            'rows': [
                                'AngularDart',
                                'Dart',
                                'MongoDB'
                            ]
                        },
                        {
                            'type': 'rect',
                            'x': 10,
                            'y': 20,
                            'scale': 2,
                            'width': 30,
                            'height': 40,
                            'fillColor': 'green',
                            'strokeColor': 'blue',
                            'strokeWidth': 50
                        },
                        {
                            'type': 'circle',
                            'x': 10,
                            'y': 20,
                            'scale': 2,
                            'radius': 30,
                            'fillColor': 'green',
                            'strokeColor': 'blue',
                            'strokeWidth': 40
                        }
                    ],
                    'user': '456'
                });

                LineNode line = page.nodes[0];
                ArrowNode arrow = page.nodes[1];
                PathNode path = page.nodes[2];
                TextNode text = page.nodes[3];
                ListNode list = page.nodes[4];
                RectNode rect = page.nodes[5];
                CircleNode circle = page.nodes[6];

                expect(page.user).toEqual('456');

                expect(line.x).toEqual(10);
                expect(line.y).toEqual(20);
                expect(line.scale).toEqual(2);
                expect(line.color).toEqual('green');
                expect(line.start).toEqual(new Point(0, 0));
                expect(line.end).toEqual(new Point(200, 200));
                expect(line.width).toEqual(10);

                expect(arrow.x).toEqual(10);
                expect(arrow.y).toEqual(20);
                expect(arrow.scale).toEqual(2);
                expect(arrow.color).toEqual('green');
                expect(arrow.start).toEqual(new Point(0, 0));
                expect(arrow.end).toEqual(new Point(200, 200));
                expect(arrow.width).toEqual(10);

                expect(path.x).toEqual(200);
                expect(path.y).toEqual(300);
                expect(path.scale).toEqual(2);
                expect(path.color).toEqual('yellow');
                expect(path.path).toEqual('M 0 0 L 100 100');
                expect(path.width).toEqual(20);

                expect(text.x).toEqual(30);
                expect(text.y).toEqual(50);
                expect(text.scale).toEqual(2);
                expect(text.color).toEqual('red');
                expect(text.text).toEqual('Hello, Mongo!');
                expect(text.size).toEqual(20);

                expect(list.x).toEqual(500);
                expect(list.y).toEqual(200);
                expect(list.scale).toEqual(2);
                expect(list.color).toEqual('blue');
                expect(list.rows).toEqual(['AngularDart', 'Dart', 'MongoDB']);
                expect(list.size).toEqual(20);

                expect(rect.x).toEqual(10);
                expect(rect.y).toEqual(20);
                expect(rect.scale).toEqual(2);
                expect(rect.width).toEqual(30);
                expect(rect.height).toEqual(40);
                expect(rect.fillColor).toEqual('green');
                expect(rect.strokeColor).toEqual('blue');
                expect(rect.strokeWidth).toEqual(50);

                expect(circle.x).toEqual(10);
                expect(circle.y).toEqual(20);
                expect(circle.scale).toEqual(2);
                expect(circle.radius).toEqual(30);
                expect(circle.fillColor).toEqual('green');
                expect(circle.strokeColor).toEqual('blue');
                expect(circle.strokeWidth).toEqual(40);
            });

            it('should be able to parse a Line', () {
                var line = new LineNode.fromJson({
                    'x': 10,
                    'y': 20,
                    'scale': 2,
                    'color': 'green',
                    'start': {
                        'x': 0, 'y': 0
                    },
                    'end': {
                        'x': 200, 'y': 200
                    },
                    'width': 30
                });

                expect(line.x).toEqual(10);
                expect(line.y).toEqual(20);
                expect(line.scale).toEqual(2);
                expect(line.color).toEqual('green');
                expect(line.start).toEqual(new Point(0, 0));
                expect(line.end).toEqual(new Point(200, 200));
                expect(line.width).toEqual(30);
            });

            it('should be able to parse an Arrow', () {
                var arrow = new ArrowNode.fromJson({
                    'x': 10,
                    'y': 20,
                    'scale': 2,
                    'color': 'green',
                    'start': {
                        'x': 0, 'y': 0
                    },
                    'end': {
                        'x': 200, 'y': 200
                    },
                    'width': 30
                });

                expect(arrow.x).toEqual(10);
                expect(arrow.y).toEqual(20);
                expect(arrow.scale).toEqual(2);
                expect(arrow.color).toEqual('green');
                expect(arrow.start).toEqual(new Point(0, 0));
                expect(arrow.end).toEqual(new Point(200, 200));
                expect(arrow.width).toEqual(30);
            });

            it('should be able to parse a Path', () {
                var path = new PathNode.fromJson({
                    'x': 10,
                    'y': 20,
                    'scale': 2,
                    'color': 'green',
                    'path': 'M 0 0 L 10 10',
                    'width': 30
                });

                expect(path.x).toEqual(10);
                expect(path.y).toEqual(20);
                expect(path.scale).toEqual(2);
                expect(path.color).toEqual('green');
                expect(path.path).toEqual('M 0 0 L 10 10');
                expect(path.width).toEqual(30);
            });

            it('should be able to parse a Text', () {
                var text = new TextNode.fromJson({
                    'x': 10,
                    'y': 20,
                    'scale': 2,
                    'color': 'green',
                    'text': 'FooBar',
                    'size': 30
                });

                expect(text.x).toEqual(10);
                expect(text.y).toEqual(20);
                expect(text.scale).toEqual(2);
                expect(text.color).toEqual('green');
                expect(text.text).toEqual('FooBar');
                expect(text.size).toEqual(30);
            });

            it('should be able to parse a List', () {
                var list = new ListNode.fromJson({
                    'x': 10,
                    'y': 20,
                    'scale': 2,
                    'color': 'green',
                    'rows': ['Foo', 'Bar'],
                    'size': 30
                });

                expect(list.x).toEqual(10);
                expect(list.y).toEqual(20);
                expect(list.scale).toEqual(2);
                expect(list.color).toEqual('green');
                expect(list.rows).toEqual(['Foo', 'Bar']);
                expect(list.size).toEqual(30);
            });

            it('should be able to parse a Rect', () {
                var rect = new RectNode.fromJson({
                    'x': 10,
                    'y': 20,
                    'scale': 2,
                    'width': 30,
                    'height': 40,
                    'fillColor': 'green',
                    'strokeColor': 'blue',
                    'strokeWidth': 50
                });

                expect(rect.x).toEqual(10);
                expect(rect.y).toEqual(20);
                expect(rect.scale).toEqual(2);
                expect(rect.width).toEqual(30);
                expect(rect.height).toEqual(40);
                expect(rect.fillColor).toEqual('green');
                expect(rect.strokeColor).toEqual('blue');
                expect(rect.strokeWidth).toEqual(50);
            });

            it('should be able to parse a Circle', () {
                var circle = new CircleNode.fromJson({
                    'x': 10,
                    'y': 20,
                    'scale': 2,
                    'radius': 30,
                    'fillColor': 'green',
                    'strokeColor': 'blue',
                    'strokeWidth': 40
                });

                expect(circle.x).toEqual(10);
                expect(circle.y).toEqual(20);
                expect(circle.scale).toEqual(2);
                expect(circle.radius).toEqual(30);
                expect(circle.fillColor).toEqual('green');
                expect(circle.strokeColor).toEqual('blue');
                expect(circle.strokeWidth).toEqual(40);
            });
        });

        describe('toJson', () {
            it('Should be able to encode a Page', () {
                var page = new Page()
                    ..nodes = [
                        (
                            new LineNode()
                                ..x = 10
                                ..y = 20
                                ..scale = 2
                                ..color = 'green'
                                ..start = (new Point(0, 0))
                                ..end = (new Point(200, 200))
                                ..width = 10
                        ),
                        (
                            new ArrowNode()
                                ..x = 10
                                ..y = 20
                                ..scale = 2
                                ..color = 'green'
                                ..start = (new Point(0, 0))
                                ..end = (new Point(200, 200))
                                ..width = 10
                        ),
                        (
                            new PathNode()
                                ..x = 10
                                ..y = 20
                                ..scale = 2
                                ..color = 'green'
                                ..path = 'M 0 0 L 10 10'
                                ..width = 10
                        ),
                        (
                            new TextNode()
                                ..x = 10
                                ..y = 20
                                ..scale = 2
                                ..color = 'green'
                                ..text = 'FooBar'
                                ..size = 10
                        ),
                        (
                            new ListNode()
                                ..x = 10
                                ..y = 20
                                ..scale = 2
                                ..color = 'green'
                                ..rows = ['Foo', 'Bar']
                                ..size = 10
                        ),
                        (
                            new RectNode()
                                ..x = 10
                                ..y = 20
                                ..scale = 2
                                ..width = 30
                                ..height = 40
                                ..fillColor = 'green'
                                ..strokeColor = 'blue'
                                ..strokeWidth = 50
                        ),
                        (
                            new CircleNode()
                                ..x = 10
                                ..y = 20
                                ..scale = 2
                                ..radius = 30
                                ..fillColor = 'green'
                                ..strokeColor = 'blue'
                                ..strokeWidth = 40
                        )
                    ]
                    ..user = '123';

                expect(page.toJson()).toEqual({
                    'nodes': [
                        {
                            'type': 'line',
                            'x': 10,
                            'y': 20,
                            'scale': 2,
                            'color': 'green',
                            'start': {
                                'x': 0, 'y': 0
                            },
                            'end': {
                                'x': 200, 'y': 200
                            },
                            'width': 10
                        },
                        {
                            'type': 'arrow',
                            'x': 10,
                            'y': 20,
                            'scale': 2,
                            'color': 'green',
                            'start': {
                                'x': 0, 'y': 0
                            },
                            'end': {
                                'x': 200, 'y': 200
                            },
                            'width': 10
                        },
                        {
                            'type': 'path',
                            'x': 10,
                            'y': 20,
                            'scale': 2,
                            'width': 10,
                            'color': 'green',
                            'path': 'M 0 0 L 10 10'
                        },
                        {
                            'type': 'text',
                            'x': 10,
                            'y': 20,
                            'scale': 2,
                            'size': 10,
                            'color': 'green',
                            'text': 'FooBar'
                        },
                        {
                            'type': 'list',
                            'x': 10,
                            'y': 20,
                            'scale': 2,
                            'size': 10,
                            'color': 'green',
                            'rows': ['Foo', 'Bar']
                        },
                        {
                            'type': 'rect',
                            'x': 10,
                            'y': 20,
                            'scale': 2,
                            'width': 30,
                            'height': 40,
                            'fillColor': 'green',
                            'strokeColor': 'blue',
                            'strokeWidth': 50
                        },
                        {
                            'type': 'circle',
                            'x': 10,
                            'y': 20,
                            'scale': 2,
                            'radius': 30,
                            'fillColor': 'green',
                            'strokeColor': 'blue',
                            'strokeWidth': 40
                        }
                    ],
                    'user': '123'
                });
            });

            it('Should be able to encode a Line', () {
                var line = new LineNode()
                    ..x = 10
                    ..y = 20
                    ..scale = 2
                    ..color = 'green'
                    ..start = (new Point(0, 0))
                    ..end = (new Point(200, 200))
                    ..width = 10;

                expect(line.toJson()).toEqual({
                    'type': 'line',
                    'x': 10,
                    'y': 20,
                    'scale': 2,
                    'color': 'green',
                    'start': {
                        'x': 0, 'y': 0
                    },
                    'end': {
                        'x': 200, 'y': 200
                    },
                    'width': 10
                });
            });

            it('Should be able to encode an Arrow', () {
                var arrow = new ArrowNode()
                    ..x = 10
                    ..y = 20
                    ..scale = 2
                    ..color = 'green'
                    ..start = (new Point(0, 0))
                    ..end = (new Point(200, 200))
                    ..width = 10;

                expect(arrow.toJson()).toEqual({
                    'type': 'arrow',
                    'x': 10,
                    'y': 20,
                    'scale': 2,
                    'color': 'green',
                    'start': {
                        'x': 0, 'y': 0
                    },
                    'end': {
                        'x': 200, 'y': 200
                    },
                    'width': 10
                });
            });

            it('Should be able to encode a Path', () {
                var path = new PathNode()
                    ..x = 10
                    ..y = 20
                    ..scale = 2
                    ..color = 'green'
                    ..path = 'M 0 0 L 10 10'
                    ..width = 10;

                expect(path.toJson()).toEqual({
                    'type': 'path',
                    'x': 10,
                    'y': 20,
                    'scale': 2,
                    'color': 'green',
                    'path': 'M 0 0 L 10 10',
                    'width': 10
                });
            });

            it('Should be able to encode a Text', () {
                var text = new TextNode()
                    ..x = 10
                    ..y = 20
                    ..scale = 2
                    ..color = 'green'
                    ..text = 'FooBar'
                    ..size = 10;

                expect(text.toJson()).toEqual({
                    'type': 'text',
                    'x': 10,
                    'y': 20,
                    'scale': 2,
                    'color': 'green',
                    'text': 'FooBar',
                    'size': 10
                });
            });

            it('Should be able to encode a List', () {
                var list = new ListNode()
                    ..x = 10
                    ..y = 20
                    ..scale = 2
                    ..color = 'green'
                    ..rows = ['Foo', 'Bar']
                    ..size = 10;

                expect(list.toJson()).toEqual({
                    'type': 'list',
                    'x': 10,
                    'y': 20,
                    'scale': 2,
                    'color': 'green',
                    'rows': ['Foo', 'Bar'],
                    'size': 10
                });
            });

            it('Should be able to encode a Rect', () {
                var rect = new RectNode()
                    ..x = 10
                    ..y = 20
                    ..scale = 2
                    ..width = 30
                    ..height = 40
                    ..fillColor = 'green'
                    ..strokeColor = 'blue'
                    ..strokeWidth = 50;

                expect(rect.toJson()).toEqual({
                    'type': 'rect',
                    'x': 10,
                    'y': 20,
                    'scale': 2,
                    'width': 30,
                    'height': 40,
                    'fillColor': 'green',
                    'strokeColor': 'blue',
                    'strokeWidth': 50
                });
            });

            it('Should be able to encode a Circle', () {
                var circle = new CircleNode()
                    ..x = 10
                    ..y = 20
                    ..scale = 2
                    ..radius = 30
                    ..fillColor = 'green'
                    ..strokeColor = 'blue'
                    ..strokeWidth = 40;

                expect(circle.toJson()).toEqual({
                    'type': 'circle',
                    'x': 10,
                    'y': 20,
                    'scale': 2,
                    'radius': 30,
                    'fillColor': 'green',
                    'strokeColor': 'blue',
                    'strokeWidth': 40
                });
            });
        });

        describe('Node', () {
            it('should fire an onEdit event', () {
                var text = new TextNode();

                text.onEdit.listen(expectAsync((editing) {
                    expect(editing).toEqual(true);
                }));
                text.editing = true;
            });
        });
    });
}
