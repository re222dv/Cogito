part of cogito_web;

/**
 * A component that displays all notifications for a certain amount of time.
 */
@Component(
    selector: 'notifications',
    templateUrl: 'lib/components/notifications/notifications.html',
    cssUrl: 'lib/components/notifications/notifications.css',
    publishAs: 'cmp'
)
class NotificationsComponent {
    static const DELAY = const Duration(seconds: 5);

    var notifications = [];

    NotificationsComponent(NotificationService service) {
        service.onNotification.listen((message) {
            notifications.add(message);

            new Future.delayed(DELAY, () => notifications.remove(message));
        });
    }

    /**
     * Closes the notification with [message]
     */
    close(String message) => notifications.remove(message);
}
