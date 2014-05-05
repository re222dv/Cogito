part of cogito;

/**
 * A node is an object on a page. I.E. a Text or a Line
 */
abstract class Node {
    final bool editable = false;
    bool _editing = false;

    String propertyPanel = '';
    String get type;

    int x;
    int y;

    num nodeWidth;
    num nodeHeight;

    StreamController _onEdit = new StreamController();
    Stream get onEdit => _onEdit.stream;

    bool get editing => _editing;
    void set editing(e) {
        _editing = e;
        _onEdit.add(e);
    }

    Node();

    Node.fromJson(Map json) {
        x = json['x'];
        y = json['y'];
    }

    noSuchMethod(Invocation invocation) => null;
}

abstract class Panel {
    final String propertyPanel;
}

abstract class LinePanel implements Panel {
    final String propertyPanel = 'line';

    String color;
    int width;
}

abstract class TextPanel implements Panel {
    final String propertyPanel = 'text';

    String color;
    int size;
}

class Page {
    List<Node> nodes = [];

    Page();

    Page.fromJson(Map json) {
        json['nodes'].forEach((Map json) {
            switch(json['type']) {
                case 'line':
                    nodes.add(new Line.fromJson(json));
                    break;
                case 'arrow':
                    nodes.add(new Arrow.fromJson(json));
                    break;
                case 'path':
                    nodes.add(new Path.fromJson(json));
                    break;
                case 'text':
                    nodes.add(new Text.fromJson(json));
                    break;
                case 'basicList':
                    nodes.add(new BasicList.fromJson(json));
                    break;
            }
        });
    }

    void raise(Node node) {
        var i = nodes.indexOf(node);

        if (i < nodes.length - 1) {
            var first = nodes.removeAt(i);
            var second = nodes.removeAt(i);
            nodes.insert(i, first);
            nodes.insert(i, second);
        }
    }

    void lower(Node node) {
        var i = nodes.indexOf(node) - 1;

        if (i >= 0) {
            var first = nodes.removeAt(i);
            var second = nodes.removeAt(i);
            nodes.insert(i, first);
            nodes.insert(i, second);
        }
    }
}

class Freehand extends Node with LinePanel {
    final String type = 'freehand';

    String freehand = '';
}

class Line extends Node with LinePanel {
    final String type = 'line';

    simplify.Point start;
    simplify.Point end;

    Line();

    Line.fromJson(Map json) : super.fromJson(json) {
        color = json['color'];
        width = json['width'];

        start = new simplify.Point()
            ..x = json['start']['x']
            ..y = json['start']['y'];

        end = new simplify.Point()
            ..x = json['end']['x']
            ..y = json['end']['y'];
    }
}

class Arrow extends Line {
    final String type = 'arrow';

    Arrow();

    Arrow.fromJson(Map json) : super.fromJson(json);
}

class Path extends Node with LinePanel {
    final String type = 'path';

    String path;

    Path();

    Path.fromJson(Map json) : super.fromJson(json) {
        color = json['color'];
        path = json['path'];
        width = json['width'];
    }
}

class Text extends Node with TextPanel {
    final bool editable = true;
    final String type = 'text';

    String text;

    int get textBoxHeight => size + 10;
    int get textBoxWidth => size * (text.length + 1);

    Text();

    Text.fromJson(Map json) : super.fromJson(json) {
        color = json['color'];
        size = json['size'];
        text = json['text'];
    }
}

class BasicList extends Node with TextPanel {
    final bool editable = true;
    final String type = 'basicList';
    String listType = 'unordered';

    List<String> rows;

    String get text => rows.join('\n');

    set text(String t) {
        rows = t.split('\n');
    }

    int get textBoxHeight => size * rows.length + 10;
    int get textBoxWidth => size * (text.length + 1);

    BasicList();

    BasicList.fromJson(Map json) : super.fromJson(json) {
        color = json['color'];
        size = json['size'];
        rows = json['rows'];
    }

    String printRow(String row) {
        if (row.startsWith('*')) {
            return row.substring(1);
        } else {
            return row;
        }
    }

    int scale(num times) {
        if (times != null) {
            return (size * times).round();
        } else {
            return 0;
        }
    }
}
