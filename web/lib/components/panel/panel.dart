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

    List<int> textSizes = [];
    List<String> colors = ['black', 'white', 'red', 'green', 'blue', 'yellow'];

    PanelComponent() {
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
