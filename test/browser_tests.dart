import 'dart:async';
import 'dart:html';
import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';
import 'helpers_test.dart' as helpers;
import 'panel_test.dart' as panel;
import 'tool_test.dart' as tool;

main() {
    useHtmlConfiguration();

    helpers.main();

    panel.main();
    tool.main();
}
