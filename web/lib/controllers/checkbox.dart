part of cogito_web;

@Controller(
    selector: '[checkbox]',
    publishAs: 'checkbox')
class CheckBoxController {
    Scope _scope;

    bool get checked => _scope.context['row'].startsWith('*');

    CheckBoxController(Scope this._scope);
}
