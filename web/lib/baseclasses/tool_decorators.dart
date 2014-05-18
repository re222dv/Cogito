part of cogito_web;

/**
 * A mixin for all tool decorators that uses a temp node to allow setting properties
 * before drawing.
 */
abstract class TempNode {
    Node tempNode;
    String get tool;
    ToolController toolCtrl;

    TempNode(this.toolCtrl) {
        toolCtrl.onToolChange.where((newTool) => newTool == tool).listen((_) {
            tempNode = tempNode.clone();
            toolCtrl.selectedNode = tempNode;
        });
    }
}

/**
 * A base class for tool decorators that does drawing and therefore needs [onMouseDown],
 * [onMouseMove] and [onMouseUp] events.
 */
abstract class DrawingToolBase extends TempNode {

    DrawingToolBase(Element element, ToolController toolCtrl) : super(toolCtrl) {

        element.onMouseDown.where((_) => toolCtrl.selectedTool == tool).listen((MouseEvent e) {
            onMouseDown(e);

            var events = [];

            events.add(element.parent.onMouseMove.listen((MouseEvent e) {
                onMouseMove(e);

                e.preventDefault();
                e.stopPropagation();
            }));

            events.add(element.parent.onMouseUp.listen((_) {
                events.forEach((e) => e.cancel());

                onMouseUp(e);

                toolCtrl.selectedNode = tempNode;

                e.preventDefault();
                e.stopPropagation();
            }));
        });
    }

    onMouseDown(MouseEvent e);
    onMouseMove(MouseEvent e);
    onMouseUp(MouseEvent e);
}
