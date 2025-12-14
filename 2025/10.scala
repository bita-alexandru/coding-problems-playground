package adventofcode.day10

def input(isExample: Boolean) =
    val inputFile = if isExample then "example.txt" else "input.txt"
    scala.io.Source.fromFile(inputFile)
        .getLines()
        .map: line =>
            val parts = line.split(" ").toSeq
            val targetMask = parts.head.drop(1).dropRight(1).zipWithIndex.foldLeft(0L): 
                case (acc, (c, i)) => if c == '#' then acc | (1L << i) else acc
            val buttonMasks = parts.slice(1, parts.length - 1).map: schema =>
                schema.drop(1).dropRight(1).split(",").foldLeft(0L): (acc, s) =>
                    acc | (1L << s.toInt)
            val targets = parts.last.drop(1).dropRight(1).split(",").map(_.trim.toInt).toSeq
            val buttons = parts.slice(1, parts.length - 1).map: schema =>
                val content = schema.drop(1).dropRight(1)
                val vec = Array.fill(targets.length)(0)
                if content.nonEmpty then
                    content.split(",").map(_.trim.toInt).foreach: idx =>
                        if idx < vec.length then vec(idx) = 1
                vec.toSeq
            (targetMask, buttonMasks, (targets, buttons))
        .toSeq
end input

def part1(isExample: Boolean = false) =
    input(isExample).map: (target, buttons, _) =>
        (1 to buttons.length).find: k => 
            buttons.combinations(k).exists(_.foldLeft(0L)(_ ^ _) == target)
        .getOrElse(0)
    .sum
end part1

def part2(isExample: Boolean = false) =
    def solveSystem(target: Seq[Int], buttons: Seq[Seq[Int]]) =
        val rows = target.length
        val cols = buttons.length
        val matrix = Array.ofDim[Double](rows, cols + 1)
        
        for c <- 0 until cols do
            for r <- 0 until rows do
                matrix(r)(c) = buttons(c)(r).toDouble
        for r <- 0 until rows do
            matrix(r)(cols) = target(r).toDouble

        var pivotRow = 0
        val pivotCols = scala.collection.mutable.ArrayBuffer[Int]()

        for col <- 0 until cols if pivotRow < rows do
            var sel = pivotRow
            while sel < rows && matrix(sel)(col).abs < 1e-9 do
                sel += 1
            
            if sel < rows then
                val tmp = matrix(pivotRow)
                matrix(pivotRow) = matrix(sel)
                matrix(sel) = tmp

                val div = matrix(pivotRow)(col)
                for c2 <- col to cols do matrix(pivotRow)(c2) /= div

                for r <- 0 until rows if r != pivotRow do
                    val factor = matrix(r)(col)
                    if factor.abs > 1e-9 then
                        for c2 <- col to cols do matrix(r)(c2) -= factor * matrix(pivotRow)(c2)

                pivotCols += col
                pivotRow += 1

        val freeCols = (0 until cols).filterNot(pivotCols.contains).toArray
        val bounds = freeCols.map: c =>
            val relevantTargets = (0 until rows).collect:
                case r if buttons(c)(r) >= 1 => target(r)
            if relevantTargets.isEmpty then 0 else relevantTargets.min

        var minPresses = Long.MaxValue
        def iterate(idx: Int, currentFreeVals: Array[Int]): Unit =
            if idx == freeCols.length then
                var currentSum = 0L
                var isValid = true
                var rowIdx = 0
                val pivotIt = pivotCols.iterator
                while isValid && pivotIt.hasNext do
                    val pCol = pivotIt.next()
                    var value = matrix(rowIdx)(cols)

                    var f = 0
                    while f < freeCols.length do
                        val fCol = freeCols(f)
                        value -= matrix(rowIdx)(fCol) * currentFreeVals(f)
                        f += 1
                    
                    if value < -1e-5 || (value.round - value).abs > 1e-5 then
                        isValid = false
                    else
                        val intVal = value.round.toInt
                        currentSum += intVal
                    
                    rowIdx += 1
                if isValid then
                    currentFreeVals.foreach(v => currentSum += v)
                    minPresses = currentSum.min(minPresses)
            else
                val c = freeCols(idx)
                for v <- 0 to bounds(idx) do
                    iterate(idx + 1, currentFreeVals :+ v)
        end iterate
        iterate(0, Array())

        minPresses
    end solveSystem

    input(isExample).map: (_, _, data) =>
        solveSystem(data._1, data._2)
    .sum
end part2

@main def main() =
    println(part1())
    println(part2())
end main