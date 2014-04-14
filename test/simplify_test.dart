import 'package:unittest/unittest.dart';
import '../lib/simplify/simplify.dart';

var points = '224.55, 250.15 226.91, 244.19 233.31, 241.45 234.98, 236.06 244.21, 232.76 262.59, 215.31 267.76, 213.81 273.57, 201.84 273.12, 192.16 277.62, 189.03 280.36, 181.41 286.51, 177.74 292.41, 159.37 296.91, 155.64 314.95, 151.37 319.75, 145.16 330.33, 137.57 341.48, 139.96 369.98, 137.89 387.39, 142.51 391.28, 139.39 409.52, 141.14 414.82, 139.75 427.72, 127.30 439.60, 119.74 474.93, 107.87 486.51, 106.75 489.20, 109.45 493.79, 108.63 504.74, 119.66 512.96, 122.35 518.63, 120.89 524.09, 126.88 529.57, 127.86 534.21, 140.93 539.27, 147.24 567.69, 148.91 575.25, 157.26 580.62, 158.15 601.53, 156.85 617.74, 159.86 622.00, 167.04 629.55, 194.60 638.90, 195.61 641.26, 200.81 651.77, 204.56 671.55, 222.55 683.68, 217.45 695.25, 219.15 700.64, 217.98 703.12, 214.36 712.26, 215.87 721.49, 212.81 727.81, 213.36 729.98, 208.73 735.32, 208.20 739.94, 204.77 769.98, 208.42 779.60, 216.87 784.20, 218.16 800.24, 214.62 810.53, 219.73 817.19, 226.82 820.77, 236.17 827.23, 236.16 829.89, 239.89 851.00, 248.94 859.88, 255.49 865.21, 268.53 857.95, 280.30 865.48, 291.45 866.81, 298.66 864.68, 302.71 867.79, 306.17 859.87, 311.37 860.08, 314.35 858.29, 314.94 858.10, 327.60 854.54, 335.40 860.92, 343.00 856.43, 350.15 851.42, 352.96 849.84, 359.59 854.56, 365.53 849.74, 370.38 844.09, 371.89 844.75, 380.44 841.52, 383.67 839.57, 390.40 845.59, 399.05 848.40, 407.55 843.71, 411.30 844.09, 419.88 839.51, 432.76 841.33, 441.04 847.62, 449.22 847.16, 458.44 851.38, 462.79 853.97, 471.15 866.36, 480.77';

var simplified = 'M 224.55 250.15 L 267.76 213.81 L 296.91 155.64 L 330.33 137.57 L 409.52 141.14 L 439.6 119.74 L 486.51 106.75 L 529.57 127.86 L 539.27 147.24 L 617.74 159.86 L 629.55 194.6 L 671.55 222.55 L 727.81 213.36 L 739.94 204.77 L 769.98 208.42 L 779.6 216.87 L 800.24 214.62 L 820.77 236.17 L 859.88 255.49 L 865.21 268.53 L 857.95 280.3 L 867.79 306.17 L 859.87 311.37 L 854.54 335.4 L 860.92 343.0 L 849.84 359.59 L 854.56 365.53 L 844.09 371.89 L 839.57 390.4 L 848.4 407.55 L 839.51 432.76 L 853.97 471.15 L 866.36 480.77';

void main() {
    group('Simplify', () {
        test('simplifies points correctly with the given tolerance', () {
            var result = simplify(points, 5);
            expect(result, equals(simplified));
        });

        test('just return the line if it has only two points', () {
            var result = simplify('1, 2 4, 5');
            expect(result, equals('M 1 2 L 4 5'));
        });

        test('just return the points if it has no points', () {
            var result = simplify('');
            expect(result, equals(''));
        });
    });
}
