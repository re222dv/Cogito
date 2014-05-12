part of cogito_web;

/**
 * Handles a tool selection button, chooses the tool on click and adds the active css class when chosen.
 */
@Decorator(selector: '[tool]', map: const {'tool': '@toolType'})
class ToolDecorator {
    Element element;
    ToolController tool;

    String _toolType;

    set toolType(String toolType) {
        _toolType = toolType;

        if (toolType == tool.selectedTool) {
            element.classes.add('active');
        }
    }

    ToolDecorator(this.element, this.tool, Scope scope) {
        tool.onToolChange.listen((newTool) {
            if (newTool == _toolType) {
                element.classes.add('active');
            } else {
                element.classes.remove('active');
            }
        });

        element.onClick.listen((_) => tool.selectedTool = _toolType);
    }
}
