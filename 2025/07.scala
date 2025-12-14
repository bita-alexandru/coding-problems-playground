package adventofcode.day07

def input(isExample: Boolean) =
    val inputFile = if isExample then "example.txt" else "input.txt"
    val manifold = scala.io.Source.fromFile(inputFile)
        .getLines()
        .toSeq
    (0 until manifold.length)
        .foldLeft((iStart = Tuple2[Int, Int](0, 0), iSplitters = Set[Tuple2[Int, Int]]().empty)): (iAcc, i) =>
            val jAcc = (0 until manifold(i).length)
                .foldLeft((jStart = iAcc.iStart, jSplitters = iAcc.iSplitters)): (jAcc, j) =>
                    manifold(i)(j) match
                        case 'S' => ((i, j), jAcc.jSplitters)
                        case '^' => (jAcc.jStart, jAcc.jSplitters.incl((i, j)))
                        case _ => jAcc
            (jAcc.jStart, jAcc.jSplitters)
end input

def part1(isExample: Boolean = false) =
    val (start, splitters) = input(isExample)
    val startPos = (start._1 + 1, start._2)
    val maxDepth = splitters.maxBy(_._1)._1
    Iterator.iterate((splits = 0, points = Set(start))): acc =>
        val newSplits = acc.splits + acc.points.count(splitters.contains)
        val newPoints = acc.points.flatMap: point =>
            if splitters.contains(point) then
                Set((point._1 + 1, point._2 - 1), (point._1 + 1, point._2 + 1))
            else
                Set((point._1 + 1, point._2))
        .filter(_._1 <= maxDepth)
        (newSplits, newPoints)
    .dropWhile(_.points.nonEmpty)
    .next()
    .splits
end part1

def part2(isExample: Boolean = false) =
    val (start, splitters) = input(isExample)
    val maxDepth = splitters.maxBy(_._1)._1
    (start._1 to maxDepth).foldLeft(Map(start._2 -> 1L)): (acc, i) =>
        acc.toSeq.flatMap: (j, splits) =>
            if splitters.contains((i, j)) then
                Seq(j - 1 -> splits, j + 1 -> splits)
            else
                Seq(j -> splits)
        .groupMapReduce(_._1)(_._2)(_ + _)
    .values.sum
end part2

@main def main() =
    println(part1())
    println(part2())
end main