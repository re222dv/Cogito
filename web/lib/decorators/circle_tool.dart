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

    CircleToolDecorator(Element element, ToolController toolCtrl) : super(element, toolCtrl);

    onMouseDown(MouseEvent e) {
        start = toolCtrl.page.getPoint(e);

        tempNode = tempNode.clone()
            ..x = start.x
            ..y = start.y;

        toolCtrl.page.page.nodes.add(tempNode);
    }

    onMouseMove(MouseEvent e) {
        var point = toolCtrl.page.getPoint(e);

        tempNode.radius = point.distanceTo(start);
    }

    onMouseUp(MouseEvent e) {}
}
