part of cogito_web;

/**
 * Handles notification using the HTML5 notification API, denied notifications are silently ignored.
 */
@Injectable()
class NotificationService {
    var permission;

    NotificationService() {
        Notification.requestPermission().then((permission) {
            this.permission = permission;
        });
    }

    /**
     * Notifies the user
     */
    void notify(String message) {
        if (permission == 'granted') {
            new Notification(message);
        } else if (permission != 'denied') {
            Notification.requestPermission().then((permission) {
                this.permission = permission;

                notify(message);
            });
        }
    }
}
