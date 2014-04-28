import 'package:RestLibrary/restlibrary.dart';

main() {
    new RestServer()
        ..static('../build/web')
        ..route(new Route('/page/{id}')
            ..get = servePage)
        ..start(port: 9000);
}

Response servePage(Request request) {
    return new Response({
        'nodes': [
            {
                'type': 'text',
                'x': 30,
                'y': 50,
                'size': '20',
                'color': 'red',
                'text': 'Hello, World!'
            },
            {
                "type":"path",
                "x":200,
                "y":300,
                "width":"20",
                "color":"yellow",
                "path":"M 0 0 L 100 100"
            }
        ]
    });
}
