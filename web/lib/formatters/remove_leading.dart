part of cogito_web;

/**
 * A formatter that removes the leading prefix, if it exists.
 */
@Formatter(name: 'removeLeading')
class RemoveLeadingFormatter implements Function {
    String call(String fullString, String prefix) {
        if (fullString.startsWith(prefix)) {
            return fullString.substring(prefix.length);
        } else {
            return fullString;
        }
    }
}
