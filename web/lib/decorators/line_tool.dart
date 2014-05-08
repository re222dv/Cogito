part of cogito_web;

/**
 * Handles the line and arrow tool
 */
@Decorator(selector: '[line-tool]')
class LineToolDecorator {
    Element element;
    ToolController tool;

    var tempNode;

    LineToolDecorator(this.element, this.tool) {
        tool.onToolChange.where((tool) => ['line', 'arrow'].contains(tool)).listen((_) {
            if (tempNode == null) {
                tempNode = new Line()
                    ..color = 'black'
                    ..width = 5;
            } else {
                tempNode = new Line()
                    ..color = tempNode.color
                    ..width = tempNode.width;
            }
            tool.selectedNode = tempNode;
        });

        ['touchstart', 'mousedown'].forEach((event) => element.on[event]
                .where((_) => ['line', 'arrow'].contains(tool.selectedTool)).listen((MouseEvent e) {
            var line;

            if (tool.selectedTool == 'line') {
                line = new Line();
            } else {
                line = new Arrow();
            }

            var point = tool.page.getPoint(e);

            line..color = tempNode.color
                ..width = tempNode.width
                ..start = point
                ..end = point;

            tool.page.page.nodes.add(line);

            var events = [];

            ['touchmove', 'mousemove'].forEach((event) => events.add(element.on[event].listen((MouseEvent e) {
                var point = tool.page.getPoint(e);

                line.end = point;
                e.preventDefault();
                e.stopPropagation();
            })));

            ['touchend', 'mouseup'].forEach((event) => events.add(element.on[event].listen((_) {
                events.forEach((e) => e.cancel());

                if (line.end != line.start) {
                    var unpaddedPoints = simplify.removePadding([line.start, line.end]);

                    line..start = unpaddedPoints.points[0]
                        ..end = unpaddedPoints.points[1]
                        ..x = unpaddedPoints.corner.x
                        ..y = unpaddedPoints.corner.y;

                    tool.selectedNode = line;
                    tempNode = line;
                } else {
                    tool.page.page.nodes.remove(line);
                }
            })));
        }));
    }
}
