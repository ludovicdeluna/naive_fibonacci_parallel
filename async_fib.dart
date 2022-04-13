import 'dart:async';
import 'dart:isolate';

Future<void> main(List<String> args) async {
  final Future<int> result1 = run_fib(1, 50);
  final Future<int> result2 = run_fib(2, 50);

  print("Result Worker 1 = ${await result1}, Worker 2 = ${await result2}");
  print("Program done. Exit.");
}

class FibParameters {
  int name;
  int n;
  SendPort messagesIn;

  FibParameters(this.name, this.n, this.messagesIn);
}

Future<int> run_fib(int name, int n) async {
  final messagesOut = ReceivePort();

  await Isolate.spawn((FibParameters params) {
    print("Worker ${params.name} started!");
    int result = fib(params.n);
    print("Worker ${params.name} finished!");
    Isolate.exit(params.messagesIn, result);
  }, FibParameters(name, n, messagesOut.sendPort));

  return await messagesOut.first as int;
}

int fib(int n) {
  if (n <= 1) {
    return 1;
  } else {
    return fib(n - 1) + fib(n - 2);
  }
}
