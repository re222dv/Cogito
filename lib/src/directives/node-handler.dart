part of cogito;

@NgDirective(selector: '[node-handler]')
class NodeHandlerDirective {
    Element element;

    @NgOneWay('node-handler')
    Node node;

    bool moving = false;
    int offsetX;
    int offsetY;

    NodeHandlerDirective(this.element) {
        element.onMouseDown.listen((MouseEvent e) {
            offsetX = node.x - e.offset.x;
            offsetY = node.y - e.offset.y;
            moving = true;
            e.preventDefault();
            e.stopPropagation();
        });
        element.onMouseMove.where((_) => moving).listen((MouseEvent e) {
            node.x = e.offset.x + offsetX;
            node.y = e.offset.y + offsetY;
            e.preventDefault();
            e.stopPropagation();
        });
        element.onMouseUp.listen((_) => moving = false);
    }
}
