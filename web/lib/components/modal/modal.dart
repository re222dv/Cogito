part of cogito_web;

/**
 * A basic modal component.
 */
@Component(
    selector: 'modal',
    templateUrl: 'lib/components/modal/modal.html',
    cssUrl: 'lib/components/modal/modal.css',
    publishAs: 'cmp',
    map: const {'open': '<=>open'}
)
class ModalComponent extends ShadowRootAware {
    bool _open = true;

    bool get open => _open;
    set open(bool open) {
        if (open is bool) {
            _open = open;
        }
    }

    onShadowRoot(ShadowRoot shadowRoot) {
        shadowRoot.querySelector('#background')
            ..onClick.listen((e) {
                open = false;

                e.stopPropagation();
                e.preventDefault();
            })
            ..onMouseWheel.listen((e) {
                e.stopPropagation();
                e.preventDefault();
            });

        shadowRoot.querySelector('#dialog').onClick.listen((e) {
            e.stopPropagation();
            e.preventDefault();
        });
    }
}
