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

    describe('PanelComponent', () {
        ShadowRoot shadowRoot;
        TestBed tb;
        ToolController tool;

        beforeEach(() {
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
        afterEach(tearDownInjector);

        describe('right', () {

            // Makes it easy to get the element we're testing
            Element element(tool) => shadowRoot.querySelector('''[ng-click="tool.selectedTool = '$tool'"]''');

            beforeEach(() {
                shadowRoot = tb.compile('<panel position="right"></panel>').shadowRoot;
                tb.rootScope.apply();
            });

            it('should have a select tool', () {
                Timer.run(expectAsync(() {
                    expect(element('select')).toBeNotNull();
                }));
            });

            it('should have a draw tool', () {
                Timer.run(expectAsync(() {
                    expect(element('draw')).toBeNotNull();
                }));
            });

            it('should have a text tool', () {
                Timer.run(expectAsync(() {
                    expect(element('text')).toBeNotNull();
                }));
            });

            it('should have a list tool', () {
                Timer.run(expectAsync(() {
                    expect(element('list')).toBeNotNull();
                }));
            });

            it('should have a line tool', () {
                Timer.run(expectAsync(() {
                    expect(element('line')).toBeNotNull();
                }));
            });

            it('should have an arrow tool', () {
                Timer.run(expectAsync(() {
                    expect(element('arrow')).toBeNotNull();
                }));
            });

            it('should choose the select tool when clicked', () {
                Timer.run(expectAsync(() {
                    tb.triggerEvent(element('select'), 'click');

                    expect(element('select')).toHaveClass('active');
                    expect(tool.selectedTool).toEqual('select');
                }));
            });

            it('should choose the draw tool when clicked', () {
                Timer.run(expectAsync(() {
                    tb.triggerEvent(element('draw'), 'click');

                    expect(element('draw')).toHaveClass('active');
                    expect(tool.selectedTool).toEqual('draw');
                }));
            });

            it('should choose the text tool when clicked', () {
                Timer.run(expectAsync(() {
                    tb.triggerEvent(element('text'), 'click');

                    expect(element('text')).toHaveClass('active');
                    expect(tool.selectedTool).toEqual('text');
                }));
            });

            it('should choose the list tool when clicked', () {
                Timer.run(expectAsync(() {
                    tb.triggerEvent(element('list'), 'click');

                    expect(element('list')).toHaveClass('active');
                    expect(tool.selectedTool).toEqual('list');
                }));
            });

            it('should choose the line tool when clicked', () {
                Timer.run(expectAsync(() {
                    tb.triggerEvent(element('line'), 'click');

                    expect(element('line')).toHaveClass('active');
                    expect(tool.selectedTool).toEqual('line');
                }));
            });

            it('should choose the arrow tool when clicked', () {
                Timer.run(expectAsync(() {
                    tb.triggerEvent(element('arrow'), 'click');

                    expect(element('arrow')).toHaveClass('active');
                    expect(tool.selectedTool).toEqual('arrow');
                }));
            });
        });
    });
}
