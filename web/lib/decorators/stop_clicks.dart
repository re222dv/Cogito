part of cogito_web;

/**
 * Stops the propagation of click and mousedown events
 */
@Decorator(selector: '[stop-clicks]')
class StopClicksDecorator {
    static const EVENTS = const ['click', 'mousedown'];

    StopClicksDecorator(Element element) {
        EVENTS.forEach((event) => element.on[event].listen((Event e) => e.stopPropagation()));
    }
}
