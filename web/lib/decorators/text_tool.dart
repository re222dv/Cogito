part of cogito_web;

/**
 * Handles the text tool
 */
@Decorator(selector: '[text-tool]')
class TextToolDecorator extends TempNode {
    final String tool = 'text';

    var tempNode = new Text()
        ..color = 'black'
        ..size = 24;

    TextToolDecorator(Element element, ToolController toolCtrl) : super(toolCtrl) {

        toolCtrl.onToolDrag.where((draggedTool) => draggedTool == tool).listen((_) {
            var node = new Text()
                ..color = tempNode.color
                ..text = ''
                ..size = tempNode.size
                ..editing = true;

            toolCtrl.page.page.nodes.add(node);

            toolCtrl.selectedNode = node;
            tempNode = node;

            var events = [];

            events.add(element.onMouseMove.listen((MouseEvent e) {
                var point = toolCtrl.page.getPoint(e);

                node..x = point.x
                    ..y = point.y;
            }));

            events.add(element.onMouseUp.listen((_) {
                events.forEach((e) => e.cancel());
            }));
        });

        element.onClick.where((_) => toolCtrl.selectedTool == tool).listen((MouseEvent e) {
            if (tempNode.text.length == 0) {
                toolCtrl.page.page.nodes.remove(tempNode);
            }

            var point = toolCtrl.page.getPoint(e);

            var node = new Text()
                ..color = tempNode.color
                ..text = ''
                ..x = point.x
                ..y = point.y - 12
                ..size = tempNode.size
                ..editing = true;

            toolCtrl.page.page.nodes.add(node);

            toolCtrl.selectedNode = node;
            tempNode = node;

            e.stopPropagation();
            e.preventDefault();
        });
    }
}
