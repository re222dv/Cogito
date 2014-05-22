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
                ..bind(UserService)
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

            test('should have a rect tool', () {
                expect(element('rect')).toBeNotNull();
            });

            test('should have an circle tool', () {
                expect(element('circle')).toBeNotNull();
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

            test('should trigger a onDrag event when list is dragged by mouse', () {
                tool.onToolDrag.listen(expectAsync((tool) {
                    expect(tool).toEqual('list');
                }));

                Timer.run(expectAsync(() {
                    tb.triggerEvent(element('list'), 'mousedown');
                    tb.triggerEvent(element('list'), 'mouseout');
                }));
            });
        });

        group('left', () {

            // Makes it easy to get the element we're testing
            Element element(tool) => shadowRoot.querySelector('[ng-click="tool.$tool()"]');
            Element menu(icon, items) => shadowRoot.querySelector('popup-menu[data-icon="$icon"][items="$items"]');

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

            test('should have a user menu', () {
                expect(menu('user', "{'Logout': cmp.logout}")).toBeNotNull();
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
                tool.selectedNode = new LineNode();
                tb.getScope(shadowRoot.querySelector('div')).apply();

                expect(shadowRoot.querySelector('div>div[stop-clicks]')).toBeNotNull();
            });

            test('should not be shown when no node is selected', () {
                expect(shadowRoot.querySelector('div>div')).toBeNull();
            });

            group('for Line', () {
                setUp(() {
                    tool.selectedNode = new LineNode();
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
                    tool.selectedNode = new ArrowNode();
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
                    tool.selectedNode = new PathNode();
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
                    tool.selectedNode = new TextNode();
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

            group('for List', () {
                setUp(() {
                    tool.selectedNode = new ListNode();
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
                    expect((tool.selectedNode as ListNode).listType).toEqual('unordered');
                });

                test('should choose the ol button when clicked', () {
                    tb.triggerEvent(element('selectedNode.listType = \'ordered\''), 'click');

                    expect(element('selectedNode.listType = \'ordered\'')).toHaveClass('active');
                    expect((tool.selectedNode as ListNode).listType).toEqual('ordered');
                });

                test('should choose the checked button when clicked', () {
                    tb.triggerEvent(element('selectedNode.listType = \'checked\''), 'click');

                    expect(element('selectedNode.listType = \'checked\'')).toHaveClass('active');
                    expect((tool.selectedNode as ListNode).listType).toEqual('checked');
                });
            });

            group('for Rect', () {
                setUp(() {
                    tool.selectedNode = new RectNode();
                    tb.getScope(shadowRoot.querySelector('div')).apply();
                });

                test('should have a fill color dropdown', () {
                    expect(dropdown('fillColor')).toBeNotNull();
                });

                test('should have a stroke color dropdown', () {
                    expect(dropdown('strokeColor')).toBeNotNull();
                });

                test('should have a stroke width dropdown', () {
                    expect(dropdown('strokeWidth')).toBeNotNull();
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

            group('for Circle', () {
                setUp(() {
                    tool.selectedNode = new CircleNode();
                    tb.getScope(shadowRoot.querySelector('div')).apply();
                });

                test('should have a fill color dropdown', () {
                    expect(dropdown('fillColor')).toBeNotNull();
                });

                test('should have a stroke color dropdown', () {
                    expect(dropdown('strokeColor')).toBeNotNull();
                });

                test('should have a stroke width dropdown', () {
                    expect(dropdown('strokeWidth')).toBeNotNull();
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
        });
    });
}
