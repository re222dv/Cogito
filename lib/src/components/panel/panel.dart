part of cogito;

@NgComponent(
    selector: 'panel',
    templateUrl: '../lib/src/components/panel/panel.html',
    cssUrl: '../lib/src/components/panel/panel.css',
    publishAs: 'cmp'
)
class PanelComponent extends NgShadowRootAware {

    String position;

    @NgAttr('position')
    set value(value) {
        position = value;
        print(value);
    }

    List<int> get textSizes => [12, 14, 16, 18, 20, 22, 24, 26, 28, 30];

    PanelComponent(Element element) {
    }

    void onShadowRoot(ShadowRoot shadowRoot) {
        var panel = shadowRoot.querySelector('[data-position]>div');

        ['click', 'mousedown'].forEach((event) => panel.on[event].listen((Event e) => e.stopPropagation()));
    }
}
