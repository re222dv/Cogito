part of cogito_web;

@Component(
    selector: 'modal',
    templateUrl: 'lib/components/modal/modal.html',
    cssUrl: 'lib/components/modal/modal.css',
    publishAs: 'cmp',
    map: const {'open': '<=>open'}
)
class ModalComponent {
    bool _open = true;

    bool get open => _open;
    set open(bool open) {
        if (open is bool) {
            _open = open;
        }
    }
}
