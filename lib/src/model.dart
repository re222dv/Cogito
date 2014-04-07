part of cogito;

class Page {
    List<Path> paths = new List<Path>();
    List<Text> texts = new List<Text>();
}

abstract class Node {
    int x;
    int y;
}

class Path extends Node {
    String color;
    String path;
    int width;
}

class Text extends Node {
    String color;
    int size;
    String text;
}
