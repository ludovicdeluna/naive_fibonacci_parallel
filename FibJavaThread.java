import java.util.Arrays;

class FibJava {
  public static void main(String[] _args) {
    var runners = new FibRunnable[] {
        new FibRunnable("worker 1"),
        new FibRunnable("worker 2")
    };

    thread_all(runners);

    for (var runner : runners) {
      System.out.printf("Result %s: %d\n", runner.workerName, runner.get());
    }

    System.out.println("Program done. Exit.");
  }

  static void thread_all(FibRunnable... runners) {
    Thread[] threads = Arrays.stream(runners)
        .map(runner -> new Thread(runner))
        .peek(thread -> thread.start())
        .toArray(Thread[]::new);

    try {
      for (var thread : threads) {
        thread.join();
      }
    } catch (InterruptedException e) {
      System.out.println("Workers interrupted");
      System.exit(1);
    }
  }
}

class FibRunnable implements Runnable {
  public final String workerName;
  private long result = 0;

  FibRunnable(String name) {
    this.workerName = name;
  }

  @Override
  public void run() {
    System.out.printf("%s started!\n", workerName);
    this.result = FibRunnable.fib(50L);
  }

  public synchronized long get() {
    return result;
  }

  static long fib(long n) {
    if (n <= 1L)
      return 1L;
    return fib(n - 1L) + fib(n - 2L);
  }
}
