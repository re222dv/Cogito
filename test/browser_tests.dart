import 'package:unittest/html_config.dart';
import 'tests/browser/panel_test.dart' as panel;
import 'tests/browser/tool_test.dart' as tool;

main() {
    useHtmlConfiguration();

    panel.main();
    tool.main();
}
