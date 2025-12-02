package adventofcode.day02

import scala.io.Source
import java.io.File
import scala.annotation.tailrec

def input(isExample: Boolean) =
    val inputFile = if isExample then "example.txt" else "input.txt"
    Source.fromFile(new File(inputFile))
        .mkString
        .split(",")
        .map:
            case s"$min-$max" => (min.trim(), max.trim())
        .toList
end input

def part1(isExample: Boolean = false) = 
    @tailrec
    def sumInvalid(curr: String, min: String, max: String, sum: Long = 0): Long =
        if curr.toLong > max.toLong || curr.toLong < min.toLong then
            sum
        else if curr.length() % 2 == 1 then
            val newCurr = math.pow(10, curr.length()).intValue.toString()
            sumInvalid(newCurr, min, max, sum)
        else
            val (leftHalf, rightHalf) = curr.splitAt(curr.length()/2)
            val newLeftHalf = leftHalf.toLong + 1
            val newCurr = s"$newLeftHalf$newLeftHalf"
            val invalidId = s"$leftHalf$leftHalf"
            if invalidId.toLong > max.toLong || invalidId.toLong < min.toLong then
                sumInvalid(newCurr, min, max, sum)
            else
                sumInvalid(newCurr, min, max, sum + invalidId.toLong)
    end sumInvalid

    input(isExample)
        .map:
            (min, max) => sumInvalid(min, min, max)
        .sum
end part1

def part2(isExample: Boolean = false) =
    input(isExample)
        .map: (minStr, maxStr) =>
            val minVal = minStr.toLong
            val maxVal = maxStr.toLong
            val candidates =
                for 
                    len <- minStr.length to maxStr.length
                    p <- 1 to len / 2
                    if len % p == 0
                yield
                    val startRootBase = math.pow(10, p - 1).toLong
                    val endRoot = math.pow(10, p).toLong - 1
                    val startRoot = 
                        if len == minStr.length then 
                            math.max(startRootBase, minStr.take(p).toLong) 
                        else startRootBase

                    (startRoot until endRoot + 1)
                        .map(root => (root.toString * (len / p)).toLong)
                        .takeWhile(_ <= maxVal)
                        .filter(_ >= minVal)
                        .toList
                end for
            candidates.flatten.distinct
        .flatten
        .sum
end part2

@main def main() =
    println(part1())
    println(part2())
end main