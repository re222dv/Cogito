part of cogito;

@NgController(
    selector: '[tool-controller]',
    publishAs: 'tool')
class ToolController {
    static final ToolController _singleton = new ToolController._internal();

    String propertyPanel = 'text';
    Node selectedNode;
    String selectedTool = 'select';

    factory ToolController() {
        return _singleton;
    }

    ToolController._internal();
}
