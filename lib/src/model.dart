part of cogito;

class Page {
    List<Node> nodes = [];
}

abstract class Node {
    int x;
    int y;

    String get svg;
}

class Path extends Node {
    String color;
    String path;
    int width;

    String get svg =>
        """
        <path stroke="{{ node.color }}" stroke-width="{{ node.width }}" fill="none"
              ng-attr-d="{{ node.path }}" />
        """;
}

class Text extends Node {
    String color;
    int size;
    String text;

    String get svg =>
        """"
        <text fill="{{ node.color }}" style="font-size: {{ node.size }};" ng-attr-y="{{ node.size }}">
            {{ node.text }}
        </text>
        """;
}
