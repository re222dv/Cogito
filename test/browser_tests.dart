import 'dart:async';
import 'dart:html';
import 'package:unittest/unittest.dart';
import 'panel_test.dart' as panel;
import 'tool_test.dart' as tool;

main() {
    panel.main();
    tool.main();

    pollForDone(testCases);
}

pollForDone(List tests) {
    if (tests.every((t)=> t.isComplete)) {
        window.postMessage('dart-main-done', window.location.href);
        return;
    }

    var wait = new Duration(milliseconds: 100);
    new Timer(wait, ()=> pollForDone(tests));
}
