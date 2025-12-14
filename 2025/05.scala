package adventofcode.day05

def input(isExample: Boolean) =
    val inputFile = if isExample then "example.txt" else "input.txt"
    val Array(ranges, ids) = scala.io.Source.fromFile(inputFile)
        .mkString
        .split("\\R{2}")
    (
        ranges
            .split("\\R")
            .map:
                case s"$min-$max" => min.strip().toLong to max.strip().toLong
            .sortBy(_.start)
            .toSeq,
        ids
            .split("\\R")
            .map(id => id.strip().toLong)
            .toSeq
    )
end input

def part1(isExample: Boolean = false) = 
    val (ranges, ids) = input(isExample)
    ids
        .filter: id =>
            ranges.exists: range =>
                range.start <= id && id <= range.end
        .length
end part1

def part2(isExample: Boolean = false) =
    val (ranges, _) = input(isExample)
    ranges.foldLeft(0L to 0L, 0L): (acc, curr) =>
        val (prev, total) = acc
        val newRange = curr.start to curr.end.max(prev.end)
        if curr.start >= prev.start && curr.end <= prev.end then
            (newRange, total)
        else
            (
                newRange,
                total + curr.end - curr.start + 1
                    - (if prev.end >= curr.start then prev.end - curr.start + 1 else 0)
            )
    ._2
end part2

@main def main() =
    println(part1())
    println(part2())
end main