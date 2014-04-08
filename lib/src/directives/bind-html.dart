part of cogito;

/**
 * A custom 
 */
@NgDirective(selector: '[bind-html]')
class BindHtmlDirective {
    static NodeValidator validator;

    Element _element;
    Compiler _compiler;
    Injector _injector;
    DirectiveMap _directiveMap;

    BindHtmlDirective(this._element, this._injector, this._compiler, this._directiveMap) {
        validator = new NodeValidatorBuilder.common()
            ..allowSvg();
    }

    @NgOneWay('bind-html')
    set value(value) {
        if (value == null) {
            _element.nodes.clear();
            return;
        }
        _element.setInnerHtml((value == null ? '' : value), validator: validator);
        if (value != null) {
            _compiler(_element.childNodes, _directiveMap)(_injector, _element.childNodes);
        }
    }
}
