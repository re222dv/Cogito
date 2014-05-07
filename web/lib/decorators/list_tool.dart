part of cogito_web;

/**
 * Handles the list tool
 */
@Decorator(selector: '[list-tool]')
class ListToolDecorator {
    Element element;
    ToolController tool;

    var tempNode;

    ListToolDecorator(this.element, this.tool) {
        tool.onToolChange.where((tool) => tool == 'list').listen((_) {
            if (tempNode == null) {
                tempNode = new BasicList()
                    ..color = 'black'
                    ..size = 24
                    ..listType = 'unordered';
            } else {
                tempNode = new BasicList()
                    ..color = tempNode.color
                    ..size = tempNode.size
                    ..listType = tempNode.listType;
            }
            tool.selectedNode = tempNode;
        });

        element.onClick.where((_) => tool.selectedTool == 'list').listen((MouseEvent e) {
            var point = tool.page.getPoint(e);

            var node = new BasicList()
                ..color = tempNode.color
                ..rows = []
                ..x = point.x
                ..y = point.y - 12
                ..size = tempNode.size
                ..editing = true
                ..listType = tempNode.listType;

            tool.page.page.nodes.add(node);
            element.onClick.first.then((_) => node.editing = false);
            tool.onToolChange.where((newTool) => newTool != 'text')
            .first.then((_) => node.editing = false);

            tool.selectedNode = node;
            tempNode = node;

            e.stopPropagation();
            e.preventDefault();
        });
    }
}
