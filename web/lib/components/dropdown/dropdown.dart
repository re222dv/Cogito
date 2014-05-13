part of cogito_web;

@Component(
    selector: 'dropdown',
    templateUrl: 'lib/components/dropdown/dropdown.html',
    cssUrl: 'lib/components/dropdown/dropdown.css',
    publishAs: 'cmp'
)
class DropDownComponent extends ShadowRootAware {
    final Element _element;
    final NgModel _ngModel;

    @NgAttr('type')
    var type;

    @NgOneWay('values')
    List<String> values;

    var _oldValue;
    var _value;
    get value => _value;
    set value(val) {
        if (type == 'int' && val is String) {
            val = int.parse(val);
        }

        _ngModel.viewValue = val;
        _ngModel.render(_ngModel.modelValue);
    }

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

    DropDownComponent(this._element, this._ngModel) {
        _ngModel.render = (val) {
            _value = val;
        };
    }

    onShadowRoot(ShadowRoot shadowRoot) {
        var element = shadowRoot.querySelector('div');

        var dragging = false;

        ['mousedown', 'touchstart'].forEach((event) => element.on[event].listen((e) {
            dragging = true;
            e.preventDefault();
        }));

        ['mouseout', 'touchleave'].forEach((event) {
            element.on[event].where((_) => dragging).listen((_) => open = true);
        });

        ['mouseup', 'touchend'].forEach((event) => element.on[event].where((_) => dragging).listen((e) {
            dragging = false;

            if (e.target.parent != null && e.target.parent.tagName == 'LI') {
                open = false;
                value = e.target.parent.getAttribute('value');
            } else {
                open = !open;
            }
        }));
    }
}
