import 'package:unittest/html_config.dart';
import 'panel_test.dart' as panel;
import 'tool_test.dart' as tool;

main() {
    useHtmlConfiguration();

    panel.main();
    tool.main();
}
