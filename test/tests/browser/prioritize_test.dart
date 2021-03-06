library prioritize_tests;

import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';
import 'package:guinness/guinness_html.dart';
import '../../../web/lib/cogito.dart';


main() {
    guinnessEnableHtmlMatchers();

    describe('PrioritizeFormatter', () {
        PrioritizeFormatter prioritize;
        var textSizes;

        beforeEach(() {
            // Prepare Angular for testing
            setUpInjector();

            // Make required classes available for dependency injection
            module((Module _) => _
                ..bind(PrioritizeFormatter));

            // Prepare test values
            textSizes = [];
            for (var i = 12; i <= 72; i+= 2) {
                textSizes.add(i);
            }

            // Acquire a PrioritizeFormatter instance
            inject((PrioritizeFormatter _formatter) => prioritize = _formatter);
        });

        // Tell Angular we are done
        afterEach(tearDownInjector);

        it('should prioritize values correctly', () {
            var prioritizedValues = prioritize(textSizes, 22);
            var prioritizedValues2 = prioritize(textSizes, 30);
            var prioritizedValues3 = prioritize(textSizes, 50);

            expect(prioritizedValues).toEqual([12, 14, 16, 18, 20, 24, 26, 28, 30, 32, 36, 46, 56, 66]);
            expect(prioritizedValues2).toEqual([16, 20, 22, 24, 26, 28, 32, 34, 36, 38, 40, 44, 54, 64]);
            expect(prioritizedValues3).toEqual([16, 26, 36, 40, 42, 44, 46, 48, 52, 54, 56, 58, 60, 64]);
        });

        it('should not prioritize values if provides list is short', () {
            var prioritizedValues = prioritize([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 10);

            expect(prioritizedValues).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
        });
    });
}
