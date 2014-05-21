part of cogito_web;

/**
 * Handles all keyboard events
 */
@Decorator(selector: '[keyboard-listener]')
class KeyboardListenerDecorator {
    ToolController tool;

    var keyMap;

    KeyboardListenerDecorator(this.tool) {
        keyMap = [
            new KeyBinding(tool.save, 83, ctrl: true),                          // Ctrl + S
            new KeyBinding(tool.delete, 46),                                    // Delete
            new KeyBinding(tool.delete, 46, ctrl: true),                        // Ctrl + Delete
            new KeyBinding(tool.raise, 107),                                    // +
            new KeyBinding(tool.lower, 109),                                    // -
            new KeyBinding(() => tool.selectedTool = 'select', 49, alt: true),  // Alt + 1
            new KeyBinding(() => tool.selectedTool = 'draw', 50, alt: true),    // Alt + 2
            new KeyBinding(() => tool.selectedTool = 'line', 51, alt: true),    // Alt + 3
            new KeyBinding(() => tool.selectedTool = 'arrow', 52, alt: true),   // Alt + 4
            new KeyBinding(() => tool.selectedTool = 'rect', 53, alt: true),    // Alt + 5
            new KeyBinding(() => tool.selectedTool = 'circle', 54, alt: true),   // Alt + 6
            new KeyBinding(() => tool.selectedTool = 'text', 55, alt: true),    // Alt + 7
            new KeyBinding(() => tool.selectedTool = 'list', 56, alt: true),    // Alt + 8
        ];

        document.onKeyDown
            .where((e) => keyMap.any((binding) => binding.matches(e)))
            .listen((e) {
                keyMap.singleWhere((binding) => binding.matches(e)).handler();

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

    bool matches(KeyboardEvent e) => keyCode == e.keyCode &&
                                     alt == e.altKey &&
                                     ctrl == e.ctrlKey &&
                                     shift == e.shiftKey;
}
