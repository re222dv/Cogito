part of cogito_web;

/**
 * Handles the arrow tool
 */
@Decorator(selector: '[arrow-tool]')
class ArrowToolDecorator extends LineToolDecorator {
    final String tool = 'arrow';

    ArrowNode tempNode = new ArrowNode()
        ..color = 'black'
        ..width = 5
        ..start = new math.Point(0 ,0)
        ..end = new math.Point(0 ,0);

    ArrowToolDecorator(Element element, ToolController toolCtrl) : super (element, toolCtrl);
}
