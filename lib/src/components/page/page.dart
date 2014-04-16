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

    PageComponent(Element element, ToolController tool) {

        page = new Page();

        var hel = new Text()..color='red'..text='Hello, World!'..x=50..y=50..size='20';
        page.nodes.add(hel);
        page.nodes.add(new Text()..color='green'..text='Test'..x=160..y=160..size='50');

        page.nodes.add(new Path()..color='blue'..path='M 55 22 L 272 99'..width=20..x=50..y=50);

        page.nodes.add(new BasicList()..x=400..y=50..size='32'..rows=['Row 1', 'Row 2', 'Row 1']..color='black');
        page.nodes.add(new BasicList()..x=400..y=250..size='12'..rows=['Row 1', 'Row 2', 'Row 3']..color='green');

        page.raise(hel);
        page.raise(hel);
        page.lower(hel);
        page.raise(hel);
        page.lower(hel);
        page.lower(hel);
        page.lower(hel);

        ['touchstart', 'mousedown'].forEach((event) => element.on[event]
                                   .where((_) => tool.selectedTool == 'draw').listen((_) {
            drawing = true;

            var events = [];

            ['touchmove', 'mousemove'].forEach((event) => events.add(element.parent.on[event].listen((MouseEvent e) {
                var x = e.offset.x;
                var y = e.offset.y;
                freehand += "$x, $y ";
                e.preventDefault();
                e.stopPropagation();
            })));

            ['touchend', 'mouseup'].forEach((event) => events.add(element.parent.on[event].listen((_) {
                events.forEach((e) => e.cancel());

                if (freehand.length > 4) {
                    page.nodes.add(new Path()
                        ..color='blue'
                        ..path=simplify.simplify(freehand.trim())
                        ..width=10
                        ..x=0
                        ..y=0);
                }
                freehand = '';
            })));
        }));

    }
}
