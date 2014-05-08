part of cogito_web;

/**
 * A formatter that shows only the most important values if the values list is too long
 */
@Formatter(name: 'prioritize')
class PrioritizeFormatter implements Function {
    List call(List values, value) {
        if (values.length > 25) {
            var prioritizedValues = [];

            var indexOf = values.indexOf(value);

            if (indexOf >= 0) {
                // Get every fifth step before
                for (int i = indexOf - 7; i >= 0; i -= 5) {
                    prioritizedValues.add(values[i]);
                }
                prioritizedValues = prioritizedValues.reversed.toList();

                // Get the five before
                var start = indexOf - 5;
                var take = 5;
                if (start < 0) {
                    take += start;
                    start = 0;
                }
                take = (take > 0) ? take : 0;
                prioritizedValues.addAll(values.skip(start).take(take));

                // Get the five after
                prioritizedValues.addAll(values.skip(indexOf + 1).take(5));

                // Get every fifth step after
                for (int i = indexOf + 7; i < values.length; i += 5) {
                    prioritizedValues.add(values[i]);
                }
            }

            return prioritizedValues;
        } else {
            return values;
        }
    }
}
