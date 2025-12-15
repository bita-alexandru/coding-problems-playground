package adventofcode.day10

def input(isExample: Boolean) =
    val inputFile = if isExample then "example.txt" else "input.txt"
    scala.io.Source.fromFile(inputFile)
        .getLines()
        .map: line =>
            val parts = line.split(" ").toSeq
            val targetMask = parts.head.drop(1).dropRight(1).zipWithIndex.foldLeft(0L): 
                case (acc, (c, i)) => if c == '#' then acc | (1L << i) else acc
            val buttonIndices = parts.slice(1, parts.length - 1).map: schema =>
                schema.drop(1).dropRight(1).split(",").map(_.toInt)
            val buttonMasks = buttonIndices.map(_.foldLeft(0L)((acc, n) => acc | (1L << n)))
            val buttons = buttonIndices.zip(buttonMasks).map(button => (indices = button._1, mask = button._2))
            val joltages = parts.last.drop(1).dropRight(1).split(",").map(_.trim.toInt).toSeq
            (targets = targetMask, buttons = buttons, joltages = joltages)
        .toSeq
end input

def part1(isExample: Boolean = false) =
    input(isExample).map: (target, buttons, _) =>
        (1 to buttons.length).find: k => 
            buttons.map(_.mask).combinations(k).exists(_.foldLeft(0L)(_ ^ _) == target)
        .getOrElse(0)
    .sum
end part1

def part2(isExample: Boolean = false) =
    val INF = 1_000_000L

    input(isExample).map:
        case (_, buttons, joltages) =>
            val buttonMasks = buttons.map(_.mask)
            val buttonIndices = buttons.map(_.indices)

            val n = joltages.length
            val allSubsets =
                (0 to buttonMasks.length).flatMap: k =>
                    buttonMasks.indices.combinations(k).map: idxs =>
                        val xorMask = idxs.foldLeft(0L)((acc, i) => acc ^ buttonMasks(i))
                        val delta = Array.fill(n)(0)
                        idxs.foreach(i => buttonIndices(i).foreach(delta(_) += 1))
                        (xorMask, delta.toSeq, k)
            .toSeq

            val memo = scala.collection.mutable.Map[Seq[Int], Long]()
            def f(v: Seq[Int]): Long =
                memo.getOrElseUpdate(v, {
                    if v.forall(_ == 0) then 0L
                    else if v.exists(_ < 0) then INF
                    else
                        val target = v.zipWithIndex.foldLeft(0L):
                            case (acc, (x, i)) => if (x & 1) == 1 then acc | (1L << i) else acc
                        var best = INF

                        allSubsets.foreach:
                            case (mask, delta, k) =>
                                if mask == target then
                                    val reduced = v.indices.map(i => v(i) - delta(i))
                                    if reduced.forall(x => x >= 0 && (x & 1) == 0) then
                                        val next = reduced.map(_ >> 1)
                                        best = math.min(best, 2 * f(next) + k)
                        best
                    end if
                })
            end f

            f(joltages)
    .sum
end part2

@main def main() =
    println(part1())
    println(part2())
end main