library simplify;

/*
 * A simple library for simplifying a path.
 * Mostly a port of [simplify.js](https://github.com/mourner/simplify-js/blob/master/simplify.js)
 */

/**
 * A simple 2D point
 */
class Point {
    num x;
    num y;

    /**
     * Square distance between 2 points.
     */
    num getSqDist(Point p) {
        var dx = x - p.x,
            dy = y - p.y;

        return dx * dx + dy * dy;
    }

    /**
     * Square distance from a point to a segment.
     */
    num getSqSegDist(Point p1, Point p2) {

        var x = p1.x,
            y = p1.y,
            dx = p2.x - x,
            dy = p2.y - y;

        if (dx != 0 || dy != 0) {
            var t = ((this.x - x) * dx + (this.y - y) * dy) / (dx * dx + dy * dy);

            if (t > 1) {
                x = p2.x;
                y = p2.y;
            } else if (t > 0) {
                x += dx * t;
                y += dy * t;
            }
        }

        dx = this.x - x;
        dy = this.y - y;

        return dx * dx + dy * dy;
    }

    String toString() => "$x $y";
}

/**
 * Basic distance-based simplification.
 */
List<Point> simplifyRadialDist(List<Point> points, num sqTolerance) {

    var prevPoint = points[0],
        newPoints = [prevPoint],
        point;

    for (var i = 1, len = points.length; i < len; i++) {
        point = points[i];

        if (point.getSqDist(prevPoint) > sqTolerance) {
            newPoints.add(point);
            prevPoint = point;
        }
    }

    if (prevPoint != point) {
        newPoints.add(point);
    }

    return newPoints;
}

/**
 * Simplification using optimized Douglas-Peucker algorithm with recursion elimination.
 */
List<Point> simplifyDouglasPeucker(List<Point> points, num sqTolerance) {

    var len = points.length,
        markers = new List<num>(len),
        first = 0,
        last = len - 1,
        stack = [],
        newPoints = [],
        i, maxSqDist, sqDist, index;

    markers[first] = markers[last] = 1;

    while (true) {
        maxSqDist = 0;

        for (i = first + 1; i < last; i++) {
            sqDist = points[i].getSqSegDist(points[first], points[last]);

            if (sqDist > maxSqDist) {
                index = i;
                maxSqDist = sqDist;
            }
        }

        if (maxSqDist > sqTolerance) {
            markers[index] = 1;
            stack.add(first);
            stack.add(index);
            stack.add(index);
            stack.add(last);
        }

        try {
            last = stack.removeLast();
            first = stack.removeLast();
        } catch (e) {
            break;
        }
    }

    for (i = 0; i < len; i++) {
        if (markers[i] == 1) {
            newPoints.add(points[i]);
        }
    }

    return newPoints;
}

/**
 * Simplify a polyline  to a path by removing unnecessary points.
 */
String simplify(String svgPoints, [tolerance = 2.5]) {
    List<Point> points = [];

    var coords = svgPoints.replaceAll(',', '') .split(' ');

    if (coords.length == 1) {
        return '';
    }

    for (int i = 0, length = coords.length; i < length; i += 2) {
        points.add(new Point()
                        ..x=num.parse(coords.removeAt(0))
                        ..y=num.parse(coords.removeAt(0))
        );
    }

    var sqTolerance = tolerance * tolerance;

    points = simplifyRadialDist(points, sqTolerance);
    points = simplifyDouglasPeucker(points, sqTolerance);

    var start = points.removeAt(0).toString();
    var svgPath = points.join(' L ');

    return "M $start L $svgPath";
}
