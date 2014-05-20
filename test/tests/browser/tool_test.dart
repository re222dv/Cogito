library tool_tests;

import 'package:guinness/guinness.dart';
import 'package:cogito/cogito.dart';
import '../../../web/lib/cogito.dart';

var deleteNodeSpy;
var lowerNodeSpy;
var raiseNodeSpy;
var savePageSpy;

class MockPageComponent implements PageComponent {
    MockPageComponent() {
        deleteNodeSpy = guinness.createSpy('deleteNodeSpy');
        lowerNodeSpy = guinness.createSpy('lowerNodeSpy');
        raiseNodeSpy = guinness.createSpy('raiseNodeSpy');
        savePageSpy = guinness.createSpy('savePageSpy');
    }

    delete(node) => deleteNodeSpy(node);
    lower(node) => lowerNodeSpy(node);
    raise(node) => raiseNodeSpy(node);
    save() => savePageSpy();

    // Ignore warnings about unimplemented methods
    noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

main() {

    describe('ToolController', () {
        ToolController tool;
        Node node;

        beforeEach(() {
            tool = new ToolController();
            tool.page = new MockPageComponent();

            node = new Text()..editing = true;
            tool.selectedNode = node;
        });

        it('should fire an event on tool change', () {
            // As ToolController is a singleton, make sure we start of with select as default tool
            tool.selectedTool = 'select';
            expect(tool.selectedTool).toEqual('select');

            var future = tool.onToolChange.first.then((tool) {
                expect(tool).toEqual('draw');
            });

            tool.selectedTool = 'draw';

            return future;
        });

        it('should bind onToolDrag to toolDrag.stream', () {
            expect(tool.onToolDrag).toEqual(tool.toolDrag.stream);
        });

        it('should set a node to not editing on deselect', () {
            tool.selectedNode = null;

            expect(node.editing).toEqual(false);
        });

        it('should delete the current node on delete', () {
            tool.delete();

            expect(deleteNodeSpy).toHaveBeenCalledOnceWith(node);
        });

        it('should raise the current node on raise', () {
            tool.raise();

            expect(raiseNodeSpy).toHaveBeenCalledOnceWith(node);
        });

        it('should lower the current node on lower', () {
            tool.lower();

            expect(lowerNodeSpy).toHaveBeenCalledOnceWith(node);
        });

        it('should save the page on save', () {
            tool.save();

            expect(savePageSpy).toHaveBeenCalledOnce();
        });
    });
}
