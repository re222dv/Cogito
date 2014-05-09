part of cogito_web;

@Controller(
    selector: '[tool-controller]',
    publishAs: 'tool')
class ToolController {
    static final ToolController _singleton = new ToolController._internal();
    String propertyPanel;

    PageComponent page;

    Node _selectedNode;
    Node get selectedNode => _selectedNode;
    set selectedNode(Node node) {
        if (_selectedNode != null && _selectedNode.editable && _selectedNode.editing) {
            _selectedNode.editing = false;
        }

        if (node != null) {
            propertyPanel = node.propertyPanel;
        } else {
            propertyPanel = null;
        }

        _selectedNode = node;
    }

    String _selectedTool = 'select';
    String get selectedTool => _selectedTool;
    void set selectedTool(tool) {
        if (tool != _selectedTool) {
            _selectedTool = tool;
            _onToolChange.add(tool);

            selectedNode = null;
        }
    }

    StreamController _onToolChange = new StreamController.broadcast();
    Stream get onToolChange => _onToolChange.stream;

    StreamController toolDrag = new StreamController.broadcast();
    Stream get onToolDrag => toolDrag.stream;

    factory ToolController() {
        return _singleton;
    }

    ToolController._internal();

    save() {
        page.save();
    }

    raise() {
        page.raise(selectedNode);
    }

    lower() {
        page.lower(selectedNode);
    }

    delete() {
        page.delete(selectedNode);
        selectedNode = null;
    }
}
