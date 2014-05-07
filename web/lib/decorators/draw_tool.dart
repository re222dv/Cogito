part of cogito_web;

/**
 * Handles the draw tool
 */
@Decorator(selector: '[draw-tool]')
class DrawToolDecorator {
    Element element;
    ToolController tool;

    DrawToolDecorator(this.element, this.tool) {

        ['touchstart', 'mousedown'].forEach((event) => element.on[event]
                .where((_) => tool.selectedTool == 'draw').listen((_) {
            var path = new Freehand()
                ..color='black'
                ..width=8;

            tool.page.page.nodes.add(path);

            tool.selectedNode = path;

            var events = [];

            ['touchmove', 'mousemove'].forEach((event) => events.add(element.parent.on[event].listen((MouseEvent e) {
                var point = tool.page.getPoint(e);

                path.freehand += "${point.x}, ${point.y} ";
                e.preventDefault();
                e.stopPropagation();
            })));

            ['touchend', 'mouseup'].forEach((event) => events.add(element.parent.on[event].listen((_) {
                events.forEach((e) => e.cancel());

                if (path.freehand.length > 4) {
                    var simplePath = simplify.simplify(path.freehand.trim());

                    var node = new Path()
                        ..color=path.color
                        ..path=simplePath.path
                        ..width=path.width
                        ..x=simplePath.corner.x
                        ..y=simplePath.corner.y;

                    tool.page.page.nodes.add(node);
                    tool.page.page.nodes.remove(path);

                    tool.selectedNode = node;
                }
            })));
        }));
    }
}
