library line_tool_tests;

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

    describe('LineToolDecorator', () {
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
                    ..bind(LineToolDecorator)
                    ..bind(ToolController, toFactory: ToolController.newInstance)
                    ..bind(TestBed));

            // Acquire a TestBed and ToolController instance
            inject((TestBed _tb, ToolController _tool) {
                tb = _tb;
                tool = _tool;
            });

            rootElement = tb.compile('<div><svg line-tool></svg></div>');
            svgElement = rootElement.querySelector('svg');

            // Add the element to the dom so that events can bubble
            document.body.append(rootElement);

            tool.page = new MockPageComponent();
        });

        // Tell Angular we are done
        afterEach(() {
            tearDownInjector();

            rootElement.remove();
        });

        // Preconditions
        Future whenSelected() {
            tool.selectedTool = 'line';

            return new Future.delayed(Duration.ZERO);
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
                    'type': 'line',
                    'x': 1,
                    'y': 2,
                    'scale': 1,
                    'color': 'black',
                    'width': 5,
                    'start': {
                        'x': 0,
                        'y': 0
                    },
                    'end': {
                        'x': 2,
                        'y': 2
                    }
                }));
            });
        });
    });
}
