part of cogito_web;

@Component(
    selector: 'panel',
    templateUrl: 'lib/components/panel/panel.html',
    cssUrl: 'lib/components/panel/panel.css',
    publishAs: 'cmp'
)
class PanelComponent extends ShadowRootAware {
    String position;

    @NgAttr('position')
    set value(value) {
        position = value;
    }

    List<int> lineWidths = [];
    List<int> textSizes = [];
    List<String> colors = ['black', 'white', 'red', 'green', 'blue', 'yellow'];

    PanelComponent() {
        // Create line widths from the fibonacci scale
        for (var i = 1, first = 1, second = 1; i < 90; i = first + second, first = second, second = i) {
            lineWidths.add(i);
        }
        for (var i = 12; i <= 72; i+= 2) {
            textSizes.add(i);
        }
    }

    onShadowRoot(ShadowRoot shadowRoot) {
        List<Element> panels = shadowRoot.querySelectorAll('[data-position] > div');

        panels.forEach((panel) {
            ['click', 'mousedown'].forEach((event) => panel.on[event].listen((Event e) => e.stopPropagation()));
        });
    }
}
