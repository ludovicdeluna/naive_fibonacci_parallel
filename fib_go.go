package main

import "fmt"

type fib_value int64              // Will be a big number above 50 iterations (> 2147483648)
type fib_message chan (fib_value) // Channel with result of computation.

func main() {
	workers := map[string]fib_message{
		"Worker 1": make(fib_message),
		"Worker 2": make(fib_message),
	}

	for name, channel := range workers {
		go RunFib(50, name, channel)
	}

	fmt.Printf(
		"Result Worker 1 = %d, Worker 2 = %d\n",
		<-workers["Worker 1"],
		<-workers["Worker 2"],
	)
}

func RunFib(n int, name string, c fib_message) {
	fmt.Println("Start", name)
	c <- Fib(fib_value(n))
	fmt.Println(name, "finished")
}

func Fib(n fib_value) fib_value {
	if n <= 1 {
		return 1
	} else {
		return Fib(n-1) + Fib(n-2)
	}
}
