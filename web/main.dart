import 'package:angular/angular.dart';
import 'package:logging/logging.dart';

class WebModule extends Module {
    WebModule() {
    }
}

main() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord r) {
        print(r.message);
    });
    ngBootstrap(module: new WebModule());
}
