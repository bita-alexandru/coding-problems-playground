package adventofcode.day12

import scala.util.matching.Regex

def input(isExample: Boolean) =
    val inputFile = if isExample then "example.txt" else "input.txt"
    scala.io.Source.fromFile(inputFile)
        .mkString
        .split("\\R{2}")
        .toSeq match
            case parts =>
                val (shapesPart, regionsParts) = parts.splitAt(parts.length - 1)
                (
                    shapes = shapesPart.map: shapePart =>
                        shapePart.strip.split("\\R").toSeq.splitAt(1) match
                            case (Seq(index), shape) => (index.split(":")(0).toInt, shape)
                            case _ => ???
                    .toMap,
                    regions = regionsParts.flatMap: regionsPart =>
                        val regionRegex = """^(\d+)x(\d+): (.*)$""".r
                        regionsPart.split("\\R").toSeq.map: 
                            case regionRegex(w, h, reqs) =>
                                (
                                    dims = (w = w.toInt, h = h.toInt),
                                    reqs = reqs.split("\\s+").toSeq.map(_.toInt)
                                )
                )
        end match
end input

def part1(isExample: Boolean = false) =
    input(isExample).regions.count: region =>
        region.reqs.map(_ * 9).sum <= region.dims.w * region.dims.h

end part1

@main def main() =
    println(part1())
end main