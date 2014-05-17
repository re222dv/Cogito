part of cogito_web;

@Component(
    selector: 'page',
    templateUrl: 'lib/components/page/page.html',
    cssUrl: 'lib/components/page/page.css',
    publishAs: 'cmp'
)
class PageComponent extends ShadowRootAware {
    Element paper;
    Element svg;

    Page page = new Page();
    PageService pages;

    final width = 1200;
    final height = 675;

    PageComponent(Element element, ToolController tool, this.pages) {
        tool.page = this;

        // Get the current page
        pages.getPage().then((_page) => page = _page);

        // Deselect the node when the page is clicked
        element.onMouseDown.where((_) => tool.selectedTool == 'select')
                           .listen((Event e) {
                                tool.selectedNode = null;

                                e.preventDefault();
                                e.stopPropagation();
                            });
    }

    /**
     * Get the point of the [MouseEvent] scaled and moved appropriately to reflect the scaling of the paper
     */
    math.Point getPoint(MouseEvent e) {
        var rect = paper.getBoundingClientRect();

        return new math.Point(e.client.x * width / rect.width - rect.left * width / rect.width,
                              e.client.y * height / rect.height - rect.top * height / rect.height);
    }

    /**
     * Move a node one step closer to the user
     */
    void raise(Node node) {
        var i = page.nodes.indexOf(node);

        if (i < page.nodes.length - 1 && i >= 0) {
            var first = page.nodes.removeAt(i);
            var second = page.nodes.removeAt(i);
            page.nodes.insert(i, first);
            page.nodes.insert(i, second);
        }
    }

    /**
     * Move a node one step away from the user
     */
    void lower(Node node) {
        var i = page.nodes.indexOf(node) - 1;

        if (i >= 0) {
            var first = page.nodes.removeAt(i);
            var second = page.nodes.removeAt(i);
            page.nodes.insert(i, first);
            page.nodes.insert(i, second);
        }
    }

    /**
     * Deletes a node
     */
    void delete(Node node) {
        page.nodes.remove(node);
    }

    /**
     * Save the page to the server
     */
    save() => pages.savePage(page);

    onShadowRoot(ShadowRoot shadowRoot) {
        paper = shadowRoot.querySelector('rect');
        svg = shadowRoot.querySelector('svg');
    }
}
