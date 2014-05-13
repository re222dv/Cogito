library panel_tests;

import 'dart:async';
import 'dart:html' hide Path, Text;
import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';
import 'package:unittest/unittest.dart' hide expect;
import 'package:guinness/guinness_html.dart';
import '../../helpers.dart';
import 'package:cogito/cogito.dart';
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
                ..bind(MockHttpBackend)
                ..bind(ToolController)
                ..bind(ToolDecorator)
                ..bind(PanelComponent)
                ..bind(TestBed));

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
        tearDown(() {
            tearDownInjector();

            // Reset ToolController as it is a singleton
            tool.toolDrag = new StreamController.broadcast();
            tool.selectedNode = null;
        });

        group('right', () {

            // Makes it easy to get the element we're testing
            Element element(tool) => shadowRoot.querySelector('[tool="$tool"]');

            setUp(() {
                shadowRoot = tb.compile('<panel position="right"></panel>').shadowRoot;
                tb.rootScope.apply();

                // Make sure Angular get time to attach the shadow root
                return new Future.delayed(Duration.ZERO, () => tb.getScope(shadowRoot.querySelector('div')).apply());
            });

            test('should stop clicks', () {
                expect(shadowRoot.querySelector('div>div[stop-clicks]')).toBeNotNull();
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

            test('should trigger a onDrag event when text is dragged by mouse', () {
                tool.onToolDrag.listen(expectAsync((tool) {
                    expect(tool).toEqual('text');
                }));

                Timer.run(expectAsync(() {
                    tb.triggerEvent(element('text'), 'mousedown');
                    tb.triggerEvent(element('text'), 'mouseout');
                }));
            });

            test('should trigger a onDrag event when text is dragged by touch', () {
                tool.onToolDrag.listen(expectAsync((tool) {
                    expect(tool).toEqual('text');
                }));

                Timer.run(expectAsync(() {
                    tb.triggerEvent(element('text'), 'touchstart');
                    tb.triggerEvent(element('text'), 'touchleave');
                }));
            });

            test('should trigger a onDrag event when list is dragged by mouse', () {
                tool.onToolDrag.listen(expectAsync((tool) {
                    expect(tool).toEqual('list');
                }));

                Timer.run(expectAsync(() {
                    tb.triggerEvent(element('list'), 'mousedown');
                    tb.triggerEvent(element('list'), 'mouseout');
                }));
            });

            test('should trigger a onDrag event when list is dragged by touch', () {
                tool.onToolDrag.listen(expectAsync((tool) {
                    expect(tool).toEqual('list');
                }));

                Timer.run(expectAsync(() {
                    tb.triggerEvent(element('list'), 'touchstart');
                    tb.triggerEvent(element('list'), 'touchleave');
                }));
            });
        });

        group('left', () {

            // Makes it easy to get the element we're testing
            Element element(tool) => shadowRoot.querySelector('[ng-click="tool.$tool()"]');

            setUp(() {
                shadowRoot = tb.compile('<panel position="left"></panel>').shadowRoot;
                tb.rootScope.apply();

                // Make sure Angular get time to attach the shadow root
                return new Future.delayed(Duration.ZERO, () => tb.getScope(shadowRoot.querySelector('div')).apply());
            });

            test('should stop clicks', () {
                expect(shadowRoot.querySelector('div>div[stop-clicks]')).toBeNotNull();
            });

            test('should have a save button', () {
                expect(element('save')).toBeNotNull();
            });
        });

        group('top', () {

            // Makes it easy to get the elements we're testing
            Element element(tool) => shadowRoot.querySelector('[ng-click="tool.$tool"]');

            Element dropdown(type) => shadowRoot.querySelector('dropdown[ng-model="tool.selectedNode.$type"]');

            setUp(() {
                shadowRoot = tb.compile('<panel position="top"></panel>').shadowRoot;
                tb.rootScope.apply();

                // Make sure Angular get time to attach the shadow root
                return new Future.delayed(Duration.ZERO, () => tb.getScope(shadowRoot.querySelector('div')).apply());
            });

            test('should stop clicks', () {
                tool.selectedNode = new Line();
                tb.getScope(shadowRoot.querySelector('div')).apply();

                expect(shadowRoot.querySelector('div>div[stop-clicks]')).toBeNotNull();
            });

            test('should not be shown when no node is selected', () {
                expect(shadowRoot.querySelector('div>div')).toBeNull();
            });

            group('for Line', () {
                setUp(() {
                    tool.selectedNode = new Line();
                    tb.getScope(shadowRoot.querySelector('div')).apply();
                });

                test('should have a color dropdown', () {
                    expect(dropdown('color')).toBeNotNull();
                });

                test('should have a width dropdown', () {
                    expect(dropdown('width')).toBeNotNull();
                });

                test('should have a raise button', () {
                    expect(element('raise()')).toBeNotNull();
                });

                test('should have a lower button', () {
                    expect(element('lower()')).toBeNotNull();
                });

                test('should have a delete button', () {
                    expect(element('delete()')).toBeNotNull();
                });
            });

            group('for Arrow', () {
                setUp(() {
                    tool.selectedNode = new Arrow();
                    tb.getScope(shadowRoot.querySelector('div')).apply();
                });

                test('should have a color dropdown', () {
                    expect(dropdown('color')).toBeNotNull();
                });

                test('should have a width dropdown', () {
                    expect(dropdown('width')).toBeNotNull();
                });

                test('should have a raise button', () {
                    expect(element('raise()')).toBeNotNull();
                });

                test('should have a lower button', () {
                    expect(element('lower()')).toBeNotNull();
                });

                test('should have a delete button', () {
                    expect(element('delete()')).toBeNotNull();
                });
            });

            group('for Path', () {
                setUp(() {
                    tool.selectedNode = new Path();
                    tb.getScope(shadowRoot.querySelector('div')).apply();
                });

                test('should have a color dropdown', () {
                    expect(dropdown('color')).toBeNotNull();
                });

                test('should have a width dropdown', () {
                    expect(dropdown('width')).toBeNotNull();
                });

                test('should have a raise button', () {
                    expect(element('raise()')).toBeNotNull();
                });

                test('should have a lower button', () {
                    expect(element('lower()')).toBeNotNull();
                });

                test('should have a delete button', () {
                    expect(element('delete()')).toBeNotNull();
                });
            });

            group('for Text', () {
                setUp(() {
                    tool.selectedNode = new Text();
                    tb.getScope(shadowRoot.querySelector('div')).apply();
                });

                test('should have a color dropdown', () {
                    expect(dropdown('color')).toBeNotNull();
                });

                test('should have a size dropdown', () {
                    expect(dropdown('size')).toBeNotNull();
                });

                test('should have a raise button', () {
                    expect(element('raise()')).toBeNotNull();
                });

                test('should have a lower button', () {
                    expect(element('lower()')).toBeNotNull();
                });

                test('should have a delete button', () {
                    expect(element('delete()')).toBeNotNull();
                });
            });

            group('for BasicList', () {
                setUp(() {
                    tool.selectedNode = new BasicList();
                    tb.getScope(shadowRoot.querySelector('div')).apply();
                });

                test('should have a color dropdown', () {
                    expect(dropdown('color')).toBeNotNull();
                });

                test('should have a size dropdown', () {
                    expect(dropdown('size')).toBeNotNull();
                });

                test('should have a ul button', () {
                    expect(element('selectedNode.listType = \'unordered\'')).toBeNotNull();
                });

                test('should have a ol button', () {
                    expect(element('selectedNode.listType = \'ordered\'')).toBeNotNull();
                });

                test('should have a checked button', () {
                    expect(element('selectedNode.listType = \'checked\'')).toBeNotNull();
                });

                test('should have a raise button', () {
                    expect(element('raise()')).toBeNotNull();
                });

                test('should have a lower button', () {
                    expect(element('lower()')).toBeNotNull();
                });

                test('should have a delete button', () {
                    expect(element('delete()')).toBeNotNull();
                });

                test('should choose the ul button when clicked', () {
                    tb.triggerEvent(element('selectedNode.listType = \'unordered\''), 'click');

                    expect(element('selectedNode.listType = \'unordered\'')).toHaveClass('active');
                    expect((tool.selectedNode as BasicList).listType).toEqual('unordered');
                });

                test('should choose the ol button when clicked', () {
                    tb.triggerEvent(element('selectedNode.listType = \'ordered\''), 'click');

                    expect(element('selectedNode.listType = \'ordered\'')).toHaveClass('active');
                    expect((tool.selectedNode as BasicList).listType).toEqual('ordered');
                });

                test('should choose the checked button when clicked', () {
                    tb.triggerEvent(element('selectedNode.listType = \'checked\''), 'click');

                    expect(element('selectedNode.listType = \'checked\'')).toHaveClass('active');
                    expect((tool.selectedNode as BasicList).listType).toEqual('checked');
                });
            });
        });
    });
}
