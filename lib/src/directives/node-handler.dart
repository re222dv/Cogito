part of cogito;

@NgDirective(selector: '[node-handler]')
class NodeHandlerDirective {
    Element element;

    @NgOneWay('node-handler')
    Node node;

    NodeHandlerDirective(this.element, ToolController tool) {
        ['touchstart', 'mousedown'].forEach((event) => element.on[event]
                                   .where((_) => tool.selectedTool == 'select' && !node.editing)
                                   .listen((MouseEvent e) {
            var offsetX = node.x - e.offset.x;
            var offsetY = node.y - e.offset.y;

            var events = [];

            ['touchmove', 'mousemove'].forEach((event) => events.add(element.parent.on[event].listen((MouseEvent e) {
                node.x = e.offset.x + offsetX;
                node.y = e.offset.y + offsetY;

                e.preventDefault();
                e.stopPropagation();
            })));

            ['touchend', 'mouseup'].forEach((event) => events.add(element.parent.on[event].listen((_) {
                events.forEach((e) => e.cancel());
            })));

            e.preventDefault();
            e.stopPropagation();
        }));

        element.onClick.where((_) => tool.selectedTool == 'select').listen((_) {
            tool.selectedNode = node;
            tool.propertyPanel = node.propertyPanel;
        });

        element.onDoubleClick.where((_) => tool.selectedTool == 'select' && node.editable).listen((_) {
            node.editing = true;

            element.parent.onClick.first.then((_) => node.editing = false);
        });

        ['touchstart', 'mousedown'].forEach((event) => element.on[event].where((_) => node.editing)
                .listen((Event e) => e.stopPropagation())
        );
    }
}
