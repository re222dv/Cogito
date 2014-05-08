part of cogito_web;

@Component(
    selector: 'page',
    templateUrl: 'lib/components/page/page.html',
    cssUrl: 'lib/components/page/page.css',
    publishAs: 'cmp'
)
class PageComponent extends ShadowRootAware {
    Element paper;

    Page page = new Page();
    PageService pages;

    final width = 1200;
    final height = 675;

    PageComponent(Element element, ToolController tool, this.pages) {
        tool.page = this;

        // Get the current page
        pages.getPage().then((_page) => page = _page);

        // Deselect the node when the page is clicked
        element.onClick.where((_) => tool.selectedTool == 'select').listen((_) => tool.selectedNode = null);
    }

    math.Point getPoint(MouseEvent e) {
        var rect = paper.getBoundingClientRect();

        return new math.Point(e.client.x * width / rect.width - rect.left * width / rect.width,
                              e.client.y * height / rect.height - rect.top * height / rect.height);
    }

    save() => pages.savePage(page);

    onShadowRoot(ShadowRoot shadowRoot) {
        paper = shadowRoot.querySelector('rect');
    }
}
