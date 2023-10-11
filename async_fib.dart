import 'dart:async';
import 'dart:isolate';

class FibParameters {
  final int name;
  final int n;
  final SendPort messagesIn;

  const FibParameters(this.name, this.n, this.messagesIn);
}

void main(List<String> args) {
  final fib_value = 50;
  final Future<int> worker1 = run_fib(1, fib_value);
  final Future<int> worker2 = run_fib(2, fib_value);

  // Register Event Listener to trigger worker1/worker2 answers
  Future.wait([worker1, worker2]).then((List<int> results) {
    print("Result Worker 1 = ${results[0]}, Worker 2 = ${results[1]}");
    print("Program done. Exit.");
  });

  print("Main body completed. Waiting from Reactor now...");
}

Future<int> run_fib(int name, int n) async {
  // Set a Receive Port to buffer incoming messages on this main Isolate
  final messagesOut = ReceivePort();

  // Start Isolate. Pass a dedicated Send Port for communication
  await Isolate.spawn((FibParameters params) {
    print("Worker ${params.name} started!");
    int result = fib(params.n);
    print("Worker ${params.name} finished!");

    // Send answer to the main Isolate (here, a move action)
    Isolate.exit(params.messagesIn, result);
  }, FibParameters(name, n, messagesOut.sendPort));

  // Wait the Receive Port to get one message
  return await messagesOut.first as int;
}

int fib(int n) {
  if (n <= 1) {
    return 1;
  } else {
    return fib(n - 1) + fib(n - 2);
  }
}
