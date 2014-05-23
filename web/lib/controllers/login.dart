part of cogito_web;

@Controller(
    selector: '[login-controller]',
    publishAs: 'ctrl')
class LoginController extends AttachAware {
    Element element;
    Router router;
    UserService userService;

    var user = new User();
    var newUser = new User();

    var emailExists = false;
    var isRegistering = false;
    var loginError = false;
    var registrationDone = false;
    var showRegisterModal = false;
    var showResetModal = false;
    var showLicensesModal = false;
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
        showRegisterModal = false;
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
                unknownRegisterError = true;
            }
        });
    }

    /**
     * Scroll past the login section.
     */
    scrollDown() {
        var properties = {
            'scrollTop': element.querySelector('section').clientHeight
        };

        animate(document.body, properties: properties, duration: 1000);
    }

    attach() {
        // Fix for the footer to come above the login section when scrolled down
        var loginSectionHeight = element.querySelector('section').clientHeight;
        var footer = element.querySelector('footer');

        document.onScroll.listen((e) {
            if (document.body.scrollTop > loginSectionHeight) {
                footer.style.zIndex = '2';
            } else {
                footer.style.zIndex = '1';
            }
        });
    }
}
