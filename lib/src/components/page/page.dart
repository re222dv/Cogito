part of cogito;

@Component(
    selector: 'page',
    templateUrl: 'lib/src/components/page/page.html',
    cssUrl: 'lib/src/components/page/page.css',
    publishAs: 'cmp'
)
class PageComponent {
    Page page;

    PageComponent(Element element, ToolController tool) {

        page = new Page();

        var hel = new Text()..color='red'..text='Hello, World!'..x=50..y=50..size='20';
        page.nodes.add(hel);
        page.nodes.add(new Text()..color='green'..text='Test'..x=160..y=160..size='50');

        page.nodes.add(new Path()..color='blue'..path='M 55 22 L 272 99'..width='20'..x=50..y=50);

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
            var path = new Freehand()
                ..color='black'
                ..width='12';

            page.nodes.add(path);
            
            tool.selectedNode = path;
            tool.propertyPanel = path.propertyPanel;
            
            var events = [];

            ['touchmove', 'mousemove'].forEach((event) => events.add(element.parent.on[event].listen((MouseEvent e) {
                var x = e.offset.x;
                var y = e.offset.y;
                path.freehand += "$x, $y ";
                e.preventDefault();
                e.stopPropagation();
            })));

            ['touchend', 'mouseup'].forEach((event) => events.add(element.parent.on[event].listen((_) {
                events.forEach((e) => e.cancel());

                if (path.freehand.length > 4) {
                    var node = new Path()
                        ..color=path.color
                        ..path=simplify.simplify(path.freehand.trim())
                        ..width=path.width
                        ..x=0
                        ..y=0;

                    page.nodes.add(node);
                    page.nodes.remove(path);

                    tool.selectedNode = node;
                    tool.propertyPanel = node.propertyPanel;
                }
            })));
        }));

        element.onClick.where((_) => tool.selectedTool == 'text').listen((MouseEvent e) {
            print('click');
            
            var node = new Text(edit: true)
                ..color='black'
                ..text=''
                ..x=e.client.x
                ..y=e.client.y - 12
                ..size='24';
            
            page.nodes.add(node);
            element.parent.onClick.first.then((_) => node.editing = false);
            
            tool.selectedNode = node;
            tool.propertyPanel = node.propertyPanel;
            
            e.stopPropagation();
            e.preventDefault();
        });
    }
}
