part of cogito_web;

@Component(
    selector: 'dropdown',
    templateUrl: 'lib/components/dropdown/dropdown.html',
    cssUrl: 'lib/components/dropdown/dropdown.css',
    publishAs: 'cmp'
)
class DropDownComponent extends ShadowRootAware {
    final NgModel _ngModel;

    @NgAttr('type')
    var type;

    @NgOneWay('values')
    List<String> values;

    List<String> prioritizedValues = [];

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

    bool open = false;

    DropDownComponent(this._ngModel) {
        _ngModel.render = (val) {
            _value = val;

            Timer.run(calculatePrioritizedValues);
        };
    }

    calculatePrioritizedValues() {
        if (values.length > 25) {
            var prioritizedValues = [];

            var indexOf = values.indexOf(value);

            if (indexOf >= 0) {
                // Get every fifth step before
                for (int i = indexOf - 7; i >= 0; i -= 5) {
                    prioritizedValues.add(values[i]);
                }
                prioritizedValues = prioritizedValues.reversed.toList();

                // Get the five before
                var start = indexOf - 6;
                var take = 5;
                if (start < 0) {
                    take += start;
                    start = 0;
                }
                take = (take > 0) ? take : 0;
                prioritizedValues.addAll(values.skip(start).take(take));

                // Get the five after
                prioritizedValues.addAll(values.skip(indexOf + 1).take(5));

                // Get every fifth step after
                for (int i = indexOf + 7; i < values.length; i += 5) {
                    prioritizedValues.add(values[i]);
                }

                this.prioritizedValues = prioritizedValues;
            }
        } else {
            this.prioritizedValues = values;
        }
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
