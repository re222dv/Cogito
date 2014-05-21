part of cogito_web;

@Component(
    selector: 'panel',
    templateUrl: 'lib/components/panel/panel.html',
    cssUrl: 'lib/components/panel/panel.css',
    publishAs: 'cmp'
)
class PanelComponent implements ShadowRootAware {
    ToolController tool;

    @NgAttr('position')
    String position;

    List<int> lineWidths = [];
    List<int> textSizes = [];
    List<String> colors = ['transparent', 'black', 'grey', 'lightgray', 'white', 'maroon', 'red',
                           'yellow', 'green', 'lime', 'navy', 'blue', 'aqua', 'purple', 'fuchsia'];

    bool get ShowAreaProperties => tool.selectedNode is AreaProperties;
    bool get ShowLineProperties => tool.selectedNode is LineProperties;
    bool get ShowListProperties => tool.selectedNode is BasicList;
    bool get ShowTextProperties => tool.selectedNode is TextProperties;

    PanelComponent(this.tool) {
        // Create line widths from the fibonacci scale
        for (var i = 1, first = 1, second = 1; i < 90; i = first + second, first = second, second = i) {
            lineWidths.add(i);
        }
        for (var i = 12; i <= 72; i+= 2) {
            textSizes.add(i);
        }
    }

    onShadowRoot(ShadowRoot shadowRoot) {
        // TODO: Listen on a better event from angular so that Timer.run isn't needed
        // Wait a tick so Angular got time to digest the shadowRoot
        Timer.run(() {
            List<Element> tools = shadowRoot.querySelectorAll('[data-draggable="true"]');

            tools.forEach((toolButton) {
                var dragging = false;

                toolButton.onMouseDown.listen((_) => dragging = true);
                toolButton.onMouseUp.listen((_) => dragging = false);
                toolButton.onMouseOut.where((_) => dragging).listen((_) {
                    dragging = false;

                    tool.toolDrag.add(toolButton.getAttribute('tool'));
                });
            });
        });
    }
}
