part of cogito_web;

/**
 * Handles the circle tool
 */
@Decorator(selector: '[circle-tool]')
class CircleToolDecorator {
    Element element;
    ToolController tool;

    var tempNode;

    CircleToolDecorator(this.element, this.tool) {
        tool.onToolChange.where((tool) => 'circle' == tool).listen((_) {
            if (tempNode == null) {
                tempNode = new Circle()
                    ..fillColor = 'black'
                    ..strokeColor = 'red'
                    ..strokeWidth = 5;
            } else {
                tempNode = new Rect()
                    ..fillColor = tempNode.fillColor
                    ..strokeColor = tempNode.strokeColor
                    ..strokeWidth = tempNode.strokeWidth;
            }
            tool.selectedNode = tempNode;
        });

        ['touchstart', 'mousedown'].forEach((event) => element.on[event]
                .where((_) => 'circle' == tool.selectedTool).listen((MouseEvent e) {
            var circle = new Circle();

            var start = tool.page.getPoint(e);

            circle
                ..x = start.x
                ..y = start.y
                ..radius = 225
                ..fillColor = tempNode.fillColor
                ..strokeColor = tempNode.strokeColor
                ..strokeWidth = tempNode.strokeWidth;

            tool.page.page.nodes.add(circle);

            var events = [];

            ['touchmove', 'mousemove'].forEach((event) => events.add(element.on[event].listen((MouseEvent e) {
                var point = tool.page.getPoint(e);

                circle.radius = point.distanceTo(start);

                e.preventDefault();
                e.stopPropagation();
            })));

            ['touchend', 'mouseup'].forEach((event) => events.add(element.on[event].listen((_) {
                events.forEach((e) => e.cancel());

                tool.selectedNode = circle;
                tempNode = circle;
            })));
        }));
    }
}
