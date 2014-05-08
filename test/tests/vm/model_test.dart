library model_tests;

import 'dart:math';
import 'package:unittest/unittest.dart' hide expect;
import 'package:guinness/guinness.dart';
import 'package:cogito/cogito.dart';

main() {
    unittestConfiguration.timeout = new Duration(seconds: 3);

    describe('Model', () {
        describe('Page', () {
            Page page;

            beforeEach(() {
                page = new Page()
                    ..nodes = [new Line(), new Arrow()];
            });

            it('should be able to raise a node', () {
                page.raise(page.nodes[0]);

                expect(page.nodes[0].type).toEqual('arrow');
                expect(page.nodes[1].type).toEqual('line');
            });

            it('should be able to lower a node', () {
                page.lower(page.nodes[1]);

                expect(page.nodes[0].type).toEqual('arrow');
                expect(page.nodes[1].type).toEqual('line');
            });

            it('should do nothing when raising the highest node', () {
                page.raise(page.nodes[1]);

                expect(page.nodes[0].type).toEqual('line');
                expect(page.nodes[1].type).toEqual('arrow');
            });

            it('should do nothing when lowering the lowest node', () {
                page.lower(page.nodes[0]);

                expect(page.nodes[0].type).toEqual('line');
                expect(page.nodes[1].type).toEqual('arrow');
            });
        });

        describe('fromJson', () {
            it('should be able to parse a Page', () {
                var page = new Page.fromJson({
                    'nodes': [
                        {
                            'type': 'line',
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
                        },
                        {
                            'type': 'arrow',
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
                        },
                        {
                            'type': 'path',
                            'x': 200,
                            'y': 300,
                            'width': 20,
                            'color': 'yellow',
                            'path': 'M 0 0 L 100 100'
                        },
                        {
                            'type': 'text',
                            'x': 30,
                            'y': 50,
                            'size': 20,
                            'color': 'red',
                            'text': 'Hello, Mongo!'
                        },
                        {
                            'type': 'basicList',
                            'x': 500,
                            'y': 200,
                            'size': 20,
                            'color': 'blue',
                            'rows': [
                                'AngularDart',
                                'Dart',
                                'MongoDB'
                            ]
                        }
                    ]
                });

                Line line = page.nodes[0];
                Arrow arrow = page.nodes[1];
                Path path = page.nodes[2];
                Text text = page.nodes[3];
                BasicList list = page.nodes[4];

                expect(line.x).toEqual(10);
                expect(line.y).toEqual(20);
                expect(line.color).toEqual('green');
                expect(line.start).toEqual(new Point(0, 0));
                expect(line.end).toEqual(new Point(200, 200));
                expect(line.width).toEqual(10);

                expect(arrow.x).toEqual(10);
                expect(arrow.y).toEqual(20);
                expect(arrow.color).toEqual('green');
                expect(arrow.start).toEqual(new Point(0, 0));
                expect(arrow.end).toEqual(new Point(200, 200));
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
            });

            it('should be able to parse a Line', () {
                var line = new Line.fromJson({
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
                });

                expect(line.x).toEqual(10);
                expect(line.y).toEqual(20);
                expect(line.color).toEqual('green');
                expect(line.start).toEqual(new Point(0, 0));
                expect(line.end).toEqual(new Point(200, 200));
                expect(line.width).toEqual(10);
            });

            it('should be able to parse an Arrow', () {
                var arrow = new Arrow.fromJson({
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
                });

                expect(arrow.x).toEqual(10);
                expect(arrow.y).toEqual(20);
                expect(arrow.color).toEqual('green');
                expect(arrow.start).toEqual(new Point(0, 0));
                expect(arrow.end).toEqual(new Point(200, 200));
                expect(arrow.width).toEqual(10);
            });

            it('should be able to parse a Path', () {
                var path = new Path.fromJson({
                    'x': 10,
                    'y': 20,
                    'color': 'green',
                    'path': 'M 0 0 L 10 10',
                    'width': 10
                });

                expect(path.x).toEqual(10);
                expect(path.y).toEqual(20);
                expect(path.color).toEqual('green');
                expect(path.path).toEqual('M 0 0 L 10 10');
                expect(path.width).toEqual(10);
            });

            it('should be able to parse a Text', () {
                var text = new Text.fromJson({
                    'x': 10,
                    'y': 20,
                    'color': 'green',
                    'text': 'FooBar',
                    'size': 10
                });

                expect(text.x).toEqual(10);
                expect(text.y).toEqual(20);
                expect(text.color).toEqual('green');
                expect(text.text).toEqual('FooBar');
                expect(text.size).toEqual(10);
            });

            it('should be able to parse a BasicList', () {
                var list = new BasicList.fromJson({
                    'x': 10,
                    'y': 20,
                    'color': 'green',
                    'rows': ['Foo', 'Bar'],
                    'size': 10
                });

                expect(list.x).toEqual(10);
                expect(list.y).toEqual(20);
                expect(list.color).toEqual('green');
                expect(list.rows).toEqual(['Foo', 'Bar']);
                expect(list.size).toEqual(10);
            });
        });

        describe('toJson', () {
            it('Should be able to encode a Page', () {
                var page = new Page()
                    ..nodes = [
                        (
                            new Line()
                                ..x = 10
                                ..y = 20
                                ..color = 'green'
                                ..start = (new Point(0, 0))
                                ..end = (new Point(200, 200))
                                ..width = 10
                        ),
                        (
                            new Arrow()
                                ..x = 10
                                ..y = 20
                                ..color = 'green'
                                ..start = (new Point(0, 0))
                                ..end = (new Point(200, 200))
                                ..width = 10
                        ),
                        (
                            new Path()
                                ..x = 10
                                ..y = 20
                                ..color = 'green'
                                ..path = 'M 0 0 L 10 10'
                                ..width = 10
                        ),
                        (
                            new Text()
                                ..x = 10
                                ..y = 20
                                ..color = 'green'
                                ..text = 'FooBar'
                                ..size = 10
                        ),
                        (
                            new BasicList()
                                ..x = 10
                                ..y = 20
                                ..color = 'green'
                                ..rows = ['Foo', 'Bar']
                                ..size = 10
                        )
                    ];

                expect(page.toJson()).toEqual({
                    'nodes': [
                        {
                            'type': 'line',
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
                        },
                        {
                            'type': 'arrow',
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
                        },
                        {
                            'type': 'path',
                            'x': 10,
                            'y': 20,
                            'width': 10,
                            'color': 'green',
                            'path': 'M 0 0 L 10 10'
                        },
                        {
                            'type': 'text',
                            'x': 10,
                            'y': 20,
                            'size': 10,
                            'color': 'green',
                            'text': 'FooBar'
                        },
                        {
                            'type': 'basicList',
                            'x': 10,
                            'y': 20,
                            'size': 10,
                            'color': 'green',
                            'rows': ['Foo', 'Bar']
                        }
                    ]
                });
            });

            it('Should be able to encode a Line', () {
                var line = new Line()
                    ..x = 10
                    ..y = 20
                    ..color = 'green'
                    ..start = (new Point(0, 0))
                    ..end = (new Point(200, 200))
                    ..width = 10;

                expect(line.toJson()).toEqual({
                    'type': 'line',
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
                });
            });

            it('Should be able to encode an Arrow', () {
                var arrow = new Arrow()
                    ..x = 10
                    ..y = 20
                    ..color = 'green'
                    ..start = (new Point(0, 0))
                    ..end = (new Point(200, 200))
                    ..width = 10;

                expect(arrow.toJson()).toEqual({
                    'type': 'arrow',
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
                });
            });

            it('Should be able to encode a Path', () {
                var path = new Path()
                    ..x = 10
                    ..y = 20
                    ..color = 'green'
                    ..path = 'M 0 0 L 10 10'
                    ..width = 10;

                expect(path.toJson()).toEqual({
                    'type': 'path',
                    'x': 10,
                    'y': 20,
                    'color': 'green',
                    'path': 'M 0 0 L 10 10',
                    'width': 10
                });
            });

            it('Should be able to encode a Text', () {
                var text = new Text()
                    ..x = 10
                    ..y = 20
                    ..color = 'green'
                    ..text = 'FooBar'
                    ..size = 10;

                expect(text.toJson()).toEqual({
                    'type': 'text',
                    'x': 10,
                    'y': 20,
                    'color': 'green',
                    'text': 'FooBar',
                    'size': 10
                });
            });

            it('Should be able to encode a BasicList', () {
                var list = new BasicList()
                    ..x = 10
                    ..y = 20
                    ..color = 'green'
                    ..rows = ['Foo', 'Bar']
                    ..size = 10;

                expect(list.toJson()).toEqual({
                    'type': 'basicList',
                    'x': 10,
                    'y': 20,
                    'color': 'green',
                    'rows': ['Foo', 'Bar'],
                    'size': 10
                });
            });
        });

        describe('Node', () {
            it('should fire an onEdit event', () {
                var text = new Text();

                text.onEdit.listen(expectAsync((editing) {
                    expect(editing).toEqual(true);
                }));
                text.editing = true;
            });
        });
    });
}
