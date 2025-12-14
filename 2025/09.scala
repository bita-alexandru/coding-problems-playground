package adventofcode.day09

import scala.math.{min, max, abs}

def input(isExample: Boolean) =
    val inputFile = if isExample then "example.txt" else "input.txt"
    scala.io.Source.fromFile(inputFile)
        .getLines()
        .map: line => 
            val Array(x, y) = line.split(",").map(_.trim.toInt)
            (x = x, y = y)
        .toSeq
end input

def part1(isExample: Boolean = false) =
    val points = input(isExample)
    points.combinations(2).map:
        case Seq(p1, p2) =>
            ((p1.x - p2.x).abs + 1L)*((p1.y - p2.y).abs + 1L)
    .max
end part1

def part2(isExample: Boolean = false) =
    val points = input(isExample)
    val edges = (points ++ points.take(1)).sliding(2).map(s => (s(0), s(1))).toSeq

    def isPointInside(x: Double, y: Double): Boolean =
        edges.count:
            case (a, b) =>
                val isVertical = a.x == b.x
                if isVertical then
                    val (yMin, yMax) = (min(a.y, b.y), max(a.y, b.y))
                    (y >= yMin && y < yMax) && (a.x > x)
                else false
        % 2 == 1

    def isValidRectangle(x1: Int, x2: Int, y1: Int, y2: Int): Boolean =
        val (minX, maxX) = (min(x1, x2), max(x1, x2))
        val (minY, maxY) = (min(y1, y2), max(y1, y2))
        val hasCuttingEdge = edges.exists:
            case (a, b) =>
                if a.x == b.x then
                    val edgeYMin = min(a.y, b.y)
                    val edgeYMax = max(a.y, b.y)
                    (a.x > minX && a.x < maxX) && (edgeYMax > minY && edgeYMin < maxY)
                else
                    val edgeXMin = min(a.x, b.x)
                    val edgeXMax = max(a.x, b.x)
                    (a.y > minY && a.y < maxY) && (edgeXMax > minX && edgeXMin < maxX)
        if hasCuttingEdge then false 
        else
            val midX = (minX + maxX) / 2.0
            val midY = (minY + maxY) / 2.0
            isPointInside(midX, midY)

    points.combinations(2)
        .map:
            case Seq(p1, p2) =>
                val area = ((p1.x - p2.x).abs.toLong + 1L) * ((p1.y - p2.y).abs.toLong + 1L)
                (p1 = p1, p2 = p2, area = area)
        .toSeq.sortBy(-_.area)
        .collectFirst:
            case (p1, p2, area) if isValidRectangle(p1.x, p2.x, p1.y, p2.y) => area
        .get
end part2

@main def main() =
    println(part1())
    println(part2())
end main