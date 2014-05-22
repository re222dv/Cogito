part of cogito;

/**
 * Property mixin for line types nodes
 */
abstract class LineProperties {
    String color;
    num width;
}

/**
 * Property mixin for text type nodes
 */
abstract class TextProperties {
    String color;
    num size;
}

/**
 * Property mixin for area type nodes
 */
abstract class AreaProperties {
    String fillColor;
    String strokeColor;

    num strokeWidth;
}

/**
 * A node is an object on a page. I.E. a TextNode or a LineNode
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
    /// onEdit events are fired when a node leaves and enters edit mode
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

class Page {
    List<Node> nodes = [];

    Page();

    Page.fromJson(Map json) {
        json['nodes'].forEach((Map json) {
            switch(json['type']) {
                case 'line':
                    nodes.add(new LineNode.fromJson(json));
                    break;
                case 'arrow':
                    nodes.add(new ArrowNode.fromJson(json));
                    break;
                case 'path':
                    nodes.add(new PathNode.fromJson(json));
                    break;
                case 'text':
                    nodes.add(new TextNode.fromJson(json));
                    break;
                case 'list':
                    nodes.add(new ListNode.fromJson(json));
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

    Page clone() => new Page.fromJson(toJson());
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

class LineNode extends Node with LineProperties {
    final String type = 'line';

    math.Point start;
    math.Point end;

    LineNode();

    LineNode.fromJson(Map json) : super.fromJson(json) {
        color = json['color'];
        width = json['width'];

        start = new math.Point(json['start']['x'],
                               json['start']['y']);

        end = new math.Point(json['end']['x'],
                             json['end']['y']);
    }

    LineNode clone() => new LineNode.fromJson(toJson());

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

class ArrowNode extends LineNode {
    final String type = 'arrow';

    ArrowNode();

    ArrowNode.fromJson(Map json) : super.fromJson(json);

    ArrowNode clone() => new ArrowNode.fromJson(toJson());
}

class PathNode extends Node with LineProperties {
    final String type = 'path';

    String path;

    PathNode();

    PathNode.fromJson(Map json) : super.fromJson(json) {
        color = json['color'];
        path = json['path'];
        width = json['width'];
    }

    PathNode clone() => new PathNode.fromJson(toJson());

    Map toJson() => super.toJson()..addAll({
        'color': color,
        'width': width,
        'path': path
    });
}

class TextNode extends Node with TextProperties {
    final bool editable = true;
    final String type = 'text';

    String text = '';

    TextNode();

    TextNode.fromJson(Map json) : super.fromJson(json) {
        color = json['color'];
        size = json['size'];
        text = json['text'];
    }

    TextNode clone() => new TextNode.fromJson(toJson());

    Map toJson() => super.toJson()..addAll({
        'color': color,
        'size': size,
        'text': text
    });
}

class ListNode extends Node with TextProperties {
    final bool editable = true;
    final String type = 'list';
    String listType = 'unordered';

    List<String> rows = [];

    String get text => rows.join('\n');

    set text(String t) {
        rows = t.split('\n');
    }

    ListNode();

    ListNode.fromJson(Map json) : super.fromJson(json) {
        color = json['color'];
        size = json['size'];
        rows = json['rows'];
    }

    ListNode clone() => new ListNode.fromJson(toJson());

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
