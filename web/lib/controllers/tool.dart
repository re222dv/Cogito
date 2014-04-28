part of cogito_web;

@Controller(
    selector: '[tool-controller]',
    publishAs: 'tool')
class ToolController {
    static final ToolController _singleton = new ToolController._internal();
    Node selectedNode;
    String propertyPanel;

    String _selectedTool = 'select';
    String get selectedTool => _selectedTool;
    void set selectedTool(t) {
        _selectedTool = t;
        _onToolChange.add(t);

        selectedNode = null;
        propertyPanel = null;
    }

    StreamController _onToolChange = new StreamController.broadcast();
    Stream get onToolChange => _onToolChange.stream;

    factory ToolController() {
        return _singleton;
    }

    ToolController._internal();
}
