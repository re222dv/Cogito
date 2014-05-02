part of cogito_web;

@Component(
    selector: 'page',
    templateUrl: 'lib/components/page/page.html',
    cssUrl: 'lib/components/page/page.css',
    publishAs: 'cmp'
)
class PageComponent {
    Page page;

    PageComponent(Element element, ToolController tool, PageService pages) {

        page = new Page();

        /*var hel = new Text()..color='red'..text='Hello, World!'..x=50..y=50..size='20';
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
        page.lower(hel);*/

        //pages.getPage().then((page) => this.page = page);

        page.nodes.add(new BasicList()..x=400..y=50..size='32'..rows=['Row 1', 'Row 2', 'Row 1']..color='black');
        page.nodes.add(new BasicList()..x=400..y=250..size='12'..rows=['Row 1', 'Row 2', 'Row 3']..color='green');

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
                    var simplePath = simplify.simplify(path.freehand.trim());

                    var node = new Path()
                        ..color=path.color
                        ..path=simplePath.path
                        ..width=path.width
                        ..x=simplePath.corner.x
                        ..y=simplePath.corner.y;

                    page.nodes.add(node);
                    page.nodes.remove(path);

                    tool.selectedNode = node;
                    tool.propertyPanel = node.propertyPanel;
                }
            })));
        }));

        ['touchstart', 'mousedown'].forEach((event) => element.on[event].where((_) => tool.selectedTool == 'line').listen((MouseEvent e) {
            var line = new Line()
                ..color = 'black'
                ..width = '12'
                ..start = (new simplify.Point()
                    ..x = e.offset.x
                    ..y = e.offset.y)
                ..end = (new simplify.Point()
                    ..x = e.offset.x
                    ..y = e.offset.y);

            page.nodes.add(line);

            tool.selectedNode = line;
            tool.propertyPanel = line.propertyPanel;

            var events = [];

            ['touchmove', 'mousemove'].forEach((event) => events.add(element.parent.on[event].listen((MouseEvent e) {
                line.end = new simplify.Point()
                    ..x = e.offset.x
                    ..y = e.offset.y;
                e.preventDefault();
                e.stopPropagation();
            })));

            ['touchend', 'mouseup'].forEach((event) => events.add(element.parent.on[event].listen((_) {
                events.forEach((e) => e.cancel());

                if (line.end != null) {
                    var points = [line.start, line.end];
                    var corner = simplify.removePadding(points);

                    line..start = (new simplify.Point()
                            ..x = points[0].x
                            ..y = points[0].y)
                        ..end = (new simplify.Point()
                            ..x = points[1].x
                            ..y = points[1].y)
                        ..x = corner.x
                        ..y = corner.y;

                    tool.selectedNode = line;
                    tool.propertyPanel = line.propertyPanel;
                } else {
                    page.nodes.remove(line);
                }
            })));
        }));

        element.onClick.where((_) => tool.selectedTool == 'text').listen((MouseEvent e) {
            var node = new Text()
                ..color='black'
                ..text=''
                ..x=e.client.x
                ..y=e.client.y - 12
                ..size='24'
                ..editing = true;

            page.nodes.add(node);
            element.onClick.first.then((_) => node.editing = false);
            tool.onToolChange.where((newTool) => newTool != 'text')
            .first.then((_) => node.editing = false);

            tool.selectedNode = node;
            tool.propertyPanel = node.propertyPanel;

            e.stopPropagation();
            e.preventDefault();
        });

        element.onClick.where((_) => tool.selectedTool == 'list').listen((MouseEvent e) {
            var node = new BasicList()
                ..color='black'
                ..text=''
                ..x=e.client.x
                ..y=e.client.y - 12
                ..size='24'
                ..editing = true;

            page.nodes.add(node);
            element.onClick.first.then((_) => node.editing = false);
            tool.onToolChange.where((newTool) => newTool != 'list')
            .first.then((_) => node.editing = false);

            tool.selectedNode = node;
            tool.propertyPanel = node.propertyPanel;

            e.stopPropagation();
            e.preventDefault();
        });
    }
}
