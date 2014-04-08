part of cogito;

class Page {
    List<Node> nodes = new List<Node>();
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
        <path ng-attr-x="{{ node.x }}" ng-attr-y="{{ node.y }}"
              stroke="{{ node.color }}" stroke-width="{{ node.width }}" fill="none"
              ng-attr-d="{{ node.path }}" />
        """;
}

class Text extends Node {
    String color;
    int size;
    String text;

    String get svg =>
        """"
        <text ng-attr-x="{{ node.x }}" ng-attr-y="{{ node.y }}"
              fill="{{ node.color }}" style="font-size: {{ node.size }};">
            {{ node.text }}
        </text>
        """;
}
