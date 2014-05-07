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
            new KeyBinding(tool.save, 83, ctrl: true),              // Ctrl + S
            new KeyBinding(tool.delete, 46),                        // Delete
            new KeyBinding(tool.raise, 107),                        // +
            new KeyBinding(tool.lower, 109),                        // -
            new KeyBinding(() => tool.selectedTool = 'select', 83), // S
            new KeyBinding(() => tool.selectedTool = 'draw', 68),   // D
            new KeyBinding(() => tool.selectedTool = 'line', 81),   // Q
            new KeyBinding(() => tool.selectedTool = 'arrow', 65),  // A
            new KeyBinding(() => tool.selectedTool = 'text', 84),   // T
            new KeyBinding(() => tool.selectedTool = 'list', 76)    // L
    ];

        element.onKeyDown
            .where((e) => keyMap.any((binding) => binding == e))
            .listen((e) {
                keyMap.singleWhere((binding) => binding == e).handler();

                e.preventDefault();
            });
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
