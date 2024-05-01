import java.util.Arrays;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executors;

class FibJava {
  public static void main(String[] _args) {
    var runners = new Fibonacci[] {
      new Fibonacci("worker 1"),
      new Fibonacci("worker 2")
    };

    final var executor = Executors.newVirtualThreadPerTaskExecutor();
    try (executor) {
      var futures = Arrays.stream(runners).map(runner -> {
        return executor.submit(() -> runner.run());
      }).toList();

      for (var future : futures) {
        Fibonacci runner = future.get();
        System.out.printf("Result %s: %d\n", runner.workerName, runner.result);
      }
    } catch (InterruptedException | ExecutionException _getError) {
      System.out.println("Workers interrupted");
      System.exit(1);
    } // call shutdown() on executor when finished
    System.out.println("Program done. Exit.");
  }
}

class Fibonacci {
  public final String workerName;
  public long result;

  Fibonacci(String name) {
    workerName = name;
  }

  Fibonacci run() {
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
