part of cogito;

@NgDirective(selector: '[node-handler]')
class NodeHandlerDirective {
    Element element;

    @NgOneWay('node-handler')
    Node node;

    NodeHandlerDirective(this.element) {
        element.onMouseDown.listen((MouseEvent e) {
            var offsetX = node.x - e.offset.x;
            var offsetY = node.y - e.offset.y;

            var sub = element.parent.onMouseMove.listen((MouseEvent e) {
                node.x = e.offset.x + offsetX;
                node.y = e.offset.y + offsetY;

                e.preventDefault();
                e.stopPropagation();
            });

            element.parent.onMouseUp.first.then((_) {
                sub.cancel();
            });

            e.preventDefault();
            e.stopPropagation();
        });
    }
}
