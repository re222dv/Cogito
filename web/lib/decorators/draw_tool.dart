part of cogito_web;

/**
 * Handles the draw tool
 */
@Decorator(selector: '[draw-tool]')
class DrawToolDecorator extends DrawingToolBase {
    final String tool = 'draw';

    PathNode tempNode = new PathNode()
        ..color = 'black'
        ..width = 5;

    Freehand tempPath;

    DrawToolDecorator(Element element, ToolController toolCtrl) : super (element, toolCtrl);

    onMouseDown(MouseEvent e) {
        var point = toolCtrl.page.getPoint(e);

        tempPath = new Freehand()
            ..color = tempNode.color
            ..width = tempNode.width
            ..freehand = "${point.x}, ${point.y} ";

        toolCtrl.page.page.nodes.add(tempPath);
    }

    onMouseMove(MouseEvent e) {
        var point = toolCtrl.page.getPoint(e);

        tempPath.freehand += "${point.x}, ${point.y} ";
    }

    onMouseUp(MouseEvent e) {
        if (tempPath.freehand.split(', ').length > 2) {
            var simplePath = simplify.simplify(tempPath.freehand.trim());

            var node = new PathNode()
                ..color = tempPath.color
                ..path = simplePath.path
                ..width = tempPath.width
                ..x = simplePath.corner.x
                ..y = simplePath.corner.y;

            toolCtrl.page.page.nodes.add(node);
            toolCtrl.page.page.nodes.remove(tempPath);

            tempNode = node;
        } else {
            toolCtrl.page.page.nodes.remove(tempPath);
        }
    }
}
