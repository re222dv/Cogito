library stop_clicks_tests;

import 'dart:async';
import 'dart:html' hide Path, Text;
import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';
import 'package:guinness/guinness_html.dart';
import '../../helpers.dart';
import 'package:cogito/cogito.dart';
import '../../../web/lib/cogito.dart';

main() {
    guinnessEnableHtmlMatchers();

    describe('StopClicksDecorator', () {
        Element element;
        TestBed tb;

        beforeEach(() {
            // Prepare Angular for testing
            setUpInjector();

            // Make required classes available for dependency injection
            module((Module _) => _
                ..bind(StopClicksDecorator)
                ..bind(TestBed));

            // Acquire a TestBed instance
            inject((TestBed _tb) {
                tb = _tb;
            });

            element = tb.compile('<div><p stop-clicks></p></div>');
            tb.rootScope.apply();

            // Attach the element to the body so that events can bubble
            document.body.nodes.add(element);
        });

        // Tell Angular we are done
        afterEach(() {
            tearDownInjector();

            document.body.nodes.remove(element);
        });

        it('should stop clicks from propagating', () {
            var clickSpy = guinness.createSpy('clickSpy');
            element.onClick.listen(clickSpy);

            tb.triggerEvent(element.firstChild, 'click');

            expect(clickSpy).not.toHaveBeenCalled();
        });

        it('should let through other events', () {
            var keyPressSpy = guinness.createSpy('keyPressSpy');
            element.onKeyPress.listen(keyPressSpy);

            tb.triggerEvent(element.firstChild, 'keypress');

            expect(keyPressSpy).toHaveBeenCalled();
        });
    });
}
