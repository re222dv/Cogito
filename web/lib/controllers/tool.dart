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
        _selectedNode = node;
        if (node != null) {
            propertyPanel = node.propertyPanel;
        } else {
            propertyPanel = null;
        }
    }

    String _selectedTool = 'select';
    String get selectedTool => _selectedTool;
    void set selectedTool(tool) {
        if (tool != _selectedTool) {
            _selectedTool = tool;
            _onToolChange.add(tool);

            selectedNode = null;
            propertyPanel = null;
        }
    }

    StreamController _onToolChange = new StreamController.broadcast();
    Stream get onToolChange => _onToolChange.stream;

    factory ToolController() {
        return _singleton;
    }

    ToolController._internal();

    save() {
        page.save();
    }

    raise() {
        page.page.raise(selectedNode);
    }

    lower() {
        page.page.lower(selectedNode);
    }

    delete() {
        page.page.nodes.remove(selectedNode);
        selectedNode = null;
    }
}
