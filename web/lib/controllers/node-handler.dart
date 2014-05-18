part of cogito_web;

@Controller(selector: '[node-handler]', publishAs: 'nodeHandler')
class NodeHandlerController extends AttachAware {
    Element element;
    Element nodeElement;

    Node node;

    num width = 0;
    num height = 0;

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

    NodeHandlerController(this.element, ToolController tool, Scope scope) {
        scope.watch('node.size', calculateSize);
        scope.watch('node.width', calculateSize);
        scope.watch('node.text', calculateSize);

        element.onMouseDown.where((_) => tool.selectedTool == 'select' && !node.editing).listen((MouseEvent e) {
            tool.selectedNode = node;

            var offset = tool.page.getPoint(e);
            offset = new math.Point(node.x - offset.x, node.y - offset.y);

            element.parent.classes.add('dragging');

            var events = [];

            events.add(element.parent.parent.onMouseMove.listen((MouseEvent e) {
                var point = tool.page.getPoint(e);

                node.x = point.x + offset.x;
                node.y = point.y + offset.y;

                e.preventDefault();
                e.stopPropagation();
            }));

            events.add(element.parent.parent.onMouseUp.listen((Event e) {
                events.forEach((e) => e.cancel());

                element.parent.classes.remove('dragging');

                e.preventDefault();
                e.stopPropagation();
            }));

            e.preventDefault();
            e.stopPropagation();
        });

        element.onDoubleClick.where((_) => tool.selectedTool == 'select' && node.editable).listen((_) {
            node.editing = true;

            element.parent.onClick.first.then((_) => node.editing = false);
        });

        ['mousedown', 'click'].forEach((event) => element.on[event].listen((Event e) => e.stopPropagation()));
    }

    attach() {
        nodeElement = element.querySelector('g');
    }

    /**
     * Calculates the size of the node
     */
    calculateSize(_, __) {
        // Wait a tick so that Angular have time to update the view
        Timer.run(() {
            var rect = nodeElement.getBoundingClientRect();
            width = rect.width;
            height = rect.height;
        });
    }
}
