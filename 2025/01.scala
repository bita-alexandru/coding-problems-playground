package adventofcode.day01

def input(isExample: Boolean) =
    val inputFile = if isExample then "example.txt" else "input.txt"
    scala.io.Source.fromFile(inputFile)
        .getLines()
        .map:
            case s"L$rotation" => -rotation.toInt
            case s"R$rotation" => rotation.toInt
        .toSeq
end input

def part1(isExample: Boolean = false) = 
    input(isExample)
        .scanLeft(50): (acc, rotation) =>
            math.floorMod(acc + rotation, 100)
        .count(_ == 0)
end part1

def part2(isExample: Boolean = false) =
    input(isExample)
        .flatMap: rotation =>
            Seq.fill(rotation.abs)(rotation.sign)
        .scanLeft(50): (acc, rotation) =>
            math.floorMod(acc + rotation, 100)
        .count(_ == 0)
end part2

@main def main() =
    println(part1())
    println(part2())
end main