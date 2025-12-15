package adventofcode.day02

def input(isExample: Boolean) =
    val inputFile = if isExample then "example.txt" else "input.txt"
    scala.io.Source.fromFile(inputFile)
        .mkString
        .split(",")
        .map:
            case s"$min-$max" => min.trim().toLong to max.trim().toLong
        .toSeq
end input

def part1(isExample: Boolean = false) = 
    input(isExample)
        .flatMap: range =>
            range.filter: i =>
                val iStr = i.toString()
                iStr.length() % 2 == 0 && iStr.grouped(iStr.length() / 2).distinct.length == 1
        .sum
end part1

def part2(isExample: Boolean = false) =
    input(isExample)
        .flatMap: range =>
            range.filter: i =>
                val iStr = i.toString()
                (1 to iStr.length()/2)
                    .exists: d =>
                        iStr.length() % d == 0 && iStr.grouped(d).distinct.length == 1
        .sum
end part2

@main def main() =
    println(part1())
    println(part2())
end main