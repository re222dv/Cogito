part of cogito;

@NgComponent(
    selector: 'panel',
    templateUrl: '../lib/src/components/panel/panel.html',
    cssUrl: '../lib/src/components/panel/panel.css',
    publishAs: 'cmp'
)
class PanelComponent extends NgAttachAware {
    final TemplateLoader templateLoader;

    String position;

    @NgAttr('position')
    set value(value) {
        position = value;
        print(value);
    }

    List<int> textSizes = [12, 14, 16, 18, 20, 22, 24, 26, 28, 30];
    List<String> colors = ['black', 'white', 'red', 'green', 'blue', 'yellow'];

    PanelComponent(this.templateLoader);

    attach() {
        templateLoader.template.then((ShadowRoot shadowRoot) {
            List<Element> panels = shadowRoot.querySelectorAll('[data-position] > div');

            panels.forEach((panel) {
                ['click', 'mousedown'].forEach((event) => panel.on[event].listen((Event e) => e.stopPropagation()));
            });
        });
    }
}
