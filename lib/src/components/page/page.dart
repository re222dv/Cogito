part of cogito;

@NgComponent(
    selector: 'page',
    templateUrl: '../lib/src/components/page/page.html',
    cssUrl: '../lib/src/components/page/page.css',
    publishAs: 'cmp'
)
class PageComponent {
    Page page;
    String freehand = '';
    bool drawing = false;

    PageComponent(Element element) {
        page = new Page();

        page.nodes.add(new Text()..color='red'..text='Hello, World!'..x=50..y=50..size=20);
        page.nodes.add(new Text()..color='green'..text='Test'..x=160..y=160..size=50);

        page.nodes.add(new Path()..color='blue'..path='M 55 22 L 272 99'..width=20..x=50..y=50);

        element.onMouseDown.listen((_) => drawing = true);
        element.onMouseMove.where((_) => drawing).listen((MouseEvent e) {
            var x = e.offset.x;
            var y = e.offset.y;
            freehand += "$x, $y ";
            e.preventDefault();
            e.stopPropagation();
        });
        element.onMouseUp.listen((_) {
            drawing = false;
            if (freehand.length > 4) {
                page.nodes.add(new Path()
                                   ..color='blue'
                                   ..path=simplify.simplify(freehand.trim())
                                   ..width=10
                                   ..x=0
                                   ..y=0);
            }
            freehand = '';
        });
    }
}
