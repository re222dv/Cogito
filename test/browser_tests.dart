import 'package:unittest/html_config.dart';
import 'tests/browser/dropdown_test.dart' as dropdown;
import 'tests/browser/panel_test.dart' as panel;
import 'tests/browser/tool_test.dart' as tool;

main() {
    useHtmlConfiguration();

    dropdown.main();
    panel.main();
    tool.main();
}
