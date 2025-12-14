package adventofcode.day08

import scala.annotation.tailrec
import scala.math.{pow, sqrt}

case class Point(x: Int, y: Int, z: Int)
case class Edge(p1: Point, p2: Point, dist: Double)

case class DisjointSet(
    parents: Map[Point, Point],
    sizes: Map[Point, Int],
    clusterCount: Int
):
    @tailrec
    private def find(p: Point): Point =
        val parent = parents(p)
        if parent == p then p else find(parent)
    end find

    def union(p1: Point, p2: Point): DisjointSet =
        val root1 = find(p1)
        val root2 = find(p2)
        if root1 != root2 then
            val newParents = parents.updated(root2, root1)
            val newSizes = sizes.updated(root1, sizes(root1) + sizes(root2)) - root2
            copy(parents = newParents, sizes = newSizes, clusterCount = clusterCount - 1)
        else
            this
    end union
end DisjointSet

object DisjointSet:
    def fromPoints(points: Seq[Point]): DisjointSet =
        DisjointSet(
            parents = points.map(p => p -> p).toMap,
            sizes = points.map(p => p -> 1).toMap,
            clusterCount = points.size
        )
    end fromPoints
end DisjointSet

def input(isExample: Boolean): (Seq[Point], Seq[Edge]) =
    val inputFile = if isExample then "example.txt" else "input.txt"
    val points = scala.io.Source.fromFile(inputFile)
        .getLines()
        .map: line => 
            val Array(x, y, z) = line.split(",").map(_.trim.toInt)
            Point(x, y, z)
        .toSeq
    val edges = points.combinations(2)
        .map:
            case Seq(a, b) =>
                val dist = sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2) + pow(a.z - b.z, 2))
                Edge(a, b, dist)
        .toSeq
        .sortBy(_.dist)
    (points, edges)
end input

def part1(isExample: Boolean = false) =
    val (points, allEdges) = input(isExample)
    val limit = if isExample then 10 else 1000
    val initialDS = DisjointSet.fromPoints(points)

    allEdges.take(limit).foldLeft(initialDS): (ds, edge) =>
        ds.union(edge.p1, edge.p2)
    .sizes.values.toSeq
    .sortBy(-_)
    .take(3)
    .product
end part1

def part2(isExample: Boolean = false) =
    val (points, allEdges) = input(isExample)
    val initialDS = DisjointSet.fromPoints(points)

    @tailrec
    def recurse(edges: List[Edge], currentDS: DisjointSet): Long =
        edges match
            case Nil => 0L
            case edge :: rest =>
                val nextDS = currentDS.union(edge.p1, edge.p2)
                if nextDS.clusterCount == 1 then
                    edge.p1.x.toLong * edge.p2.x.toLong
                else
                    recurse(rest, nextDS)
    end recurse
    recurse(allEdges.toList, initialDS)
end part2

@main def main() =
    println(part1())
    println(part2())
end main