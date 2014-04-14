import 'package:angular/angular.dart';
import 'package:logging/logging.dart';

import 'package:cogito/cogito.dart';

class WebModule extends Module {
    WebModule() {
        type(PageComponent);
        type(PanelComponent);
        type(BindHtmlDirective);
        type(NodeHandlerDirective);
    }
}

main() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord r) {
        print(r.message);
    });
    ngBootstrap(module: new WebModule());
}
