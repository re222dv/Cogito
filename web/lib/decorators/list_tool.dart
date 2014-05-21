part of cogito_web;

/**
 * Handles the list tool
 */
@Decorator(selector: '[list-tool]')
class ListToolDecorator extends TempNode {
    final String tool = 'list';

    var tempNode = new ListNode()
        ..color = 'black'
        ..size = 24
        ..listType = 'unordered';

    ListToolDecorator(Element element, ToolController toolCtrl) : super(toolCtrl) {

        toolCtrl.onToolDrag.where((draggedTool) => draggedTool == tool).listen((_) {
            var node = new ListNode()
                ..color = tempNode.color
                ..rows = []
                ..size = tempNode.size
                ..editing = true
                ..listType = tempNode.listType;

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

            var node = new ListNode()
                ..color = tempNode.color
                ..rows = []
                ..x = point.x
                ..y = point.y - 12
                ..size = tempNode.size
                ..editing = true
                ..listType = tempNode.listType;

            toolCtrl.page.page.nodes.add(node);

            toolCtrl.selectedNode = node;
            tempNode = node;

            e.stopPropagation();
            e.preventDefault();
        });
    }
}
