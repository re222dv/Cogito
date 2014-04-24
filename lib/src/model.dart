part of cogito;

class Page {
    List<Node> nodes = [];

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
    bool editing = false;
    String propertyPanel = '';
    String get type;

    int x;
    int y;

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
}

class Text extends Node {
    bool editable = true;
    String propertyPanel = 'text';
    String type = 'text';

    String color;
    String size;
    String text;

    int get textBoxHeight => int.parse(size) + 10;
    int get textBoxWidth => int.parse(size) * text.length;
}

class BasicList extends Node {
    String propertyPanel = 'text';
    String type = 'basicList';

    List<String> rows;

    String color;
    String size;

    int scale(num times) {
        if (times != null) {
            return (int.parse(size) * times).round();
        } else {
            return 0;
        }
    }
}
