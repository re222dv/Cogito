part of cogito_web;

/**
 * Handles the list tool
 */
@Decorator(selector: '[list-tool]')
class ListToolDecorator {
    Element element;
    ToolController tool;

    var tempNode = new BasicList()
        ..color = 'black'
        ..size = 24
        ..listType = 'unordered';

    ListToolDecorator(this.element, this.tool, Scope scope) {
        tool.onToolChange.where((tool) => tool == 'list').listen((_) {
            tempNode = new BasicList()
                ..color = tempNode.color
                ..size = tempNode.size
                ..listType = tempNode.listType;
            tool.selectedNode = tempNode;
        });

        tool.onToolDrag.where((tool) => tool == 'list').listen((_) {
            var node = new BasicList()
                ..color = tempNode.color
                ..rows = []
                ..size = tempNode.size
                ..editing = true
                ..listType = tempNode.listType;

            tool.page.page.nodes.add(node);

            tool.selectedNode = node;
            tempNode = node;

            var events = [];

            events.add(element.onMouseMove.listen((MouseEvent e) {
                var point = tool.page.getPoint(e);

                node..x = point.x
                    ..y = point.y;
            }));

            events.add(element.onMouseUp.listen((_) {
                events.forEach((e) => e.cancel());
            }));
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

            tool.selectedNode = node;
            tempNode = node;

            e.stopPropagation();
            e.preventDefault();
        });
    }
}
