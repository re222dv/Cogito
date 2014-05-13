import 'package:unittest/html_config.dart';
import 'tests/browser/dropdown_test.dart' as dropdown;
import 'tests/browser/page_test.dart' as page;
import 'tests/browser/page_service_test.dart' as page_service;
import 'tests/browser/panel_test.dart' as panel;
import 'tests/browser/prioritize_test.dart' as prioritize;
import 'tests/browser/remove_leading_test.dart' as remove_leading;
import 'tests/browser/stop_clicks_test.dart' as stop_clicks;
import 'tests/browser/tool_test.dart' as tool;
import 'tests/browser/tool_decorator_test.dart' as tool_decorator;

main() {
    useHtmlConfiguration();

    dropdown.main();
    page.main();
    page_service.main();
    panel.main();
    prioritize.main();
    remove_leading.main();
    stop_clicks.main();
    tool.main();
    tool_decorator.main();
}
