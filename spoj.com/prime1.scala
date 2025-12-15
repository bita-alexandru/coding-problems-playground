import scala.io.StdIn.readLine
import scala.collection.mutable.ArrayBuffer
import scala.math.sqrt

object Main extends App {
  def simpleSieve(limit: Int): Seq[Int] = {
    val isPrime = Array.fill(limit + 1)(true)
    val primes = ArrayBuffer[Int]()
    for (i <- 2 to limit if isPrime(i)) {
      primes += i
      var j = i * i
      while (j <= limit) {
        isPrime(j) = false
        j += i
      }
    }
    primes.toSeq
  }

  def segmentedSieveRange(m: Int, n: Int): Seq[Int] = {
    val limit = sqrt(n).toInt
    val smallPrimes = simpleSieve(limit)
    val size = n - m + 1
    val isPrime = Array.fill(size)(true)

    for (p <- smallPrimes) {
      var start = ((m + p - 1) / p) * p
      if (start < p * 2) start = p * 2
      for (j <- start to n by p) {
        isPrime(j - m) = false
      }
    }

    if (m == 1) isPrime(0) = false

    for (i <- isPrime.indices if isPrime(i)) yield m + i
  }

  val t = readLine().toInt
  for (_ <- 1 to t) {
    val Array(m, n) = readLine().split(" ").map(_.toInt)
    segmentedSieveRange(m, n).foreach(println)
  }
}
