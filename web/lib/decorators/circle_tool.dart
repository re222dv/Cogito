part of cogito_web;

/**
 * Handles the circle tool
 */
@Decorator(selector: '[circle-tool]')
class CircleToolDecorator extends DrawingToolBase {
    final String tool = 'circle';

    Circle tempNode = new Circle()
        ..fillColor = 'black'
        ..strokeColor = 'red'
        ..strokeWidth = 5
        ..radius = 0;

    math.Point start;

    CircleToolDecorator(Element element, ToolController toolCtrl) : super(element, toolCtrl) {

        toolCtrl.onToolDrag.where((draggedTool) => draggedTool == tool).listen((_) {

            tempNode = tempNode.clone()
                ..x = 0
                ..y = 0;

            if (tempNode.radius < 10) {
                tempNode.radius = 10;
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
            ..radius = 0;

        toolCtrl.page.page.nodes.add(tempNode);
    }

    onMouseMove(MouseEvent e) {
        var point = toolCtrl.page.getPoint(e);

        tempNode.radius = point.distanceTo(start);
    }

    onMouseUp(MouseEvent e) {
        if (tempNode.radius == 0) {
            toolCtrl.page.page.nodes.remove(tempNode);
        }
    }
}
