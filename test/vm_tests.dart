import 'tests/vm/authorization_routes_test.dart' as authorization_routes;
import 'tests/vm/user_test.dart' as user;
import 'tests/vm/model_test.dart' as model;
import 'tests/vm/simplify_test.dart' as simplify;

main() {
    authorization_routes.main();

    user.main();
    model.main();
    simplify.main();
}
