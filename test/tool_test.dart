library tool_tests;

import 'package:unittest/unittest.dart';
import '../web/lib/cogito.dart';

main() {
    unittestConfiguration.timeout = new Duration(seconds: 3);

    group('ToolController', () {
        test('tool change', () {
            var tool = new ToolController();

            tool.onToolChange.listen(expectAsync((tool) {
                expect(tool, equals('draw'));
            }));

            expect(tool.selectedTool, equals('select'));

            tool.selectedTool = 'draw';
        });
    });
}
