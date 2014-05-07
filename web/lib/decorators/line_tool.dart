part of cogito_web;

/**
 * Handles the line and arrow tool
 */
@Decorator(selector: '[line-tool]')
class LineToolDecorator {
    Element element;
    ToolController tool;

    LineToolDecorator(this.element, this.tool) {

        ['touchstart', 'mousedown'].forEach((event) => element.on[event]
                .where((_) => ['line', 'arrow'].contains(tool.selectedTool)).listen((MouseEvent e) {
            var line;

            if (tool.selectedTool == 'line') {
                line = new Line();
            } else {
                line = new Arrow();
            }

            line..color = 'black'
                ..width = 8
                ..start = (new simplify.Point()
                ..x = e.offset.x
                ..y = e.offset.y)
                ..end = (new simplify.Point()
                ..x = e.offset.x
                ..y = e.offset.y);

            tool.page.page.nodes.add(line);

            tool.selectedNode = line;

            var events = [];

            ['touchmove', 'mousemove'].forEach((event) => events.add(element.on[event].listen((MouseEvent e) {
                line.end = new simplify.Point()
                    ..x = e.offset.x
                    ..y = e.offset.y;
                e.preventDefault();
                e.stopPropagation();
            })));

            ['touchend', 'mouseup'].forEach((event) => events.add(element.on[event].listen((_) {
                events.forEach((e) => e.cancel());

                if (line.end != null) {
                    var points = [line.start, line.end];
                    var corner = simplify.removePadding(points);

                    line..start = (new simplify.Point()
                        ..x = points[0].x
                        ..y = points[0].y)
                        ..end = (new simplify.Point()
                        ..x = points[1].x
                        ..y = points[1].y)
                        ..x = corner.x
                        ..y = corner.y;

                    tool.selectedNode = line;
                } else {
                    tool.page.page.nodes.remove(line);
                }
            })));
        }));
    }
}
