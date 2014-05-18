library dropdown_tests;

import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';
import 'package:guinness/guinness_html.dart';
import '../../helpers.dart';
import '../../../web/lib/cogito.dart';


main() {
    guinnessEnableHtmlMatchers();

    describe('DropDownComponent', () {
        Element element;
        ShadowRoot shadowRoot;
        TestBed tb;

        beforeEach(() {
            // Prepare Angular for testing
            setUpInjector();

            // Make required classes available for dependency injection
            module((Module _) => _
                    ..bind(DropDownComponent)
                    ..bind(PrioritizeFormatter)
                    ..bind(TestBed));

            // Add required templates to the cache
            addToTemplateCache('lib/components/dropdown/dropdown.css');
            addToTemplateCache('lib/components/dropdown/dropdown.html');

            // Acquire a TestBed instance
            inject((TestBed _tb) => tb = _tb);
        });

        // Tell Angular we are done
        afterEach(() {
            tearDownInjector();

            element.remove();
        });

        describe('int type', () {
            beforeEach(() {
                // Prepare test values
                var textSizes = [];
                for (var i = 12; i <= 72; i+= 2) {
                    textSizes.add(i);
                }

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

            it('should prioritize values correctly', () {
                var prioritizedValues = shadowRoot.querySelectorAll('li').map((element) => element.getAttribute('value'));

                expect(prioritizedValues).toEqual(['12', '14', '16', '18', '20', '24', '26', '28', '30', '32', '36', '46', '56', '66']);

                tb.triggerEvent(shadowRoot.querySelector('div'), 'mousedown');
                tb.triggerEvent(shadowRoot.querySelector('div'), 'mouseout');
                tb.triggerEvent(shadowRoot.querySelector('[value="30"] p'), 'mouseup');

                prioritizedValues = shadowRoot.querySelectorAll('li').map((element) => element.getAttribute('value'));

                expect(prioritizedValues).toEqual(['16', '20', '22', '24', '26', '28', '32', '34', '36', '38', '40', '44', '54', '64']);
            });

            it('should be hidden from start', () {
                expect(shadowRoot.querySelector('ul')).toHaveClass('ng-hide');
            });

            it('should be shown after a click', () {
                tb.triggerEvent(shadowRoot.querySelector('div'), 'mousedown');
                tb.triggerEvent(shadowRoot.querySelector('div'), 'mouseup');

                expect(shadowRoot.querySelector('ul')).not.toHaveClass('ng-hide');
            });

            it('should be shown after a mouse drag', () {
                tb.triggerEvent(shadowRoot.querySelector('div'), 'mousedown');
                tb.triggerEvent(shadowRoot.querySelector('div'), 'mouseout');

                expect(shadowRoot.querySelector('ul')).not.toHaveClass('ng-hide');
            });

            it('should hide after a click', () {
                tb.triggerEvent(shadowRoot.querySelector('div'), 'mousedown');
                tb.triggerEvent(shadowRoot.querySelector('div'), 'mouseup');

                tb.triggerEvent(shadowRoot.querySelector('div'), 'mousedown');
                tb.triggerEvent(shadowRoot.querySelector('div'), 'mouseup');

                expect(shadowRoot.querySelector('ul')).toHaveClass('ng-hide');
            });

            it('should be able to select a value with a click', () {
                tb.triggerEvent(shadowRoot.querySelector('div'), 'mousedown');
                tb.triggerEvent(shadowRoot.querySelector('div'), 'mouseup');

                expect(shadowRoot.querySelector('ul')).not.toHaveClass('ng-hide');

                tb.triggerEvent(shadowRoot.querySelector('[value="30"] p'), 'mousedown');
                tb.triggerEvent(shadowRoot.querySelector('[value="30"] p'), 'mouseup');
                tb.triggerEvent(shadowRoot.querySelector('[value="30"] p'), 'click');

                expect(shadowRoot.querySelector('ul')).toHaveClass('ng-hide');
                expect(tb.rootScope.context['val']).toEqual(30);
            });

            it('should be able to select a value with a mouse drag', () {
                tb.triggerEvent(shadowRoot.querySelector('div'), 'mousedown');
                tb.triggerEvent(shadowRoot.querySelector('div'), 'mouseout');

                expect(shadowRoot.querySelector('ul')).not.toHaveClass('ng-hide');

                tb.triggerEvent(shadowRoot.querySelector('[value="30"] p'), 'mouseup');

                expect(shadowRoot.querySelector('ul')).toHaveClass('ng-hide');
                expect(tb.rootScope.context['val']).toEqual(30);
            });

            it('should show the selected value', () {
                expect(shadowRoot.querySelector('div>p').text).toContain('22');

                tb.triggerEvent(shadowRoot.querySelector('div'), 'mousedown');
                tb.triggerEvent(shadowRoot.querySelector('div'), 'mouseout');
                tb.triggerEvent(shadowRoot.querySelector('[value="30"] p'), 'mouseup');

                expect(shadowRoot.querySelector('div>p').text).toContain('30');
            });

            it('should show the selectable values', () {
                ['12', '14', '16', '18', '20', '24', '26', '28', '30', '32', '36', '46', '56', '66'].forEach((size) {
                    expect(shadowRoot.querySelector('[value="$size"] p').text).toContain('$size');
                });

                tb.triggerEvent(shadowRoot.querySelector('div'), 'mousedown');
                tb.triggerEvent(shadowRoot.querySelector('div'), 'mouseout');
                tb.triggerEvent(shadowRoot.querySelector('[value="30"] p'), 'mouseup');

                ['16', '20', '22', '24', '26', '28', '32', '34', '36', '38', '40', '44', '54', '64'].forEach((size) {
                    expect(shadowRoot.querySelector('[value="$size"] p').text).toContain('$size');
                });
            });
        });

        describe('color type', () {
            beforeEach(() {
                tb.rootScope.context['val'] = 'green';
                tb.rootScope.context['vals'] = ['red', 'green', 'blue'];
                element = tb.compile('<dropdown type="color" values="vals" ng-model="val"></dropdown>');
                shadowRoot = element.shadowRoot;

                // Add the element to the dom so that events can bubble
                document.body.append(element);

                tb.rootScope.apply();

                // Make sure Angular get time to attach the shadow root
                return new Future.delayed(Duration.ZERO, () => tb.getScope(shadowRoot.querySelector('div')).apply());
            });

            it('should show the selected value', () {
                expect(shadowRoot.querySelector('div>p').style.backgroundColor).toEqual('green');

                tb.triggerEvent(shadowRoot.querySelector('div'), 'mousedown');
                tb.triggerEvent(shadowRoot.querySelector('div'), 'mouseout');
                tb.triggerEvent(shadowRoot.querySelector('[value="red"] p'), 'mouseup');

                expect(shadowRoot.querySelector('div>p').style.backgroundColor).toEqual('red');
            });

            it('should show the selectable values', () {
                expect(shadowRoot.querySelector('[value="red"] p').style.backgroundColor).toEqual('red');
                expect(shadowRoot.querySelector('[value="green"] p').style.backgroundColor).toEqual('green');
                expect(shadowRoot.querySelector('[value="blue"] p').style.backgroundColor).toEqual('blue');
            });
        });
    });
}
