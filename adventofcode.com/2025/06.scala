package adventofcode.day06

def input(isExample: Boolean) =
    val inputFile = if isExample then "example.txt" else "input.txt"
    scala.io.Source.fromFile(inputFile)
        .getLines()
        .map(_.toSeq)
        .toSeq
        .reverse match
            case ops +: numbers => (ops, numbers.reverse)
end input

def part1(isExample: Boolean = false) =
    val (ops, numbers) = input(isExample) match
        case (ops, numbers) =>
            (
                ops.toString.split("\\s+").filter(_.strip().nonEmpty),
                numbers.map(_.toString.split("\\s+").filter(_.strip().nonEmpty).map(_.toLong))
            )
    numbers.transpose.foldLeft((total = 0L, i = 0)): (acc, elements) =>
        ops(acc.i) match
            case "+" => (acc.total + elements.sum, acc.i + 1)
            case "*" => (acc.total + elements.product, acc.i + 1)
    .total
end part1

def part2(isExample: Boolean = false) =
    val (ops, numbers) = input(isExample) match
        case (ops, numbers) =>
            (
                ops.toString.split("\\s+").filter(_.strip().nonEmpty),
                numbers.transpose.map(_.mkString.strip())
            )
    numbers.foldLeft((total = 0L, opPos = 0, numPos = 0, prevNums = Seq[Long]().empty)): (acc, numStr) =>
        val numLong = numStr.toLongOption.getOrElse(if ops(acc.opPos) == "+" then 0L else 1L)
        if acc.numPos == numbers.length - 1 || numStr.isBlank then
            ops(acc.opPos) match
                case "+" =>
                    (acc.total + (numLong +: acc.prevNums).sum, acc.opPos + 1, acc.numPos + 1, Seq[Long]().empty)
                case "*" =>
                    (acc.total + (numLong +: acc.prevNums).product, acc.opPos + 1, acc.numPos + 1, Seq[Long]().empty)
        else (acc.total, acc.opPos, acc.numPos + 1, numLong +: acc.prevNums)
    .total
end part2

@main def main() =
    println(part1())
    println(part2())
end main