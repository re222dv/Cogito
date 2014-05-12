library remove_leading_tests;

import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';
import 'package:guinness/guinness_html.dart';
import '../../../web/lib/cogito.dart';


main() {
    guinnessEnableHtmlMatchers();

    describe('RemoveLeadingFormatter', () {
        RemoveLeadingFormatter removeLeading;
        var textSizes;

        beforeEach(() {
            // Prepare Angular for testing
            setUpInjector();

            // Make required classes available for dependency injection
            module((Module _) => _
                ..bind(RemoveLeadingFormatter));

            // Acquire a PrioritizeFormatter instance
            inject((RemoveLeadingFormatter _formatter) => removeLeading = _formatter);
        });

        // Tell Angular we are done
        afterEach(tearDownInjector);

        it('should remove leading', () {
            expect(removeLeading('FooBar', 'Foo')).toEqual('Bar');
        });

        it('should do nothing if leading don\'t exsist', () {
            expect(removeLeading('Bar', 'Foo')).toEqual('Bar');
        });
    });
}
