part of cogito_web;

/**
 * Handles the text tool
 */
@Decorator(selector: '[text-tool]')
class TextToolDecorator {
    Element element;
    ToolController tool;

    var tempNode = new Text()
        ..color = 'black'
        ..size = 24;

    TextToolDecorator(this.element, this.tool, Scope scope) {
        scope.watch('tool.selectedNode', (_, old) {
            if (old is Text) {
                old.editing = false;
            }
        });

        tool.onToolChange.where((tool) => tool == 'text').listen((_) {
            tempNode = new Text()
                ..color = tempNode.color
                ..size = tempNode.size;
            tool.selectedNode = tempNode;
        });

        tool.onToolDrag.where((tool) => tool == 'text').listen((_) {
            var node = new Text()
                ..color = tempNode.color
                ..text = ''
                ..size = tempNode.size
                ..editing = true;

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

            tool.selectedNode = node;
            tempNode = node;

            e.stopPropagation();
            e.preventDefault();
        });
    }
}
