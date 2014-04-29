library panel_tests;

import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';
import 'package:unittest/unittest.dart';
import '../web/lib/cogito.dart';

/**
 * It adds an html template into the TemplateCache.
 */
void addToTemplateCache(String path) {
    inject((TemplateCache cache) {
        HttpRequest request = new HttpRequest()
            ..open('GET', "../web/$path", async: false)
            ..send();
        cache.put(path, new HttpResponse(200, request.responseText));
    });
}

main() {
    unittestConfiguration.timeout = new Duration(seconds: 3);

    group('PanelComponent', () {
        setUp(() {
            setUpInjector();
            module((Module _) => _
                ..type(MockHttpBackend)
                ..type(ToolController)
                ..type(PanelComponent)
                ..type(TestBed));

            addToTemplateCache('lib/components/panel/panel.css');
            addToTemplateCache('lib/components/panel/panel.html');
        });

        tearDown(tearDownInjector);

        group('right', () {
            ShadowRoot element;

            Element getElement(tool) => element.querySelector("[ng-click=\"tool.selectedTool = '$tool'\"]");

            setUp(() {
                inject((TestBed tb) {
                    element = tb.compile('<panel position="right" tool-controller></panel>').shadowRoot;
                    tb.rootScope.apply();
                });
            });

            test('have select tool', () {
                Timer.run(expectAsync(() {
                    expect(getElement('select'), isNotNull);
                }));
            });

            test('have draw tool', () {
                Timer.run(expectAsync(() {
                    expect(getElement('draw'), isNotNull);
                }));
            });

            test('have text tool', () {
                Timer.run(expectAsync(() {
                    expect(getElement('text'), isNotNull);
                }));
            });

            test('have list tool', () {
                Timer.run(expectAsync(() {
                    expect(getElement('list'), isNotNull);
                }));
            });

            test('select tool is choosed when clicked', () {
                inject((TestBed tb, ToolController tool) {
                    Timer.run(expectAsync(() {
                        tb.triggerEvent(getElement('select'), 'click');
                        microLeap();

                        expect(getElement('select').classes.contains('active'), isTrue);
                        expect(tool.selectedTool, equals('select'));
                    }));
                });
            });

            test('draw tool is choosed when clicked', () {
                inject((TestBed tb, ToolController tool) {
                    Timer.run(expectAsync(() {
                        tb.triggerEvent(getElement('draw'), 'click');
                        microLeap();

                        expect(getElement('draw').classes.contains('active'), isTrue);
                        expect(tool.selectedTool, equals('draw'));
                    }));
                });
            });

            test('text tool is choosed when clicked', () {
                inject((TestBed tb, ToolController tool) {
                    Timer.run(expectAsync(() {
                        tb.triggerEvent(getElement('text'), 'click');
                        microLeap();

                        expect(getElement('text').classes.contains('active'), isTrue);
                        expect(tool.selectedTool, equals('text'));
                    }));
                });
            });

            test('list tool is choosed when clicked', () {
                inject((TestBed tb, ToolController tool) {
                    Timer.run(expectAsync(() {
                        tb.triggerEvent(getElement('list'), 'click');
                        microLeap();

                        expect(getElement('list').classes.contains('active'), isTrue);
                        expect(tool.selectedTool, equals('list'));
                    }));
                });
            });
        });
    });
}
