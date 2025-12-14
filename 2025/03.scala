package adventofcode.day03

def input(isExample: Boolean) =
    val inputFile = if isExample then "example.txt" else "input.txt"
    scala.io.Source.fromFile(inputFile)
        .getLines()
        .map(_.zipWithIndex)
        .toSeq
end input

def part1(isExample: Boolean = false) = 
    input(isExample)
        .map: bank =>
            val bankSortedDropLast = bank.dropRight(1).sortBy((value, pos) => -value.toInt)
            bank.sortBy((value, pos) => -value.toInt)
                .filter(_._2 >= bankSortedDropLast.head._2)
                .take(2)
                .sortBy((value, pos) => pos)
                .map(_._1)
                .mkString
                .toInt        
        .sum
end part1

def part2(isExample: Boolean = false) =
    input(isExample)
        .map: bank =>
            val bankSortedDropLast = bank.dropRight(11).sortBy((value, pos) => -value.toInt)
            val bankSorted = bank.sortBy((value, pos) => -value.toInt)
            val bankLength = bank.length
            (1 to 11).foldLeft(List(bankSortedDropLast.head)): (acc, curr) =>
                bankSorted.collectFirst:
                    case element if element._2 > acc.head._2 && bankLength - element._2 >= 12 - acc.length =>
                        element
                .get :: acc
            .sortBy((value, pos) => pos)
            .map(_._1)
            .mkString
            .toLong 
        .sum
end part2

@main def main() =
    println(part1())
    println(part2())
end main