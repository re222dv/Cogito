part of cogito;

class Page {
    List<Node> nodes = [];
}

abstract class Node {
    final bool editable = false;
    bool editing = false;

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
    bool editable = true;

    String color;
    int size;
    String text;

    String get svg =>
            editing ?
                """
                <svg transform="translate(-7,0)">
                    <foreignobject ng-attr-height="{{ node.size + 10 }}" ng-attr-width="{{ node.size * node.text.length }}">
                        <input type="text" ng-model="node.text" style="color: {{ node.color }};font-size: {{ node.size }}px;"></input>
                    </foreignobject>
                </svg>
                """
            :
                """"
                <text fill="{{ node.color }}" style="font-size: {{ node.size }};" ng-attr-y="{{ node.size }}">
                    {{ node.text }}
                </text>
                """;
}
