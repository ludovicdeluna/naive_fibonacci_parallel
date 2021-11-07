// Compile with: g++ -pthread async_fib.cpp -o async_fib
#include <iostream>
#include <thread>
#include <future>

// Header
long fib(long);
long fibrun(int, std::string);

// Program
// Don't use namespace for now (because beginer)
//    using namespace std;

int main()
{
  int input = 50;

  auto worker1 = std::async(fibrun, input, "Worker 1");
  auto worker2 = std::async(fibrun, input, "Worker 2");

  long result1 = worker1.get();
  long result2 = worker2.get();

  std::cout
    << "Fibonacci worker 1 = " << result1
    << ", workder 2 = " << result2
    << std::endl;

  std::cout << "Program done. Exit." << std::endl;
  return 0;
}

long fib(long n)
{
  if (n <= 1) {
    return 1;
  } else {
    return fib(n-1) + fib(n-2);
  }
}

long fibrun(int n, std::string name)
{
  std::cout << name << " started!" << std::endl;
  long result = fib(n);
  std::cout << name << " finished!" << std::endl;
  return result;
}
