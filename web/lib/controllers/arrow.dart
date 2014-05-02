part of cogito_web;

@Controller(selector: '[arrow]', publishAs: 'arrow')
class ArrowController {

    Arrow node;

    num get radians => math.atan2(node.end.y - node.start.y, node.end.x - node.start.x);
    num get quarterRadians => radians + math.PI / 2;
    num get width => num.parse(node.width);

    num get headLength => node.start.getDist(node.end) * 0.3;
    num get headWidth => width * 8;

    num get headCut => math.sqrt(math.pow(headLength, 2) + math.pow(width, 2));
    num get headHypotenuse => math.sqrt(math.pow(headLength, 2) + math.pow(headWidth / 2, 2));

    String get points => '''
        ${ node.start.x + width * math.cos(quarterRadians) }
        ${ node.start.y + width * math.sin(quarterRadians) },

        ${ node.end.x - headCut * math.cos(radians - math.atan(width / headLength)) }
        ${ node.end.y - headCut * math.sin(radians - math.atan(width / headLength)) },

        ${ node.end.x - headHypotenuse * math.cos(radians - math.atan(headWidth / headLength) / 2) }
        ${ node.end.y - headHypotenuse * math.sin(radians - math.atan(headWidth / headLength) / 2) },

        ${ node.end.x } ${ node.end.y },

        ${ node.end.x - headHypotenuse * math.cos(radians + math.atan(headWidth / headLength) / 2) }
        ${ node.end.y - headHypotenuse * math.sin(radians + math.atan(headWidth / headLength) / 2) },

        ${ node.end.x - headCut * math.cos(radians + math.atan(width / headLength)) }
        ${ node.end.y - headCut * math.sin(radians + math.atan(width / headLength)) },

        ${ node.start.x - width * math.cos(quarterRadians) }
        ${ node.start.y - width * math.sin(quarterRadians) }
    ''';

    ArrowController(Scope scope) {
        node = scope.context['node'];
    }
}
