part of cogito;

class Page {
    List<Node> nodes = new List<Node>();
}

abstract class Node {
    int x;
    int y;
}

class Text extends Node {
    String color;
    int size;
    String text;
}
