import 'tests/vm/authorization_routes_test.dart' as authorization_routes;
import 'tests/vm/page_routes_test.dart' as page_routes;
import 'tests/vm/user_test.dart' as user;
import 'tests/vm/model_test.dart' as model;
import 'tests/vm/simplify_test.dart' as simplify;

main() {
    authorization_routes.main();
    page_routes.main();

    user.main();
    model.main();
    simplify.main();
}
