package leetcode.com.two_sum

object Solution {
    def twoSum(nums: Array[Int], target: Int): Array[Int] = {
        val numsMap = nums.zipWithIndex
            .groupMapReduce(_._1)(Array(_))((a, b) => a ++ b)
        (0 until nums.length).iterator
            .flatMap { i =>
                numsMap.get(target - nums(i))
                    .flatMap(_.find(_._2 != i))
                    .map { case (_, j) => Array(i, j) }
            }
        .next()
    }
}

@main def main() = {
    Seq(
        Solution.twoSum(nums = Array(2,7,11,15), 9).toSeq,
        Solution.twoSum(nums = Array(3,2,4), 6).toSeq,
        Solution.twoSum(nums = Array(3,3), 6).toSeq,
    ).foreach(println)
}
