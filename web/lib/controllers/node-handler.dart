part of cogito_web;

@Controller(selector: '[node-handler]', publishAs: 'nodeHandler')
class NodeHandlerController {
    Element element;

    Node node;

    num get width => element.querySelector('g').getBoundingClientRect().width;
    num get height => element.querySelector('g').getBoundingClientRect().height;

    @NgOneWay('node-handler')
    void set value(Node n) {
        node = n;

        node.onEdit.where((_) => node.editing).listen((_) {
            // Wait a tick so browser have time to reflow and show the input as we can't set focus
            // on a hidden element
            Timer.run(() {
                var input = element.querySelector('input');
                if (input == null) {
                    input = element.querySelector('textarea');
                }
                if (input != null) {
                    input.focus();
                }
            });
        });

        var keyMap = [
            new KeyBinding(null, 46),   // Delete
            new KeyBinding(null, 107),  // +
            new KeyBinding(null, 109),  // -
        ];

        // Make sure keys used when typing doesn't do other stuff
        element.onKeyDown.where((e) => keyMap.any((binding) => binding == e)).listen((e) => e.stopPropagation());
    }

    NodeHandlerController(this.element, ToolController tool) {
        ['touchstart', 'mousedown'].forEach((event) => element.on[event]
                                   .where((_) => tool.selectedTool == 'select' && !node.editing)
                                   .listen((MouseEvent e) {
            tool.selectedNode = node;

            var offset = tool.page.getPoint(e);
            offset.x = node.x - offset.x;
            offset.y = node.y - offset.y;

            var events = [];

            ['touchmove', 'mousemove'].forEach((event) => events.add(element.parent.parent.on[event].listen((MouseEvent e) {
                var point = tool.page.getPoint(e);

                node.x = point.x + offset.x;
                node.y = point.y + offset.y;

                e.preventDefault();
                e.stopPropagation();
            })));

            ['touchend', 'mouseup'].forEach((event) => events.add(element.parent.parent.on[event].listen((_) {
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
