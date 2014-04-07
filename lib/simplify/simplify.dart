library simplify;

/*
(c) 2013, Vladimir Agafonkin
Simplify.js, a high-performance JS polyline simplification library
mourner.github.io/simplify-js
*/

class Point {
    num x;
    num y;
    
    String toString() => "$x $y";
}

// square distance between 2 points
num getSqDist(Point p1, Point p2) {

    var dx = p1.x - p2.x,
        dy = p1.y - p2.y;

    return dx * dx + dy * dy;
}

// square distance from a point to a segment
num getSqSegDist(Point p, Point p1, Point p2) {

    var x = p1.x,
        y = p1.y,
        dx = p2.x - x,
        dy = p2.y - y;

    if (dx != 0 || dy != 0) {

        var t = ((p.x - x) * dx + (p.y - y) * dy) / (dx * dx + dy * dy);

        if (t > 1) {
            x = p2.x;
            y = p2.y;

        } else if (t > 0) {
            x += dx * t;
            y += dy * t;
        }
    }

    dx = p.x - x;
    dy = p.y - y;

    return dx * dx + dy * dy;
}
// rest of the code doesn't care about point format

// basic distance-based simplification
List<Point> simplifyRadialDist(List<Point> points, num sqTolerance) {

    var prevPoint = points[0],
        newPoints = [prevPoint],
        point;

    for (var i = 1, len = points.length; i < len; i++) {
        point = points[i];

        if (getSqDist(point, prevPoint) > sqTolerance) {
            newPoints.add(point);
            prevPoint = point;
        }
    }

    if (prevPoint != point) {
        newPoints.add(point);
    }

    return newPoints;
}

// simplification using optimized Douglas-Peucker algorithm with recursion elimination
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
            sqDist = getSqSegDist(points[i], points[first], points[last]);

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
        if (markers[i] != 1) {
            newPoints.add(points[i]);
        }
    }

    return newPoints;
}

// both algorithms combined for awesome performance
String simplify(String svgPoints, [tolerance = 1]) {
    
    List<Point> points = []; 
    var coords = svgPoints.replaceAll(',', '') .split(' ');
    
    var length = coords.length;
    
    print("length: $length");
    
    for (int i = 1; i < length; i += 2) {
        var x = coords.removeAt(0),
            y = coords.removeAt(0);
        print("x $x");
        print("y $y");
        points.add(new Point()..x=num.parse(x)..y=num.parse(y));
    }

    var sqTolerance = tolerance * tolerance;

    points = simplifyRadialDist(points, sqTolerance);
    points = simplifyDouglasPeucker(points, sqTolerance);
    
    var svgPath = points.join(' L ');
    
    return "M $svgPath";
}