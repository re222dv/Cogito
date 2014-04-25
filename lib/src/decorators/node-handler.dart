part of cogito;

@Decorator(selector: '[node-handler]')
class NodeHandlerDecorator {
    Element element;

    Node node;

    @NgOneWay('node-handler')
    void set value(Node n) {
        node = n;

        node.onEdit.where((_) => node.editing).listen((_) {
            // Future used so browser have time to reflow and show the input as we can't set focus
            // on a hidden element
            new Future.delayed(new Duration(microseconds: 1)).then((_) {
                element.querySelector('input').focus();
            });
        });
    }

    NodeHandlerDecorator(this.element, ToolController tool) {
        ['touchstart', 'mousedown'].forEach((event) => element.on[event]
                                   .where((_) => tool.selectedTool == 'select' && !node.editing)
                                   .listen((MouseEvent e) {
            tool.selectedNode = node;
            tool.propertyPanel = node.propertyPanel;

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

        element.onDoubleClick.where((_) => tool.selectedTool == 'select' && node.editable).listen((_) {
            node.editing = true;

            element.parent.onClick.first.then((_) => node.editing = false);
        });

        ['touchstart', 'mousedown', 'click'].forEach((event) => element.on[event].where((_) => node.editing)
                .listen((Event e) => e.stopPropagation())
        );
    }
}
