import 'dart:html';
import 'package:matcher/matcher.dart';

/** A matcher that matches a css class. */
Matcher hasClass(String className) => new _HasClass(className);

class _HasClass extends Matcher {
    final String _className;

    _HasClass(this._className);

    bool matches(Element item, Map matchState) => item.classes.contains(_className);

    Description describe(Description description) => description.add('element to have class "$_className"');

    Description describeMismatch(Element item, Description mismatchDescription, Map matchState, bool verbose) =>
        mismatchDescription.add('have class(es): [${item.classes.join(', ')}]');
}
