library list_tool_tests;

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:math' as math;
import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';
import 'package:guinness/guinness_html.dart';
import 'package:cogito/cogito.dart';
import '../../../web/lib/cogito.dart';


class MockPageComponent implements PageComponent {
    var getPointSpy;
    var page = new Page();

    MockPageComponent() {
        var values = [1, 2, 3, 4];

        getPointSpy = guinness.createSpy('getPointSpy').andCallFake((_) {
            return new math.Point(values.removeAt(0), values.removeAt(0));
        });
    }

    getPoint(MouseEvent e) => getPointSpy(e);

    // Ignore warnings about unimplemented methods
    noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}


main() {
    guinnessEnableHtmlMatchers();

    describe('ListToolDecorator', () {
        Element rootElement;
        Element svgElement;
        ShadowRoot shadowRoot;
        TestBed tb;
        ToolController tool;

        beforeEach(() {
            // Prepare Angular for testing
            setUpInjector();

            // Make required classes available for dependency injection
            module((Module _) => _
                    ..bind(ListToolDecorator)
                    ..bind(ToolController)
                    ..bind(TestBed));

            // Acquire a TestBed and ToolController instance
            inject((TestBed _tb, ToolController _tool) {
                tb = _tb;
                tool = _tool;
            });

            rootElement = tb.compile('<div><svg list-tool></svg></div>');
            svgElement = rootElement.querySelector('svg');

            // Add the element to the dom so that events can bubble
            document.body.append(rootElement);

            // As ToolController is a singleton we need to reset it between tests
            tool.page = new MockPageComponent();
            tool.selectedNode = null;
            tool.selectedTool = 'select';
        });

        // Tell Angular we are done
        afterEach(() {
            tearDownInjector();

            // As ToolController is a singleton we need to reset it between tests
            tool.toolDrag = new StreamController.broadcast();

            rootElement.remove();
        });

        // Preconditions
        Future whenSelected() {
            tool.selectedTool = 'list';

            return new Future.delayed(Duration.ZERO);
        }

        Future whenAdded() {
            return whenSelected().then((_) {
                tb.triggerEvent(svgElement, 'click');
            });
        }

        Future whenDragged() {
            tool.toolDrag.add('list');

            return new Future.delayed(Duration.ZERO);
        }

        it('should set a temporary node as selectedNode when activated', () {
            return whenSelected().then((_) {
                expect(tool.selectedNode).toBeNotNull();
            });
        });

        it('should add an empty list in edit mode on click', () {
            return whenAdded().then((_) {
                expect(tool.page.page.nodes.length).toBe(1);

                expect(JSON.encode(tool.page.page.nodes[0].toJson())).toEqual(JSON.encode({
                    'type': 'basicList',
                    'x': 1,
                    'y': -10,
                    'scale': 1,
                    'color': 'black',
                    'size': 24,
                    'rows': []
                }));

                expect(tool.page.page.nodes[0].editing).toEqual(true);
            });
        });

        it('should remove the empty list on click outside', () {
            return whenAdded().then((_) {
                tb.triggerEvent(svgElement, 'click');

                expect(tool.page.page.nodes.length).toBe(1);
            });
        });

        it('should not remove the list on click outside when filled', () {
            return whenAdded().then((_) {
                (tool.page.page.nodes[0] as BasicList).text = 'FooBar';
                tb.triggerEvent(svgElement, 'click');

                expect(tool.page.page.nodes.length).toBe(2);
            });
        });

        it('should add an empty list in edit mode on drag', () {
            return whenDragged().then((_) {
                expect(tool.selectedNode).toBeNotNull();
                expect(tool.page.page.nodes.length).toBe(1);

                tb.triggerEvent(svgElement, 'mousemove');

                expect(JSON.encode(tool.page.page.nodes[0].toJson())).toEqual(JSON.encode({
                    'type': 'basicList',
                    'x': 1,
                    'y': 2,
                    'scale': 1,
                    'color': 'black',
                    'size': 24,
                    'rows': []
                }));

                expect(tool.page.page.nodes[0].editing).toEqual(true);
            });
        });
    });
}
