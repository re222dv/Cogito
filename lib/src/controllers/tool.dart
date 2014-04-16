part of cogito;

@NgController(
    selector: '[tool-controller]',
    publishAs: 'tool')
class ToolController {
    static final ToolController _singleton = new ToolController._internal();
    Node selectedNode;
    String selectedTool = 'select';

    String propertyPanel;

    factory ToolController() {
        return _singleton;
    }

    ToolController._internal();
}
