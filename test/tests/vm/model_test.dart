library model_its;

import 'package:unittest/unittest.dart' hide expect;
import 'package:guinness/guinness.dart';
import 'package:cogito/cogito.dart';
import 'package:cogito/simplify/simplify.dart';

main() {
    unittestConfiguration.timeout = new Duration(seconds: 3);

    describe('Model', () {
        describe('fromJson', () {
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
                    'width': '10'
                });

                expect(line.x).toEqual(10);
                expect(line.y).toEqual(20);
                expect(line.color).toEqual('green');
                expect(line.start).toEqual(new Point()..x=0..y=0);
                expect(line.end).toEqual(new Point()..x=200..y=200);
                expect(line.width).toEqual('10');
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
                    'width': '10'
                });

                expect(arrow.x).toEqual(10);
                expect(arrow.y).toEqual(20);
                expect(arrow.color).toEqual('green');
                expect(arrow.start).toEqual(new Point()..x=0..y=0);
                expect(arrow.end).toEqual(new Point()..x=200..y=200);
                expect(arrow.width).toEqual('10');
            });

            it('should be able to parse a Path', () {
                var path = new Path.fromJson({
                    'x': 10,
                    'y': 20,
                    'color': 'green',
                    'path': 'M 0 0 L 10 10',
                    'width': '10'
                });

                expect(path.x).toEqual(10);
                expect(path.y).toEqual(20);
                expect(path.color).toEqual('green');
                expect(path.path).toEqual('M 0 0 L 10 10');
                expect(path.width).toEqual('10');
            });

            it('should be able to parse a Text', () {
                var text = new Text.fromJson({
                    'x': 10,
                    'y': 20,
                    'color': 'green',
                    'text': 'FooBar',
                    'size': '10'
                });

                expect(text.x).toEqual(10);
                expect(text.y).toEqual(20);
                expect(text.color).toEqual('green');
                expect(text.text).toEqual('FooBar');
                expect(text.size).toEqual('10');
            });

            it('should be able to parse a BasicList', () {
                var list = new BasicList.fromJson({
                    'x': 10,
                    'y': 20,
                    'color': 'green',
                    'rows': ['Foo', 'Bar'],
                    'size': '10'
                });

                expect(list.x).toEqual(10);
                expect(list.y).toEqual(20);
                expect(list.color).toEqual('green');
                expect(list.rows).toEqual(['Foo', 'Bar']);
                expect(list.size).toEqual('10');
            });
        });

        it('should fire an onEdit event', () {
            var text = new Text();

            text.onEdit.listen(expectAsync((editing) {
                expect(editing).toEqual(true);
            }));
            text.editing = true;
        });
    });
}
