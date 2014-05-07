part of cogito_web;

@Component(
    selector: 'page',
    templateUrl: 'lib/components/page/page.html',
    cssUrl: 'lib/components/page/page.css',
    publishAs: 'cmp'
)
class PageComponent extends ShadowRootAware {
    Element paper;

    Page page;
    PageService pages;

    final width = 1200;
    final height = 675;

    PageComponent(Element element, ToolController tool, this.pages) {
        page = new Page();

        tool.page = this;

        pages.getPage().then((page) => this.page = page);
    }

    simplify.Point getPoint(MouseEvent e) {
        var rect = paper.getBoundingClientRect();

        return new simplify.Point()
            ..x = e.client.x * width / rect.width - rect.left * width / rect.width
            ..y = e.client.y * height / rect.height - rect.top * height / rect.height;
    }

    save() => pages.savePage(page);

    onShadowRoot(ShadowRoot shadowRoot) {
        paper = shadowRoot.querySelector('rect');
    }
}
