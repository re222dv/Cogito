part of cogito_web;

@Controller(
    selector: '[tool-controller]',
    publishAs: 'tool')
class ToolController {
    static final ToolController _singleton = new ToolController._internal();

    Node _selectedNode;
    String _selectedTool = 'select';

    PageComponent page;

    StreamController _onToolChange = new StreamController.broadcast();
    StreamController toolDrag = new StreamController.broadcast();

    Node get selectedNode => _selectedNode;
    set selectedNode(Node node) {
        if (node == _selectedNode) {
            return;
        }

        if (_selectedNode != null && _selectedNode.editable && _selectedNode.editing) {
            _selectedNode.editing = false;
        }

        _selectedNode = node;
    }

    String get selectedTool => _selectedTool;
    void set selectedTool(tool) {
        if (tool != _selectedTool) {
            _selectedTool = tool;
            _onToolChange.add(tool);

            selectedNode = null;
        }
    }

    ///Fired when the tool is changed
    Stream get onToolChange => _onToolChange.stream;

    /// Fired when a draggable tool is dragged
    Stream get onToolDrag => toolDrag.stream;

    factory ToolController() {
        return _singleton;
    }

    ToolController._internal();

    /**
     * Saves the current page to the server.
     */
    save() {
        page.save();
    }

    /**
     * Moves the selected node one step closer to the user.
     */
    raise() {
        page.raise(selectedNode);
    }

    /**
     * Moves the selected node one step away from the user.
     */
    lower() {
        page.lower(selectedNode);
    }

    /**
     * Deletes the selected node.
     */
    delete() {
        page.delete(selectedNode);
        selectedNode = null;
    }

    static ToolController newInstance([_]) => new ToolController._internal();
}
