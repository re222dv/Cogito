part of cogito;

/**
 * A node is an object on a page. I.E. a Text or a Line
 */
abstract class Node {
    final bool editable = false;
    bool _editing = false;

    String get type;

    num x;
    num y;

    num scale = 1;

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
        scale = json['scale'];
    }

    Node clone();

    Map toJson() {
        return {
            'type': type,
            'x': x,
            'y': y,
            'scale': scale
        };
    }

    noSuchMethod(Invocation invocation) => null;
}

abstract class LineProperties {
    String color;
    num width;
}

abstract class TextProperties {
    String color;
    num size;
}

abstract class AreaProperties {
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

class Freehand extends Node with LineProperties {
    final String type = 'freehand';

    String freehand = '';

    Freehand();

    Freehand.fromJson(Map json) : super.fromJson(json) {
        color = json['color'];
        width = json['width'];

        freehand = json['freehand'];
    }

    Node clone() => new Freehand.fromJson(toJson());

    Map toJson() => super.toJson()..addAll({
        'freehand': freehand
    });
}

class Line extends Node with LineProperties {
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

    Line clone() => new Line.fromJson(toJson());

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

    Arrow clone() => new Arrow.fromJson(toJson());
}

class Path extends Node with LineProperties {
    final String type = 'path';

    String path;

    Path();

    Path.fromJson(Map json) : super.fromJson(json) {
        color = json['color'];
        path = json['path'];
        width = json['width'];
    }

    Path clone() => new Path.fromJson(toJson());

    Map toJson() => super.toJson()..addAll({
        'color': color,
        'width': width,
        'path': path
    });
}

class Text extends Node with TextProperties {
    final bool editable = true;
    final String type = 'text';

    String text = '';

    Text();

    Text.fromJson(Map json) : super.fromJson(json) {
        color = json['color'];
        size = json['size'];
        text = json['text'];
    }

    Text clone() => new Text.fromJson(toJson());

    Map toJson() => super.toJson()..addAll({
        'color': color,
        'size': size,
        'text': text
    });
}

class BasicList extends Node with TextProperties {
    final bool editable = true;
    final String type = 'basicList';
    String listType = 'unordered';

    List<String> rows = [];

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

    BasicList clone() => new BasicList.fromJson(toJson());

    Map toJson() => super.toJson()..addAll({
        'color': color,
        'size': size,
        'rows': rows
    });
}

class Rect extends Node with AreaProperties {
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

    Rect clone() => new Rect.fromJson(toJson());

    Map toJson() => super.toJson()..addAll({
        'width': width,
        'height': height,

        'fillColor': fillColor,
        'strokeColor': strokeColor,
        'strokeWidth': strokeWidth
    });
}


class Circle extends Node with AreaProperties {
    final String type = 'circle';

    num radius;

    Circle();

    Circle.fromJson(Map json) : super.fromJson(json) {
        radius = json['radius'];

        fillColor = json['fillColor'];
        strokeColor = json['strokeColor'];
        strokeWidth = json['strokeWidth'];
    }

    Circle clone() => new Circle.fromJson(toJson());

    Map toJson() => super.toJson()..addAll({
        'radius': radius,

        'fillColor': fillColor,
        'strokeColor': strokeColor,
        'strokeWidth': strokeWidth
    });
}
