library page_tests;

import 'dart:async';
import 'dart:html' hide Path, Text;
import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';
import 'package:unittest/unittest.dart' hide expect;
import 'package:guinness/guinness_html.dart';
import '../../helpers.dart';
import 'package:cogito/cogito.dart';
import '../../../web/lib/cogito.dart';

var injectedPage;
var savePageSpy;

class PageServiceMock implements PageService {

    bool haveLocal = false;

    PageServiceMock() {
        savePageSpy = guinness.createSpy('savePageSpy');
    }

    Future<Page> getPage() => new Future.sync(() {
        injectedPage = new Page()
            ..nodes = [
                (
                    new Line()
                        ..x = 10
                        ..y = 20
                        ..color = 'green'
                        ..start = (new Point(0, 0))
                        ..end = (new Point(200, 200))
                        ..width = 10
                ),
                (
                    new Arrow()
                        ..x = 30
                        ..y = 40
                        ..color = 'green'
                        ..start = (new Point(0, 0))
                        ..end = (new Point(200, 200))
                        ..width = 10
                ),
                (
                    new Path()
                        ..x = 50
                        ..y = 60
                        ..color = 'green'
                        ..path = 'M 0 0 L 10 10'
                        ..width = 10
                ),
                (
                    new Text()
                        ..x = 70
                        ..y = 80
                        ..color = 'green'
                        ..text = 'FooBar'
                        ..size = 10
                ),
                (
                    new BasicList()
                        ..x = 90
                        ..y = 100
                        ..color = 'green'
                        ..rows = ['Foo', 'Bar']
                        ..size = 10
                )
            ];
        return injectedPage;
    });

    savePage(page) => savePageSpy(page);
}

main() {
    guinnessEnableHtmlMatchers();

    describe('PageComponent', () {
        Element element;
        MockHttpBackend http;
        Page page;
        PageComponent pageComponent;
        ShadowRoot shadowRoot;
        ToolController tool;
        TestBed tb;

        beforeEach(() {
            // Prepare Angular for testing
            setUpInjector();

            // Make required classes available for dependency injection
            module((Module _) => _
                    ..bind(PageComponent)
                    ..bind(PageService, toImplementation: PageServiceMock)
                    ..bind(RemoveLeadingFormatter)
                    ..bind(ToolController)
                    ..bind(TestBed));

            // Add required templates to the cache
            addToTemplateCache('lib/components/page/page.css');
            addToTemplateCache('lib/components/page/page.html');

            // Acquire a PageComponent, ToolController and TestBed instance
            inject((PageComponent _pageComponent, ToolController _tool, TestBed _tb) {
                pageComponent = _pageComponent;
                tool = _tool;
                tb = _tb;
            });

            element = tb.compile('<page></page>');
            tb.rootScope.apply();
            shadowRoot = element.shadowRoot;
            pageComponent.shadowRoot = shadowRoot;

            // Make sure Angular get time to attach the shadow root
            return new Future.delayed(Duration.ZERO, () {
                page = pageComponent.page;
                tool.selectedNode = page.nodes[0];
                tb.getScope(shadowRoot.querySelector('svg')).apply();
            });
        });

        // Tell Angular we are done
        afterEach(tearDownInjector);

        it('should load a page', () {
            expect(page).toBeNotNull();
        });

        it('should provide a top panel', () {
            expect(shadowRoot.querySelector('panel[position="top"]')).toBeNotNull();
        });

        it('should provide a left panel', () {
            expect(shadowRoot.querySelector('panel[position="left"]')).toBeNotNull();
        });

        it('should provide a right panel', () {
            expect(shadowRoot.querySelector('panel[position="right"]')).toBeNotNull();
        });

        it('should mixin keyboard-listener', () {
            expect(shadowRoot.querySelector('div[keyboard-listener]')).toBeNotNull();
        });

        it('should mixin draw-tool', () {
            expect(shadowRoot.querySelector('svg[draw-tool]')).toBeNotNull();
        });

        it('should mixin line-tool', () {
            expect(shadowRoot.querySelector('svg[line-tool]')).toBeNotNull();
        });

        it('should mixin arrow-tool', () {
            expect(shadowRoot.querySelector('svg[line-tool]')).toBeNotNull();
        });

        it('should mixin list-tool', () {
            expect(shadowRoot.querySelector('svg[list-tool]')).toBeNotNull();
        });

        it('should mixin text-tool', () {
            expect(shadowRoot.querySelector('svg[text-tool]')).toBeNotNull();
        });

        it('should mixin rect-tool', () {
            expect(shadowRoot.querySelector('svg[list-tool]')).toBeNotNull();
        });

        it('should mixin circle-tool', () {
            expect(shadowRoot.querySelector('svg[text-tool]')).toBeNotNull();
        });

        it('should have a white paper', () {
            expect(shadowRoot.querySelector('svg>rect[height="100%"][width="100%"][fill="white"]')).toBeNotNull();
        });

        it('should draw all nodes', () {
            expect(shadowRoot.querySelectorAll('svg>g').length).toBe(5);

            page.nodes.forEach(expectAsync((node) {
                var selector = 'svg>g[transform="translate(${node.x},${node.y}) scale(${node.scale})"]';
                expect(shadowRoot.querySelector(selector)).toBeNotNull();
            }, count: 5));
        });

        it('should be able to raise a node', () {
            pageComponent.raise(page.nodes[0]);

            expect(page.nodes[0].type).toEqual('arrow');
            expect(page.nodes[1].type).toEqual('line');
            expect(page.nodes[2].type).toEqual('path');
            expect(page.nodes[3].type).toEqual('text');
            expect(page.nodes[4].type).toEqual('basicList');
        });

        it('should be able to lower a node', () {
            pageComponent.lower(page.nodes[1]);

            expect(page.nodes[0].type).toEqual('arrow');
            expect(page.nodes[1].type).toEqual('line');
            expect(page.nodes[2].type).toEqual('path');
            expect(page.nodes[3].type).toEqual('text');
            expect(page.nodes[4].type).toEqual('basicList');
        });

        it('should do nothing when raising the highest node', () {
            pageComponent.raise(page.nodes[4]);

            expect(page.nodes[0].type).toEqual('line');
            expect(page.nodes[1].type).toEqual('arrow');
            expect(page.nodes[2].type).toEqual('path');
            expect(page.nodes[3].type).toEqual('text');
            expect(page.nodes[4].type).toEqual('basicList');
        });

        it('should do nothing when lowering the lowest node', () {
            pageComponent.lower(page.nodes[0]);

            expect(page.nodes[0].type).toEqual('line');
            expect(page.nodes[1].type).toEqual('arrow');
            expect(page.nodes[2].type).toEqual('path');
            expect(page.nodes[3].type).toEqual('text');
            expect(page.nodes[4].type).toEqual('basicList');
        });

        it('should save the current page on save', () {
            pageComponent.save();

            expect(savePageSpy).toHaveBeenCalledOnceWith(page);
        });

        it('should delete a node on delete', () {
            pageComponent.delete(page.nodes[0]);

            expect(page.nodes.length).toBe(4);
        });

        it('should deselect a node on click', () {
            tool.selectedNode = new Line();
            tool.selectedTool = 'select';

            tb.triggerEvent(element, 'mousedown');

            expect(tool.selectedNode).toBeNull();
        });
    });
}
