library page_tests;

import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';
import 'package:unittest/unittest.dart' hide expect;
import 'package:guinness/guinness_html.dart';
import '../../helpers.dart';
import 'package:cogito/cogito.dart';
import '../../../web/lib/cogito.dart';

class PageServiceMock implements PageService {
    Future<Page> getPage() => new Future.sync(() =>
        new Page()
            ..nodes = [
                new Line(),
                new Arrow()
            ]
    );
}


main() {
    guinnessEnableHtmlMatchers();

    group('PageComponent', () {
        Element element;
        MockHttpBackend http;
        Page page;
        PageComponent pageComponent;
        ShadowRoot shadowRoot;
        TestBed tb;

        setUp(() {
            // Prepare Angular for testing
            setUpInjector();

            // Make required classes available for dependency injection
            module((Module _) => _
                    ..bind(PageComponent)
                    ..bind(PageService, toImplementation: PageServiceMock)
                    ..bind(ToolController));

            // Add required templates to the cache
            addToTemplateCache('lib/components/page/page.css');
            addToTemplateCache('lib/components/page/page.html');

            // Acquire a PageComponent and TestBed instance
            inject((PageComponent _pageComponent, TestBed _tb) {
                pageComponent = _pageComponent;
                tb = _tb;
            });

            element = tb.compile('<page></page>');
            shadowRoot = element.shadowRoot;

            // Make sure Angular get time to attach the shadow root
            return new Future.delayed(Duration.ZERO, () => page = pageComponent.page);
        });

        // Tell Angular we are done
        tearDown(() {
            tearDownInjector();

            element.remove();
        });

        test('should load a page', () {
            expect(page.nodes[0].type).toEqual('line');
            expect(page.nodes[1].type).toEqual('arrow');
        });

        test('should be able to raise a node', () {
            pageComponent.raise(page.nodes[0]);

            expect(page.nodes[0].type).toEqual('arrow');
            expect(page.nodes[1].type).toEqual('line');
        });

        test('should be able to lower a node', () {
            pageComponent.lower(page.nodes[1]);

            expect(page.nodes[0].type).toEqual('arrow');
            expect(page.nodes[1].type).toEqual('line');
        });

        test('should do nothing when raising the highest node', () {
            pageComponent.raise(page.nodes[1]);

            expect(page.nodes[0].type).toEqual('line');
            expect(page.nodes[1].type).toEqual('arrow');
        });

        test('should do nothing when lowering the lowest node', () {
            pageComponent.lower(page.nodes[0]);

            expect(page.nodes[0].type).toEqual('line');
            expect(page.nodes[1].type).toEqual('arrow');
        });
    });
}
