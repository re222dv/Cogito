part of cogito_web;

@Controller(
    selector: '[checkbox]',
    publishAs: 'checkbox')
class CheckBoxController {
    Scope _scope;

    bool get checked => _scope.context['row'].startsWith('*');

    CheckBoxController(Scope this._scope, Element element, ToolController tool) {
        element.querySelector('rect').onClick.listen((Event e) {
            if (checked) {
                _scope.context['node'].rows[_scope.context['\$index']] = _scope.context['row'].substring(1);
            } else {
                _scope.context['node'].rows[_scope.context['\$index']] = "*${_scope.context['row']}";
            }

            e.stopPropagation();
        });
    }
}
