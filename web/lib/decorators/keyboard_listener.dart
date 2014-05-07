part of cogito_web;

/**
 * Handles all keyboard events
 */
@Decorator(selector: '[keyboard-listener]')
class KeyboardListenerDecorator {
    Element element;
    ToolController tool;

    var keyMap;

    KeyboardListenerDecorator(this.element, this.tool) {
        keyMap = [
            new KeyBinding(tool.delete, 127) 
        ];

        element.onKeyPress
            .where((e) => keyMap.any((binding) => binding == e))
            .listen((e) => keyMap.singleWhere((binding) => binding == e).handler());
    }
}

/**
 * A KeyBinding represents a keyboard command and is comparable with a KeyboardEvent
 */
class KeyBinding {
    final bool alt;
    final bool ctrl;
    final bool shift;
    final int keyCode;
    final Function handler;

    KeyBinding(this.handler, this.keyCode, {this.alt: false, this.ctrl: false, this.shift: false});

    operator ==(KeyboardEvent e) => keyCode == e.keyCode &&
                                    alt == e.altKey &&
                                    ctrl == e.ctrlKey &&
                                    shift == e.shiftKey;
}