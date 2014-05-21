import 'package:unittest/html_config.dart';
import 'tests/browser/dropdown_test.dart' as dropdown;
import 'tests/browser/http_service_test.dart' as http_service;
import 'tests/browser/page_test.dart' as page;
import 'tests/browser/page_service_test.dart' as page_service;
import 'tests/browser/panel_test.dart' as panel;
import 'tests/browser/prioritize_test.dart' as prioritize;
import 'tests/browser/remove_leading_test.dart' as remove_leading;
import 'tests/browser/stop_clicks_test.dart' as stop_clicks;
import 'tests/browser/tool_test.dart' as tool;
import 'tests/browser/tool_decorator_test.dart' as tool_decorator;
import 'tests/browser/user_service_test.dart' as user_service;

import 'tests/browser/draw_tool_test.dart' as draw_tool;
import 'tests/browser/arrow_tool_test.dart' as arrow_tool;
import 'tests/browser/line_tool_test.dart' as line_tool;
import 'tests/browser/text_tool_test.dart' as text_tool;
import 'tests/browser/list_tool_test.dart' as list_tool;
import 'tests/browser/rect_tool_test.dart' as rect_tool;
import 'tests/browser/circle_tool_test.dart' as circle_tool;

main() {
    useHtmlConfiguration();

    dropdown.main();
    http_service.main();
    page.main();
    page_service.main();
    panel.main();
    prioritize.main();
    remove_leading.main();
    stop_clicks.main();
    tool.main();
    tool_decorator.main();
    user_service.main();

    draw_tool.main();
    arrow_tool.main();
    line_tool.main();
    rect_tool.main();
    circle_tool.main();
    text_tool.main();
    list_tool.main();
}
