part of cogito;

/**
 * A custom
 */
@NgDirective(selector: '[bind-html]')
class BindHtmlDirective {
    static NodeValidator validator;

    Element element;
    Compiler compiler;
    Injector injector;
    DirectiveMap directiveMap;

    BindHtmlDirective(this.element, this.injector, this.compiler, this.directiveMap) {
        validator = new NodeValidatorBuilder.common()
            ..allowSvg()
            ..allowElement('input', attributes: ['ng-model', 'style'])
            ..allowElement('li', attributes: ['ng-repeat']);
    }

    @NgOneWay('bind-html')
    set value(value) {
        if (value == null) {
            element.nodes.clear();
            return;
        }

        element.setInnerHtml(value, validator: validator);
        compiler(element.childNodes, directiveMap)(injector, element.childNodes);
    }
}
