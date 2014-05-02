library helpers_tests;

import 'dart:html';
import 'package:unittest/unittest.dart';
import 'helpers.dart';

main() {
    group('Helper', () {
        group('hasClass', () {
            test('is true when class exists ', () {
                expect(hasClass('test')
                    .matches(new DivElement()..classes.add('test'), null), isTrue);
            });

            test('is false when class doesn\'t exist ', () {
                expect(hasClass('test')
                    .matches(new DivElement(), null), isFalse);
            });
        });
    });
}
