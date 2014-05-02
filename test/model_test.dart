library model_tests;

import 'package:unittest/unittest.dart';
import 'package:cogito/cogito.dart';
import 'package:cogito/simplify/simplify.dart';

main() {
    unittestConfiguration.timeout = new Duration(seconds: 3);

    group('Model', () {
        group('from JSON', () {
            test('Line', () {
                var path = new Line.fromJson({
                    'x': 10,
                    'y': 20,
                    'color': 'green',
                    'start': {
                        'x': 0, 'y': 0
                    },
                    'end': {
                        'x': 200, 'y': 200
                    },
                    'width': '10'
                });

                expect(path.x, equals(10));
                expect(path.y, equals(20));
                expect(path.color, equals('green'));
                expect(path.start, equals(new Point()..x=0..y=0));
                expect(path.end, equals(new Point()..x=200..y=200));
                expect(path.width, equals('10'));
            });

            test('Arrow', () {
                var path = new Arrow.fromJson({
                    'x': 10,
                    'y': 20,
                    'color': 'green',
                    'start': {
                        'x': 0, 'y': 0
                    },
                    'end': {
                        'x': 200, 'y': 200
                    },
                    'width': '10'
                });

                expect(path.x, equals(10));
                expect(path.y, equals(20));
                expect(path.color, equals('green'));
                expect(path.start, equals(new Point()..x=0..y=0));
                expect(path.end, equals(new Point()..x=200..y=200));
                expect(path.width, equals('10'));
            });

            test('Path', () {
                var path = new Path.fromJson({
                    'x': 10,
                    'y': 20,
                    'color': 'green',
                    'path': 'M 0 0 L 10 10',
                    'width': '10'
                });

                expect(path.x, equals(10));
                expect(path.y, equals(20));
                expect(path.color, equals('green'));
                expect(path.path, equals('M 0 0 L 10 10'));
                expect(path.width, equals('10'));
            });

            test('Text', () {
                var text = new Text.fromJson({
                    'x': 10,
                    'y': 20,
                    'color': 'green',
                    'text': 'FooBar',
                    'size': '10'
                });

                expect(text.x, equals(10));
                expect(text.y, equals(20));
                expect(text.color, equals('green'));
                expect(text.text, equals('FooBar'));
                expect(text.size, equals('10'));
            });

            test('BasicList', () {
                var list = new BasicList.fromJson({
                    'x': 10,
                    'y': 20,
                    'color': 'green',
                    'rows': ['Foo', 'Bar'],
                    'size': '10'
                });

                expect(list.x, equals(10));
                expect(list.y, equals(20));
                expect(list.color, equals('green'));
                expect(list.rows, equals(['Foo', 'Bar']));
                expect(list.size, equals('10'));
            });
        });

        test('onEdit event', () {
            var text = new Text();

            text.onEdit.listen(expectAsync((editing) {expect(editing, equals(true));}));
            text.editing = true;
        });
    });
}
