part of cogito_web;

/**
 * Handles the text tool
 */
@Decorator(selector: '[text-tool]')
class TextToolDecorator {
    Element element;
    ToolController tool;

    TextToolDecorator(this.element, this.tool) {

        element.onClick.where((_) => tool.selectedTool == 'list').listen((MouseEvent e) {
            var node = new BasicList()
                ..color='black'
                ..text=''
                ..x=e.client.x
                ..y=e.client.y - 12
                ..size=24
                ..editing = true;

            tool.page.page.nodes.add(node);
            element.onClick.first.then((_) => node.editing = false);
            tool.onToolChange.where((newTool) => newTool != 'list')
            .first.then((_) => node.editing = false);

            tool.selectedNode = node;

            e.stopPropagation();
            e.preventDefault();
        });
    }
}
