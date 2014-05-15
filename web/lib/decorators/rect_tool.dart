part of cogito_web;

/**
 * Handles the rect tool
 */
@Decorator(selector: '[rect-tool]')
class RectToolDecorator {
    Element element;
    ToolController tool;

    var tempNode;

    RectToolDecorator(this.element, this.tool) {
        tool.onToolChange.where((tool) => 'rect' == tool).listen((_) {
            if (tempNode == null) {
                tempNode = new Rect()
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
                .where((_) => 'rect' == tool.selectedTool).listen((MouseEvent e) {
            var rect = new Rect();

            var start = tool.page.getPoint(e);

            rect..x = start.x - 25
                ..y = start.y - 25
                ..width = 50
                ..height = 50
                ..fillColor = tempNode.fillColor
                ..strokeColor = tempNode.strokeColor
                ..strokeWidth = tempNode.strokeWidth;

            tool.page.page.nodes.add(rect);

            var events = [];

            ['touchmove', 'mousemove'].forEach((event) => events.add(element.on[event].listen((MouseEvent e) {
                var point = tool.page.getPoint(e);

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

                rect..x = startX
                    ..y = startY
                    ..width = width
                    ..height = height;

                e.preventDefault();
                e.stopPropagation();
            })));

            ['touchend', 'mouseup'].forEach((event) => events.add(element.on[event].listen((_) {
                events.forEach((e) => e.cancel());

                tool.selectedNode = rect;
                tempNode = rect;
            })));
        }));
    }
}
