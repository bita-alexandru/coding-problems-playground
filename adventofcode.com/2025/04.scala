package adventofcode.day04

def input(isExample: Boolean) =
    val inputFile = if isExample then "example.txt" else "input.txt"
    scala.io.Source.fromFile(inputFile)
        .getLines()
        .map(_.strip())
        .toSeq
end input

def part1(isExample: Boolean = false) = 
    val diagram = input(isExample)
    val rollsSet = { 
        for i <- 0 until diagram.length
            j <- 0 until diagram(0).length
            if diagram(i)(j) == '@'
        yield (i, j)
    }.toSet

    rollsSet.filter: (i, j) =>
        Seq((-1, 0), (-1, 1), (0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (-1, -1))
            .map: (di, dj) =>
                rollsSet.contains((di + i, dj + j)).compareTo(false)
            .sum < 4
    .size
end part1

def part2(isExample: Boolean = false) =
    val diagram = input(isExample)
    val rollsSet = { 
        for i <- 0 until diagram.length
            j <- 0 until diagram(0).length
            if diagram(i)(j) == '@'
        yield (i, j)
    }.toSet

    Iterator.iterate(rollsSet): currRolls =>
        currRolls.filter: (i, j) =>
            Seq((-1, 0), (-1, 1), (0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (-1, -1))
                .map: (di, dj) =>
                    currRolls.contains((di + i, dj + j)).compareTo(false)
                .sum >= 4
    .sliding(2)
    .collectFirst:
        case Seq(prev, curr) if prev.size == curr.size => curr.size
    .get
    .-(rollsSet.size)
    .abs
end part2

@main def main() =
    println(part1())
    println(part2())
end main