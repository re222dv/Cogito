library panel_tests;

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
    unittestConfiguration.timeout = new Duration(seconds: 3);

    group('PanelComponent', () {
        ShadowRoot shadowRoot;
        TestBed tb;
        ToolController tool;

        setUp(() {
            // Prepare Angular for testing
            setUpInjector();

            // Make required classes available for dependency injection
            module((Module _) => _
                ..type(MockHttpBackend)
                ..type(ToolController)
                ..type(PanelComponent)
                ..type(TestBed));

            // Add required templates to the cache
            addToTemplateCache('lib/components/panel/panel.css');
            addToTemplateCache('lib/components/panel/panel.html');

            // Acquire a TestBed and ToolController instance
            inject((TestBed _tb, ToolController _tool) {
                tb = _tb;
                tool = _tool;
            });
        });

        // Tell Angular we are done
        tearDown(tearDownInjector);

        group('right', () {

            // Makes it easy to get the element we're testing
            Element element(tool) => shadowRoot.querySelector('''[ng-click="tool.selectedTool = '$tool'"]''');

            setUp(() {
                shadowRoot = tb.compile('<panel position="right"></panel>').shadowRoot;
                tb.rootScope.apply();

                // Make sure Angular get time to attach the shadow root
                return new Future.delayed(Duration.ZERO, () => tb.getScope(shadowRoot.querySelector('div')).apply());
            });

            test('should have a select tool', () {
                expect(element('select')).toBeNotNull();
            });

            test('should have a draw tool', () {
                expect(element('draw')).toBeNotNull();
            });

            test('should have a text tool', () {
                expect(element('text')).toBeNotNull();
            });

            test('should have a list tool', () {
                expect(element('list')).toBeNotNull();
            });

            test('should have a line tool', () {
                expect(element('line')).toBeNotNull();
            });

            test('should have an arrow tool', () {
                expect(element('arrow')).toBeNotNull();
            });

            test('should choose the select tool when clicked', () {
                tb.triggerEvent(element('select'), 'click');

                expect(element('select')).toHaveClass('active');
                expect(tool.selectedTool).toEqual('select');
            });

            test('should choose the draw tool when clicked', () {
                tb.triggerEvent(element('draw'), 'click');

                expect(element('draw')).toHaveClass('active');
                expect(tool.selectedTool).toEqual('draw');
            });

            test('should choose the text tool when clicked', () {
                tb.triggerEvent(element('text'), 'click');

                expect(element('text')).toHaveClass('active');
                expect(tool.selectedTool).toEqual('text');
            });

            test('should choose the list tool when clicked', () {
                tb.triggerEvent(element('list'), 'click');

                expect(element('list')).toHaveClass('active');
                expect(tool.selectedTool).toEqual('list');
            });

            test('should choose the line tool when clicked', () {
                tb.triggerEvent(element('line'), 'click');

                expect(element('line')).toHaveClass('active');
                expect(tool.selectedTool).toEqual('line');
            });

            test('should choose the arrow tool when clicked', () {
                tb.triggerEvent(element('arrow'), 'click');

                expect(element('arrow')).toHaveClass('active');
                expect(tool.selectedTool).toEqual('arrow');
            });
        });
    });
}
