part of cogito_web;

@Controller(
    selector: '[login-controller]',
    publishAs: 'ctrl')
class LoginController {
    Element element;

    LoginController(this.element);

    scrollDown() {
        var properties = {
            'scrollTop': element.querySelector('section').clientHeight
        };

        animate(element, properties: properties, duration: 1000);
    }
}
