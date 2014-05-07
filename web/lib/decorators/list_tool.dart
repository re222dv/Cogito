part of cogito_web;

/**
 * Handles the list tool
 */
@Decorator(selector: '[text-tool]')
class ListToolDecorator {
    Element element;
    ToolController tool;

    ListToolDecorator(this.element, this.tool) {

        element.onClick.where((_) => tool.selectedTool == 'text').listen((MouseEvent e) {
            var node = new Text()
                ..color='black'
                ..text=''
                ..x=e.client.x
                ..y=e.client.y - 12
                ..size=24
                ..editing = true;

            tool.page.page.nodes.add(node);
            element.onClick.first.then((_) => node.editing = false);
            tool.onToolChange.where((newTool) => newTool != 'text')
            .first.then((_) => node.editing = false);

            tool.selectedNode = node;
            tool.propertyPanel = node.propertyPanel;

            e.stopPropagation();
            e.preventDefault();
        });
    }
}