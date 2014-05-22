part of cogito_web;

/**
 * A basic panel component that displays a panel docked to a screen edge.
 */
@Component(
    selector: 'panel',
    templateUrl: 'lib/components/panel/panel.html',
    cssUrl: 'lib/components/panel/panel.css',
    publishAs: 'cmp'
)
class PanelComponent implements ShadowRootAware {
    ToolController tool;
    UserService userService;

    @NgAttr('position')
    String position;

    List<int> lineWidths = [];
    List<int> textSizes = [];
    List<String> colors = ['transparent', 'black', 'grey', 'lightgray', 'white', 'maroon', 'red',
                           'yellow', 'green', 'lime', 'navy', 'blue', 'aqua', 'purple', 'fuchsia'];

    bool get ShowAreaProperties => tool.selectedNode is AreaProperties;
    bool get ShowLineProperties => tool.selectedNode is LineProperties;
    bool get ShowListProperties => tool.selectedNode is ListNode;
    bool get ShowTextProperties => tool.selectedNode is TextProperties;

    PanelComponent(this.tool, this.userService) {
        // Create line widths using the fibonacci scale
        var fib = () => lineWidths.add(lineWidths.last + lineWidths[lineWidths.length-2]);
        for (lineWidths = [1, 2]; lineWidths.length < 10; fib()) {}
        
        for (var i = 12; i <= 72; i+= 2) {
            textSizes.add(i);
        }
    }

    onShadowRoot(ShadowRoot shadowRoot) {
        // TODO: Listen on a better event from angular so that Timer.run isn't needed
        // Wait a tick so Angular got time to digest the shadowRoot
        Timer.run(() {
            List<Element> draggableTools = shadowRoot.querySelectorAll('[data-draggable="true"]');

            draggableTools.forEach((toolButton) {
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

    /**
     * Logout the user if there are no unsaved changed on the page.
     *
     * Workaround for [Angular route bug][]
     * [Angular route bug]: https://github.com/angular/route.dart/issues/28
     */
    void logout() {
        if (tool.page.checkUnsavedChanges() != null) {
            tool.page.leaveCallback = () => userService.logout();
        } else {
            userService.logout();
        }
    }
}
