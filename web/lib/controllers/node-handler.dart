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
            new KeyBinding(null, 46),              // Delete
            new KeyBinding(null, 107),             // +
            new KeyBinding(null, 109),             // -
            new KeyBinding(null, 88, ctrl: true),  // Ctrl + X
            new KeyBinding(null, 67, ctrl: true),  // Ctrl + C
            new KeyBinding(null, 86, ctrl: true),  // Ctrl + V
        ];

        // Make sure keys used when typing doesn't do other stuff
        element.onKeyDown.where((e) => keyMap.any((binding) => binding.matches(e))).listen((e) => e.stopPropagation());
    }

    NodeHandlerController(this.element, ToolController tool, Scope scope) {
        scope.watch('node.editing', calculateSize, canChangeModel: true);
        scope.watch('node.end', calculateSize, canChangeModel: true);
        scope.watch('node.radius', calculateSize, canChangeModel: true);
        scope.watch('node.size', calculateSize, canChangeModel: true);
        scope.watch('node.strokeWidth', calculateSize, canChangeModel: true);
        scope.watch('node.text', calculateSize, canChangeModel: true);
        scope.watch('node.width', calculateSize, canChangeModel: true);

        element.onMouseDown.where((_) => tool.selectedTool == 'select' && !node.editing).listen((MouseEvent e) {

            var offset = tool.page.getPoint(e);
            offset = new math.Point(node.x - offset.x, node.y - offset.y);

            tool.page.move(node, offset);

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
        if (nodeElement == null) {
            attach();
        }

        if (nodeElement != null) {
            // Wait a tick so that Angular have time to update the view
            Timer.run(() {
                var rect = nodeElement.getBoundingClientRect();
                width = rect.width / node.scale;
                height = rect.height / node.scale;
            });
        }
    }
}
