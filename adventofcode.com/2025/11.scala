package adventofcode.day11

def input(isExample: Boolean) =
    val inputFile = if isExample then "example.txt" else "input.txt"
    scala.io.Source.fromFile(inputFile)
        .getLines()
        .foldLeft(Map[String, Seq[String]]().empty): (acc, line) =>
            val parts = line.split(":?\\s+").toSeq
            val (device, links) = (parts.head, parts.tail)
            acc + (device -> links)
end input

def part1(isExample: Boolean = false) =
    val rack = input(isExample)

    Iterator.iterate((Seq(("you", Set("you"))), 0)): (queue, count) =>
        val nextStep = queue.flatMap: (currentDevice, visited) =>
            rack.getOrElse(currentDevice, Seq.empty).map: neighbor =>
                (neighbor, visited, currentDevice)
        val (reachedOut, continuing) = nextStep.partition(_._1 == "out")
        val nextQueue = continuing.collect:
            case (device, visited, _) if !visited.contains(device) =>
                (device, visited + device)
        (nextQueue, count + reachedOut.size)
    .dropWhile(_._1.nonEmpty) 
    .next()
    ._2
end part1

def part2(isExample: Boolean = false) =
    val rack = input(isExample)
    
    def countPaths(from: String, target: String, blocked: Set[String]) =
        val memo = collection.mutable.Map[String, Long]()

        def dfs(current: String): Long =
            if current == target then 1L
            else if memo.contains(current) then memo(current)
            else
                val paths = rack.getOrElse(current, Seq.empty)
                    .filterNot(blocked.contains)
                    .map(dfs)
                    .sum
                memo(current) = paths
                paths
        end dfs

        dfs(from)
    end countPaths

    countPaths("svr", "fft", Set("dac", "out")) *
        countPaths("fft", "dac", Set("svr", "out")) *
            countPaths("dac", "out", Set("svr", "fft")) +
    countPaths("svr", "dac", Set("fft", "out")) * 
        countPaths("dac", "fft", Set("svr", "out")) *
            countPaths("fft", "out", Set("svr", "dac"))
end part2

@main def main() =
    println(part1())
    println(part2())
end main