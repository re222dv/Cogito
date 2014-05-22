part of cogito_web;

/**
 * Handles the rect tool
 */
@Decorator(selector: '[rect-tool]')
class RectToolDecorator extends DrawingToolBase {
    final String tool = 'rect';

    RectNode tempNode = new RectNode()
        ..fillColor = 'black'
        ..strokeColor = 'red'
        ..strokeWidth = 5
        ..width = 0
        ..height = 0;

    math.Point start;

    RectToolDecorator(Element element, ToolController toolCtrl) : super(element, toolCtrl) {

        toolCtrl.onToolDrag.where((draggedTool) => draggedTool == tool).listen((_) {

            tempNode = tempNode.clone()
                ..x = 0
                ..y = 0;

            if (tempNode.width < 20) {
                tempNode.width = 20;
            }

            if (tempNode.height < 20) {
                tempNode.height = 20;
            }

            toolCtrl.page.page.nodes.add(tempNode);

            toolCtrl.selectedNode = tempNode;

            var events = [];

            events.add(element.onMouseMove.listen((MouseEvent e) {
                var point = toolCtrl.page.getPoint(e);

                tempNode..x = point.x
                        ..y = point.y;
            }));

            events.add(element.onMouseUp.listen((_) {
                events.forEach((e) => e.cancel());
            }));
        });
    }

    onMouseDown(MouseEvent e) {
        start = toolCtrl.page.getPoint(e);

        tempNode = tempNode.clone()
            ..x = start.x
            ..y = start.y
            ..width = 0
            ..height = 0;

        toolCtrl.page.page.nodes.add(tempNode);
    }

    onMouseMove(MouseEvent e) {
        var point = toolCtrl.page.getPoint(e);

        var startX, startY, width, height;
        if (point.x > start.x) {
            startX = start.x;
            width = point.x - start.x;
        } else {
            startX = point.x;
            width = start.x - point.x;
        }
        if (point.y > start.y) {
            startY = start.y;
            height = point.y - start.y;
        } else {
            startY = point.y;
            height = start.y - point.y;
        }

        tempNode..x = startX
                ..y = startY
                ..width = width
                ..height = height;
    }

    onMouseUp(MouseEvent e) {
        if (tempNode.width == 0 || tempNode.height == 0) {
            toolCtrl.page.page.nodes.remove(tempNode);
        }
    }
}
