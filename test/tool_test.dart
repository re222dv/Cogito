library tool_tests;

import 'package:unittest/unittest.dart' hide expect;
import 'package:guinness/guinness.dart';
import '../web/lib/cogito.dart';

main() {
    unittestConfiguration.timeout = new Duration(seconds: 3);

    describe('ToolController', () {
        var tool;

        beforeEach(() {
            tool = new ToolController();

            // As ToolController is a singleton, make sure we start of with select as default tool
            tool.selectedTool = 'select';
            expect(tool.selectedTool).toEqual('select');
        });

        it('should fire an event on tool change', () {
            tool.onToolChange.listen(expectAsync((tool) {
                expect(tool).toEqual('draw');
            }));

            tool.selectedTool = 'draw';
        });
    });
}
