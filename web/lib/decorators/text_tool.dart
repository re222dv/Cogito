part of cogito_web;

/**
 * Handles the text tool
 */
@Decorator(selector: '[text-tool]')
class TextToolDecorator {
    Element element;
    ToolController tool;

    var tempNode;

    TextToolDecorator(this.element, this.tool) {
        tool.onToolChange.where((tool) => tool == 'text').listen((_) {
            if (tempNode == null) {
                tempNode = new Text()
                    ..color = 'black'
                    ..size = 24;
            } else {
                tempNode = new Text()
                    ..color = tempNode.color
                    ..size = tempNode.size;
            }
            tool.selectedNode = tempNode;
        });

        element.onClick.where((_) => tool.selectedTool == 'text').listen((MouseEvent e) {
            var point = tool.page.getPoint(e);

            var node = new Text()
                ..color = tempNode.color
                ..text = ''
                ..x = point.x
                ..y = point.y - 12
                ..size = tempNode.size
                ..editing = true;

            tool.page.page.nodes.add(node);
            element.onClick.first.then((_) => node.editing = false);
            tool.onToolChange.where((newTool) => newTool != 'list')
            .first.then((_) => node.editing = false);

            tool.selectedNode = node;
            tempNode = node;

            e.stopPropagation();
            e.preventDefault();
        });
    }
}
