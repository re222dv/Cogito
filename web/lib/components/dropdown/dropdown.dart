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
    bool _open = false;

    get value => _value;
    set value(val) {
        if (type == 'int' && val is String) {
            val = int.parse(val);
        }

        _ngModel.viewValue = val;
        _ngModel.render(_ngModel.modelValue);
    }

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
        _ngModel.render = (val) =>_value = val;
    }

    onShadowRoot(ShadowRoot shadowRoot) {
        var element = shadowRoot.querySelector('div');

        var dragging = false;

        element.onMouseDown.listen((e) {
            dragging = true;
            e.preventDefault();
        });

        element.onMouseOut.where((_) => dragging).listen((_) => open = true);

        element.onMouseUp.where((_) => dragging).listen((e) {
            dragging = false;

            if (e.target.parent != null && e.target.parent.tagName == 'LI') {
                open = false;
                value = e.target.parent.getAttribute('value');
            } else {
                open = !open;
            }
        });
    }
}
