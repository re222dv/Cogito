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
        <path stroke="{{ node.color }}" stroke-width="{{ node.width }}" fill="none" ng-attr-d="{{ node.path }}" />
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
                <text fill="{{ node.color }}" font-size="{{ node.size }}" ng-attr-y="{{ node.size }}">
                    {{ node.text }}
                </text>
                """;
}

class BasicList extends Node {
    List<String> rows;
    int textSize;

    String get row =>
            """
            <g ng-repeat="row in node.rows track by \$index">
                <circle ng-attr-r="{{ node.textSize * 0.2 }}" ng-attr-cx="{{ node.textSize * 0.2 }}"
                        ng-attr-cy="{{ node.textSize * (1 + \$index) - node.textSize * 0.33 }}" />
                <text fill="black" ng-attr-font-size="{{ node.textSize }}"
                      ng-attr-x="{{ node.textSize * 0.55 }}" ng-attr-y="{{ node.textSize * (1 + \$index) }}">{{ row }}</text>
            </g>
            """;

    String get svg =>
            """
            <g>
                $row
            </g>
            """;
}
