part of cogito;

class Page {
    List<Node> nodes = [];

    Page();

    Page.fromJson(Map json) {
        json['nodes'].forEach((Map json) {
            switch(json['type']) {
                case 'text':
                    nodes.add(new Text.fromJson(json));
                    break;
                case 'path':
                    nodes.add(new Path.fromJson(json));
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

class Freehand extends Node {
    String propertyPanel = 'line';
    String type = 'freehand';

    String color;
    String width;
    String freehand = '';
}

class Path extends Node {
    String propertyPanel = 'line';
    String type = 'path';

    String color;
    String path;
    String width;

    Path();

    Path.fromJson(Map json) : super.fromJson(json) {
        color = json['color'];
        path = json['path'];
        width = json['width'];
    }
}

class Text extends Node {
    bool editable = true;
    String propertyPanel = 'text';
    String type = 'text';

    String color;
    String size;
    String text;

    int get textBoxHeight => int.parse(size) + 10;
    int get textBoxWidth => int.parse(size) * (text.length + 1);

    Text();

    Text.fromJson(Map json) : super.fromJson(json) {
        color = json['color'];
        size = json['size'];
        text = json['text'];
    }
}

class BasicList extends Node {
    bool editable = true;
    String propertyPanel = 'text';
    String type = 'basicList';
    String listType = 'unordered';

    List<String> rows;

    String color;
    String size;

    String get text => rows.join('\n');

    set text(String t) {
        rows = t.split('\n');
    }

    int get textBoxHeight => int.parse(size) * rows.length + 10;
    int get textBoxWidth => int.parse(size) * (text.length + 1);

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
            return (int.parse(size) * times).round();
        } else {
            return 0;
        }
    }
}
