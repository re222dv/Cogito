part of cogito_web;

/**
 * Handles the list tool
 */
@Decorator(selector: '[text-tool]')
class ListToolDecorator {
    Element element;
    ToolController tool;

    ListToolDecorator(this.element, this.tool) {

        element.onClick.where((_) => tool.selectedTool == 'text').listen((MouseEvent e) {
            var point = tool.page.getPoint(e);

            var node = new Text()
                ..color = 'black'
                ..text = ''
                ..x = point.x
                ..y = point.y - 12
                ..size = 24
                ..editing = true;

            tool.page.page.nodes.add(node);
            element.onClick.first.then((_) => node.editing = false);
            tool.onToolChange.where((newTool) => newTool != 'text')
            .first.then((_) => node.editing = false);

            tool.selectedNode = node;

            e.stopPropagation();
            e.preventDefault();
        });
    }
}
