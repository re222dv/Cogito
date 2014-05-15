part of cogito;

/**
 * A node is an object on a page. I.E. a Text or a Line
 */
abstract class Node {
    final bool editable = false;
    bool _editing = false;

    String propertyPanel = '';
    String get type;

    num x;
    num y;

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

    Map toJson() {
        return {
            'type': type,
            'x': x,
            'y': y
        };
    }

    noSuchMethod(Invocation invocation) => null;
}

abstract class Panel {
    String propertyPanel;
}

abstract class LinePanel implements Panel {
    final String propertyPanel = 'line';

    String color;
    num width;
}

abstract class TextPanel implements Panel {
    final String propertyPanel = 'text';

    String color;
    num size;
}

abstract class AreaPanel implements Panel {
    final String propertyPanel = 'area';

    String fillColor;
    String strokeColor;

    num strokeWidth;
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
                case 'rect':
                    nodes.add(new Rect.fromJson(json));
                    break;
                case 'circle':
                    nodes.add(new Circle.fromJson(json));
                    break;
            }
        });
    }

    Map toJson() => {
        'nodes': nodes.map((node) => node.toJson()).toList()
    };
}

class Freehand extends Node with LinePanel {
    final String type = 'freehand';

    String freehand = '';

    Map toJson() => super.toJson()..addAll({
        'freehand': freehand
    });
}

class Line extends Node with LinePanel {
    final String type = 'line';

    math.Point start;
    math.Point end;

    Line();

    Line.fromJson(Map json) : super.fromJson(json) {
        color = json['color'];
        width = json['width'];

        start = new math.Point(json['start']['x'],
                               json['start']['y']);

        end = new math.Point(json['end']['x'],
                             json['end']['y']);
    }

    Map toJson() => super.toJson()..addAll({
        'color': color,
        'width': width,
        'start': {
            'x': start.x,
            'y': start.y
        },
        'end': {
            'x': end.x,
            'y': end.y
        }
    });
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

    Map toJson() => super.toJson()..addAll({
        'color': color,
        'width': width,
        'path': path
    });
}

class Text extends Node with TextPanel {
    final bool editable = true;
    final String type = 'text';

    String text;

    Text();

    Text.fromJson(Map json) : super.fromJson(json) {
        color = json['color'];
        size = json['size'];
        text = json['text'];
    }

    Map toJson() => super.toJson()..addAll({
        'color': color,
        'size': size,
        'text': text
    });
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

    BasicList();

    BasicList.fromJson(Map json) : super.fromJson(json) {
        color = json['color'];
        size = json['size'];
        rows = json['rows'];
    }

    Map toJson() => super.toJson()..addAll({
        'color': color,
        'size': size,
        'rows': rows
    });

    num scale(num times) {
        if (times != null) {
            return (size * times).round();
        } else {
            return 0;
        }
    }
}

class Rect extends Node with AreaPanel {
    final String type = 'rect';

    num width;
    num height;

    Rect();

    Rect.fromJson(Map json) : super.fromJson(json) {
        width = json['width'];
        height = json['height'];

        fillColor = json['fillColor'];
        strokeColor = json['strokeColor'];
        strokeWidth = json['strokeWidth'];
    }

    Map toJson() => super.toJson()..addAll({
        'width': width,
        'height': height,

        'fillColor': fillColor,
        'strokeColor': strokeColor,
        'strokeWidth': strokeWidth
    });
}


class Circle extends Node with AreaPanel {
    final String type = 'circle';

    num radius;

    Circle();

    Circle.fromJson(Map json) : super.fromJson(json) {
        radius = json['radius'];

        fillColor = json['fillColor'];
        strokeColor = json['strokeColor'];
        strokeWidth = json['strokeWidth'];
    }

    Map toJson() => super.toJson()..addAll({
        'radius': radius,

        'fillColor': fillColor,
        'strokeColor': strokeColor,
        'strokeWidth': strokeWidth
    });
}
