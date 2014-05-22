part of cogito_web;

@Controller(selector: '[arrow]', publishAs: 'arrow')
class ArrowController {
    /**
     * Points used in comments bellow:
     *
     *          D
     *        /  \
     *       /    \
     *      C-B  F-E
     *        |  |
     *        |  |
     *        |  |
     *        A--G
     */
    ArrowNode node;

    /// Angle of arrow. I.E. The same angle as that between A and B
    num get radians => math.atan2(node.end.y - node.start.y, node.end.x - node.start.x);
    /// The perpendicular angle of the arrow. I.E.  The angle between A and G
    num get quarterRadians => radians + math.PI / 2;

    /// Length from A to G
    num get width => node.width;
    /// Length from D to the centre point between B and F
    num get headLength => node.start.distanceTo(node.end) * 0.3;
    /// Length from C to E
    num get headWidth => width * 8;

    /// Length from D to B
    num get headCut => math.sqrt(math.pow(headLength, 2) + math.pow(width, 2));
    /// Length from D to C
    num get headHypotenuse => math.sqrt(math.pow(headLength, 2) + math.pow(headWidth / 2, 2));

    String get points =>
        // Point A
        '${ node.start.x + width * math.cos(quarterRadians) }'
        '${ node.start.y + width * math.sin(quarterRadians) },'

        // Point B
        '${ node.end.x - headCut * math.cos(radians - math.atan(width / headLength)) }'
        '${ node.end.y - headCut * math.sin(radians - math.atan(width / headLength)) },'

        // Point C
        '${ node.end.x - headHypotenuse * math.cos(radians - math.atan(headWidth / headLength) / 2) }'
        '${ node.end.y - headHypotenuse * math.sin(radians - math.atan(headWidth / headLength) / 2) },'

        // Point D
        '${ node.end.x } ${ node.end.y },'

        // Point E
        '${ node.end.x - headHypotenuse * math.cos(radians + math.atan(headWidth / headLength) / 2) }'
        '${ node.end.y - headHypotenuse * math.sin(radians + math.atan(headWidth / headLength) / 2) },'

        // Point F
        '${ node.end.x - headCut * math.cos(radians + math.atan(width / headLength)) }'
        '${ node.end.y - headCut * math.sin(radians + math.atan(width / headLength)) },'

        // Point G
        '${ node.start.x - width * math.cos(quarterRadians) }'
        '${ node.start.y - width * math.sin(quarterRadians) }';

    ArrowController(Scope scope) {
        node = scope.context['node'];
    }
}
