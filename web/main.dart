import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:logging/logging.dart';

import 'lib/cogito.dart';

void routeInitializer(Router router, RouteViewFactory views) {
    views.configure({
        'login': ngRoute(
            path: '/',
            view: 'views/login.html'),
        'page': ngRoute(
            path: '/page',
            viewHtml: '<page></page>')
    });
}

class WebModule extends Module {
    WebModule() {
        bind(DropDownComponent);
        bind(LoadingComponent);
        bind(PageComponent);
        bind(PanelComponent);
        bind(CheckBoxController);
        bind(ArrowController);
        bind(LoginController);
        bind(NodeHandlerController);
        bind(ToolController);
        bind(ArrowToolDecorator);
        bind(CircleToolDecorator);
        bind(DragHandlesDecorator);
        bind(DrawToolDecorator);
        bind(KeyboardListenerDecorator);
        bind(LineToolDecorator);
        bind(ListToolDecorator);
        bind(RectToolDecorator);
        bind(StopClicksDecorator);
        bind(TextToolDecorator);
        bind(ToolDecorator);
        bind(PrioritizeFormatter);
        bind(RemoveLeadingFormatter);
        bind(NotificationService);
        bind(PageService);
        bind(RouteInitializerFn, toValue: routeInitializer);
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
