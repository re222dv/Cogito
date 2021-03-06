library simplify;

import 'dart:math' as math;
import 'package:quiver/core.dart' as quiver;

/*
 * A simple library for simplifying a path.
 * Mostly a port of [simplify.js](https://github.com/mourner/simplify-js/blob/master/simplify.js)
 */

/**
 * A simple 2D point
 */
class _Point {
    num x;
    num y;

    /**
     * distance between 2 points.
     */
    num getDist(_Point p) {
        return math.sqrt(getSqDist(p));
    }

    /**
     * Square distance between 2 points.
     */
    num getSqDist(_Point p) {
        var dx = x - p.x,
            dy = y - p.y;
        return dx * dx + dy * dy;
    }

    /**
     * Square distance from a point to a segment.
     */
    num getSqSegDist(_Point p1, _Point p2) {

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

    String toString() => "${x.toStringAsFixed(1)} ${y.toStringAsFixed(1)}";

    bool operator ==(_Point point) => x == point.x && y == point.y;
    int get hashCode => quiver.hash2(x.hashCode, y.hashCode);
}

class UnpaddedPoints {
    math.Point corner;
    List<math.Point> points;
}

class SimplifiedPath {
    math.Point corner;
    String path;
}

/**
 * Basic distance-based simplification.
 */
List<_Point> simplifyRadialDist(List<_Point> points, num sqTolerance) {

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
List<_Point> simplifyDouglasPeucker(List<_Point> points, num sqTolerance) {

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
 * Simplification using by removing padding so that the left most point have an x coordinate of zero
 * and the top most point have an y coordinate of zero.
 *
 * Returns the point
 */
UnpaddedPoints removePadding(List<math.Point> points) {
    var xPadding = points.map((point) => point.x).reduce(math.min);
    var yPadding = points.map((point) => point.y).reduce(math.min);
    
    var unpaddedPoints = points.map((point) => new math.Point(point.x - xPadding, point.y - yPadding)).toList();

    return new UnpaddedPoints()..corner=(new math.Point(xPadding, yPadding))..points=unpaddedPoints;
}

/**
 * Simplify a polyline  to a path by removing unnecessary points.
 */
SimplifiedPath simplify(String svgPoints, [tolerance = 2.5]) {
    List<_Point> points = [];

    var coords = svgPoints.replaceAll(',', '') .split(' ');

    if (coords.length == 1) {
        return new SimplifiedPath();
    }

    for (int i = 0, length = coords.length; i < length; i += 2) {
        points.add(new _Point()
                        ..x=num.parse(coords.removeAt(0))
                        ..y=num.parse(coords.removeAt(0))
        );
    }

    var sqTolerance = tolerance * tolerance;

    points = simplifyRadialDist(points, sqTolerance);
    points = simplifyDouglasPeucker(points, sqTolerance);
    
    var mathPoints = points.map((point) => new math.Point(point.x, point.y)).toList();
    var unpaddedPoints = removePadding(mathPoints);
    points = unpaddedPoints.points.map((point) => new _Point()..x=point.x..y=point.y).toList();

    var start = points.removeAt(0).toString();
    var svgPath = points.join(' L ');

    return new SimplifiedPath()..corner=unpaddedPoints.corner..path="M $start L $svgPath";
}
