part of cogito_web;

/**
 * Handles the line tool
 */
@Decorator(selector: '[line-tool]')
class LineToolDecorator extends DrawingToolBase {
    final String tool = 'line';

    LineNode tempNode = new LineNode()
        ..color = 'black'
        ..width = 5
        ..start = new math.Point(0 ,0)
        ..end = new math.Point(0 ,0);

    LineToolDecorator(Element element, ToolController toolCtrl) : super (element, toolCtrl);

    onMouseDown(MouseEvent e) {
        var point = toolCtrl.page.getPoint(e);

        tempNode = tempNode.clone()
            ..x = 0
            ..y = 0
            ..start = point
            ..end = point;

        toolCtrl.page.page.nodes.add(tempNode);
    }

    onMouseMove(MouseEvent e) {
        var point = toolCtrl.page.getPoint(e);

        tempNode.end = point;
    }

    onMouseUp(MouseEvent e) {
        if (tempNode.end != tempNode.start) {
            var unpaddedPoints = simplify.removePadding([tempNode.start, tempNode.end]);

            tempNode..start = unpaddedPoints.points[0]
                    ..end = unpaddedPoints.points[1]
                    ..x = unpaddedPoints.corner.x
                    ..y = unpaddedPoints.corner.y;
        } else {
            toolCtrl.page.page.nodes.remove(tempNode);
        }
    }
}
