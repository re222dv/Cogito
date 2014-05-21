part of cogito_web;

@Controller(
    selector: '[login-controller]',
    publishAs: 'ctrl')
class LoginController {
    Element element;
    Router router;
    UserService userService;

    var user = new User();
    var newUser = new User();

    var emailExists = false;
    var isRegistering = false;
    var loginError = false;
    var registrationDone = false;
    var showRegisterBox = false;
    var unknownRegisterError = false;

    LoginController(this.element, this.router, this.userService) {
        userService.isLoggedIn().then((loggedIn) {
            if (loggedIn) {
                router.go('page', {});
            }
        });
    }

    closeRegisterBox() {
        registrationDone = false;
        showRegisterBox = false;
    }

    login() => userService.login(user).then((success) {
        loginError = !success;

        if (success) {
            router.go('page', {});
        }
    });

    register() {
        isRegistering = true;
        emailExists = false;
        unknownRegisterError = false;

        userService.register(newUser).then((result) {
            isRegistering = false;

            if (result['data'] == 'user created') {
                registrationDone = true;
                newUser.email = '';
            } else if (result['message'] == 'email exists') {
                emailExists = true;
            } else {
                print(result);
                unknownRegisterError = true;
            }
        });
    }

    scrollDown() {
        var properties = {
            'scrollTop': element.querySelector('section').clientHeight
        };

        animate(element, properties: properties, duration: 1000);
    }
}
