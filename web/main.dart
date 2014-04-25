import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:logging/logging.dart';

import 'package:cogito/cogito.dart';

class WebModule extends Module {
    WebModule() {
        type(PageComponent);
        type(PanelComponent);
        type(NodeHandlerController);
        type(ToolController);
        type(BindHtmlDecorator);
    }
}

main() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord r) {
        print(r.message);
    });
    applicationFactory()
          .addModule(new WebModule())
          .run();
}
