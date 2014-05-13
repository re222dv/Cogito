import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:logging/logging.dart';

import 'lib/cogito.dart';

class WebModule extends Module {
    WebModule() {
        bind(DropDownComponent);
        bind(PageComponent);
        bind(PanelComponent);
        bind(CheckBoxController);
        bind(ArrowController);
        bind(NodeHandlerController);
        bind(ToolController);
        bind(DrawToolDecorator);
        bind(KeyboardListenerDecorator);
        bind(LineToolDecorator);
        bind(ListToolDecorator);
        bind(StopClicksDecorator);
        bind(TextToolDecorator);
        bind(ToolDecorator);
        bind(PrioritizeFormatter);
        bind(RemoveLeadingFormatter);
        bind(PageService);
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
