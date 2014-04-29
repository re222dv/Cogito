import 'dart:async';
import 'dart:html';
import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';
import 'panel_test.dart' as panel;
import 'tool_test.dart' as tool;

main() {
    useHtmlEnhancedConfiguration();

    panel.main();
    tool.main();
}
