library tool_decorator_tests;

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

    group('ToolDecorator', () {
        Element rootElement;
        TestBed tb;
        ToolController tool;

        // Makes it easy to get the element we're testing
        Element element(tool) => rootElement.querySelector('[tool="$tool"]');

        setUp(() {
            // Prepare Angular for testing
            setUpInjector();

            // Make required classes available for dependency injection
            module((Module _) => _
                ..bind(ToolController)
                ..bind(ToolDecorator)
                ..bind(TestBed));

            // Acquire a TestBed and ToolController instance
            inject((TestBed _tb, ToolController _tool) {
                tb = _tb;
                tool = _tool;
            });

            rootElement = tb.compile('<div><button tool="draw"></button><button tool="line"></button></div>');
            tb.rootScope.apply();

            tool.selectedTool = 'draw';
        });

        // Tell Angular we are done
        tearDown(() {
            tearDownInjector();
        });

        test('should activate the draw tool button from start', () {
            expect(element('draw')).toBeNotNull();
        });

        test('should deactivate the draw tool and select the line tool on click', () {
            tb.triggerEvent(element('line'), 'click');

            Timer.run(expectAsync(() {
                expect(element('draw')).not.toHaveClass('active');
                expect(element('line')).toHaveClass('active');
                expect(tool.selectedTool).toEqual('line');
            }));
        });
    });
}
