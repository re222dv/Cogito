library dropdown_tests;

import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';
import 'package:unittest/unittest.dart' hide expect;
import 'package:guinness/guinness_html.dart';
import '../../helpers.dart';
import '../../../web/lib/cogito.dart';


main() {
    guinnessEnableHtmlMatchers();

    group('DropDownComponent', () {
        Element element;
        ShadowRoot shadowRoot;
        TestBed tb;

        setUp(() {
            // Prepare Angular for testing
            setUpInjector();

            // Make required classes available for dependency injection
            module((Module _) => _
                ..bind(DropDownComponent)
                ..bind(TestBed));

            // Add required templates to the cache
            addToTemplateCache('lib/components/dropdown/dropdown.css');
            addToTemplateCache('lib/components/dropdown/dropdown.html');

            // Prepare test values
            var textSizes = [];
            for (var i = 12; i <= 72; i+= 2) {
                textSizes.add(i);
            }

            // Acquire a TestBed instance
            inject((TestBed _tb) => tb = _tb);

            tb.rootScope.context['val'] = 22;
            tb.rootScope.context['vals'] = textSizes;
            element = tb.compile('<dropdown type="int" values="vals" ng-model="val"></dropdown>');
            shadowRoot = element.shadowRoot;

            // Add the element to the dom so that events can bubble
            document.body.append(element);

            tb.rootScope.apply();

            // Make sure Angular get time to attach the shadow root
            return new Future.delayed(Duration.ZERO, () => tb.getScope(shadowRoot.querySelector('div')).apply());
        });

        // Tell Angular we are done
        tearDown(() {
            tearDownInjector();

            element.remove();
        });

        test('should prioritize values correctly', () {
            var prioritizedValues = shadowRoot.querySelectorAll('li').map((element) => element.getAttribute('value'));

            expect(prioritizedValues).toEqual(['12', '14', '16', '18', '24', '26', '28', '30', '32', '36', '46', '56', '66']);
        });

        test('should be hidden from start', () {
            expect(shadowRoot.querySelector('ul')).toHaveClass('ng-hide');
        });

        test('should be shown after a click', () {
            tb.triggerEvent(shadowRoot.querySelector('div'), 'mousedown');
            tb.triggerEvent(shadowRoot.querySelector('div'), 'mouseup');

            expect(shadowRoot.querySelector('ul')).not.toHaveClass('ng-hide');
        });

        test('should be shown after a mouse drag', () {
            tb.triggerEvent(shadowRoot.querySelector('div'), 'mousedown');
            tb.triggerEvent(shadowRoot.querySelector('div'), 'mouseout');

            expect(shadowRoot.querySelector('ul')).not.toHaveClass('ng-hide');
        });

        test('should be shown after a tap', () {
            tb.triggerEvent(shadowRoot.querySelector('div'), 'touchstart');
            tb.triggerEvent(shadowRoot.querySelector('div'), 'touchend');

            expect(shadowRoot.querySelector('ul')).not.toHaveClass('ng-hide');
        });

        test('should be shown after a touch drag', () {
            tb.triggerEvent(shadowRoot.querySelector('div'), 'touchstart');
            tb.triggerEvent(shadowRoot.querySelector('div'), 'touchleave');

            expect(shadowRoot.querySelector('ul')).not.toHaveClass('ng-hide');
        });

        test('should hide after a click', () {
            tb.triggerEvent(shadowRoot.querySelector('div'), 'mousedown');
            tb.triggerEvent(shadowRoot.querySelector('div'), 'mouseup');

            tb.triggerEvent(shadowRoot.querySelector('div'), 'mousedown');
            tb.triggerEvent(shadowRoot.querySelector('div'), 'mouseup');

            expect(shadowRoot.querySelector('ul')).toHaveClass('ng-hide');
        });

        test('should hide after a tap', () {
            tb.triggerEvent(shadowRoot.querySelector('div'), 'touchstart');
            tb.triggerEvent(shadowRoot.querySelector('div'), 'touchend');

            tb.triggerEvent(shadowRoot.querySelector('div'), 'touchstart');
            tb.triggerEvent(shadowRoot.querySelector('div'), 'touchend');

            expect(shadowRoot.querySelector('ul')).toHaveClass('ng-hide');
        });

        test('should be able to select a value with a click', () {
            tb.triggerEvent(shadowRoot.querySelector('div'), 'mousedown');
            tb.triggerEvent(shadowRoot.querySelector('div'), 'mouseup');

            expect(shadowRoot.querySelector('ul')).not.toHaveClass('ng-hide');

            tb.triggerEvent(shadowRoot.querySelector('[value="30"] p'), 'mousedown');
            tb.triggerEvent(shadowRoot.querySelector('[value="30"] p'), 'mouseup');
            tb.triggerEvent(shadowRoot.querySelector('[value="30"] p'), 'click');

            expect(shadowRoot.querySelector('ul')).toHaveClass('ng-hide');
            expect(tb.rootScope.context['val']).toEqual(30);
        });

        test('should be able to select a value with a tap', () {
            tb.triggerEvent(shadowRoot.querySelector('div'), 'touchstart');
            tb.triggerEvent(shadowRoot.querySelector('div'), 'touchend');

            expect(shadowRoot.querySelector('ul')).not.toHaveClass('ng-hide');

            tb.triggerEvent(shadowRoot.querySelector('[value="30"] p'), 'touchstart');
            tb.triggerEvent(shadowRoot.querySelector('[value="30"] p'), 'touchend');
            tb.triggerEvent(shadowRoot.querySelector('[value="30"] p'), 'click');

            expect(shadowRoot.querySelector('ul')).toHaveClass('ng-hide');
            expect(tb.rootScope.context['val']).toEqual(30);
        });

        test('should be able to select a value with a mouse drag', () {
            tb.triggerEvent(shadowRoot.querySelector('div'), 'mousedown');
            tb.triggerEvent(shadowRoot.querySelector('div'), 'mouseout');

            expect(shadowRoot.querySelector('ul')).not.toHaveClass('ng-hide');

            tb.triggerEvent(shadowRoot.querySelector('[value="30"] p'), 'mouseup');

            expect(shadowRoot.querySelector('ul')).toHaveClass('ng-hide');
            expect(tb.rootScope.context['val']).toEqual(30);
        });

        test('should be able to select a value with a touch drag', () {
            tb.triggerEvent(shadowRoot.querySelector('div'), 'touchstart');
            tb.triggerEvent(shadowRoot.querySelector('div'), 'touchleave');

            expect(shadowRoot.querySelector('ul')).not.toHaveClass('ng-hide');

            tb.triggerEvent(shadowRoot.querySelector('[value="30"] p'), 'touchend');

            expect(shadowRoot.querySelector('ul')).toHaveClass('ng-hide');
            expect(tb.rootScope.context['val']).toEqual(30);
        });
    });
}
