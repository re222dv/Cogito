part of cogito_web;

/**
 * Handles notification using the HTML5 notification API, denied notifications are silently ignored.
 */
@Injectable()
class NotificationService {
    var permission;
    var _onNotification = new StreamController<String>.broadcast();
    Stream get onNotification => _onNotification.stream;

    NotificationService() {
        /*
        We don't use HTML 5 notifications because of dartbug#18920
        https://code.google.com/p/dart/issues/detail?id=18920

        Notification.requestPermission().then((permission) {
            this.permission = permission;
        });
        */
    }

    /**
     * Notifies the user
     */
    void notify(String message) {
        _onNotification.add(message);
        /*
        We don't use HTML 5 notifications because of dartbug#18920
        https://code.google.com/p/dart/issues/detail?id=18920

        if (permission == 'granted') {
            new Notification(message);
        } else if (permission != 'denied') {
            Notification.requestPermission().then((permission) {
                this.permission = permission;

                notify(message);
            });
        }
        */
    }
}
