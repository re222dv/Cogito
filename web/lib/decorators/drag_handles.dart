part of cogito_web;

/**
 * Handles the drag handles for resizing nodes
 */
@Decorator(selector: '[drag-handles]')
class DragHandlesDecorator {
    Element element;
    ToolController tool;
    Node node;

    DragHandlesDecorator(this.element, this.tool, Scope scope) {
        node = scope.context['node'];

        ['ne', 'nw', 'se', 'sw'].forEach((corner) {
            var handle = element.querySelector('.$corner');

            handle.onMouseDown.listen((MouseEvent e) {
                var start = new math.Point(node.x, node.y);
                var offset = tool.page.getPoint(e);

                var initialScale = node.scale;

                var events = [];

                events.add(element.parent.parent.onMouseMove.listen((MouseEvent e) {
                    var point = tool.page.getPoint(e);

                    node.scale = start.distanceTo(point) / start.distanceTo(offset) * initialScale;

                    e.preventDefault();
                    e.stopPropagation();
                }));

                events.add(element.parent.parent.onMouseUp.listen((_) {
                    events.forEach((e) => e.cancel());
                }));

                e.preventDefault();
                e.stopPropagation();
            });

            handle.onClick.listen((e) => e.stopPropagation());
        });
    }
}
