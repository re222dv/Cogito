part of cogito_web;

@Component(
    selector: 'popup-menu',
    templateUrl: 'lib/components/popup_menu/popup_menu.html',
    cssUrl: 'lib/components/popup_menu/popup_menu.css',
    publishAs: 'cmp',
    map: const {'items': '=>items'}
)
class PopupMenuComponent {
    final Element _element;
    final NgModel _ngModel;

    Map<String, Function> _items;

    Map<String, Function> get items => _items;
    set items (Map<String, Function> items) {
        _items = items;
    }

    List<String> get values => items.keys;

    bool _open = false;
    bool get open => _open;
    set open(bool open) {
        _open = open;

        if (open) {
            _element.classes.add('open');
        } else {
            _element.classes.remove('open');
        }
    }

    PopupMenuComponent(this._element) {
        _element.onClick.where((Event e) => e.target == _element).listen((_) => open = !open);
    }
}
