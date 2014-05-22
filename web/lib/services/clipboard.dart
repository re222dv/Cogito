part of cogito_web;

/**
 * Handles copying, cutting and pasting
 */
@Injectable()
class ClipboardService {
    ToolController tool;

    Node clipboard;

    ClipboardService(this.tool);

    /**
     * Copies the currently selected node to the clipboard.
     */
    void copy() => clipboard = tool.selectedNode.clone();

    /**
     * Cuts the currently selected node to the clipboard.
     */
    void cut() {
        clipboard = tool.selectedNode.clone();
        tool.delete();
    }

    /**
     * Pastes the node currently in the clipboard.
     */
    void paste() {
        tool.page.page.nodes.add(clipboard);
        tool.selectedNode = clipboard;

        clipboard = clipboard.clone();

        tool.page.move(tool.selectedNode, new math.Point(0, 0));
    }
}
