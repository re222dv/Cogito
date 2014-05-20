library circle_tool_tests;

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
        var values = [1, 2, 3, 4, 5, 6];

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

    describe('CircleToolDecorator', () {
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
                    ..bind(CircleToolDecorator)
                    ..bind(ToolController)
                    ..bind(TestBed));

            // Acquire a TestBed and ToolController instance
            inject((TestBed _tb, ToolController _tool) {
                tb = _tb;
                tool = _tool;
            });

            rootElement = tb.compile('<div><svg circle-tool></svg></div>');
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

            rootElement.remove();
        });

        // Preconditions
        Future whenSelected() {
            tool.selectedTool = 'circle';

            return new Future.delayed(Duration.ZERO);
        }

        Future whenDrawn() {
            return whenSelected().then((_) {
                tb.triggerEvent(svgElement, 'mousedown');
                tb.triggerEvent(svgElement, 'mousemove');
                tb.triggerEvent(svgElement, 'mouseup');
            });
        }

        it('should set a temporary node as selectedNode when activated', () {
            return whenSelected().then((_) {
                expect(tool.selectedNode).toBeNotNull();
            });
        });

        it('should do nothing on just a click', () {
            return whenSelected().then((_) {
                tb.triggerEvent(svgElement, 'mousedown');
                tb.triggerEvent(svgElement, 'mouseup');

                expect(tool.page.page.nodes.length).toBe(0);
            });
        });

        it('should be able to draw a line', () {
            return whenSelected().then((_) {
                tb.triggerEvent(svgElement, 'mousedown');
                tb.triggerEvent(svgElement, 'mousemove');
                tb.triggerEvent(svgElement, 'mouseup');

                expect(tool.page.page.nodes.length).toBe(1);

                expect(JSON.encode(tool.page.page.nodes[0].toJson())).toEqual(JSON.encode({
                    'type': 'circle',
                    'x': 1,
                    'y': 2,
                    'radius': 2.8284271247461903,
                    'fillColor': 'black',
                    'strokeColor': 'red',
                    'strokeWidth': 5
                }));
            });
        });

        it('should do nothing on just a click after an element have been drawn', () {
            return whenDrawn().then((_) {
                tb.triggerEvent(svgElement, 'mousedown');
                tb.triggerEvent(svgElement, 'mouseup');

                expect(tool.page.page.nodes.length).toBe(1);
            });
        });
    });
}
