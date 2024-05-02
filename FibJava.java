import java.util.*;
import java.util.concurrent.*;

class FibJava {
  public static void main(String[] _args) {
    List<Future<Fibonacci>> futures;

    try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
      var runners = new Fibonacci[] {
          new Fibonacci("worker 1"),
          new Fibonacci("worker 2")
      };

      futures = Arrays.stream(runners)
          .map(runner -> executor.submit(runner))
          .toList();
    } // call shutdown() on the executor when this block has been processed

    try {
      for (var future : futures) {
        Fibonacci runner = future.get();
        System.out.printf("Result %s: %d\n", runner.workerName, runner.result);
      }
    } catch (InterruptedException | ExecutionException _getError) {
      System.out.println("Workers interrupted");
      System.exit(1);
    }

    System.out.println("Program done. Exit.");
  }
}

class Fibonacci implements Callable<Fibonacci> {
  public final String workerName;
  public long result;

  Fibonacci(String name) {
    workerName = name;
  }

  public Fibonacci call() {
    System.out.printf("%s started!\n", workerName);
    result = Fibonacci.fib(50L);

    return this;
  }

  static long fib(long n) {
    if (n <= 1L) {
      return 1L;
    }

    return fib(n - 1L) + fib(n - 2L);
  }
}
