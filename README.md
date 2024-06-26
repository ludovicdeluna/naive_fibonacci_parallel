# Unoptimized Fibonacci, parallel work on 8 languages

This test perform a **parallel work** through a simple model (**async/future**)
with a naive and unoptimized approach (**recursive call**) that simulate what
you should get with a first implementation on programming languages:

- C++ (gnu compiler g++ 11.4.0)
- Java (OpenJdk 21.0.2)
- Go (1.17)
- Julia (1.6.x)
- C# (.Net8 on Mono)
- Dart (3.3.4 with JIT VM and with AOT)
- Elixir 1.12 (with JIT)
- Ruby (3.x with Ractors instead of Ruby Threads)

3 dynamic languages (Julia, Elixir, Ruby) / 5 static languages (C++, Java, Dart, Go, C#).

> Objective was: run in parallel 2 Fibonacci calculations with exact same inputs
> and show the result on the screen.

Constraints was to use the same algorithm on the 6 languages (without perf
tricks) and limit myself to the standard library for parallel work. The hardware
has 6 physicals cores with 2 pipes each (lead to 12 cores at OS level). OS is
Linux (kernel 5.x).

Questions for me was:

- How it's simple to get the job done without expertise knowledge?
- Can we use parallel work easily with modern models like async/future?
- What kind of performance for each language in this scenario?

The resulting algorithm use 2 threads for computation + 1 main thread to
synchronize the result at display.

Results with a Fibonacci of **50**:

## C++ ~ 20 seconds

  ([source](./async_fib.cpp))

    g++ -O2 -pthread async_fib.cpp -o async_fib
    time ./async_fib

    Worker 1 started!
    Worker 2 started!
    Worker 2 finished!
    Worker 1 finished!
    Fibonacci worker 1 = 20365011074, workder 2 = 20365011074
    Program done. Exit.

    real    0m20,539s
    user    0m41,053s
    sys     0m0,004s

## C# ~ 37 seconds

  ([source](./AsyncFib.cs))

    dotnet build -c Release
    time dotnet bin/Release/net8.0/async_fib.dll

    Worker 2 started!
    Worker 1 started!
    Worker 2 finished!
    Worker 1 finished!
    Fibonacci worker 1 = 20365011074, worker 2 = 20365011074
    Program done. Exit.

    real    0m37,702s
    user    1m15,295s
    sys     0m0,021s

## Java ~ 44 seconds

([source](./FibJava.java))

    javac FibJava.java
    time java FibJava

    worker 2 started!
    worker 1 started!
    Result worker 1: 20365011074
    Result worker 2: 20365011074
    Program done. Exit.

    real    0m43,970s
    user    1m27,834s
    sys     0m0,040s

## Dart VM with JIT ~ 49 seconds

  ([source](./async_fib.dart))

  > This code can run with AOT (see bellow)

    time dart run async_fib.dart

    Worker 1 started!
    Worker 2 started!
    Worker 1 finished!
    Worker 2 finished!
    Result Worker 1 = 20365011074, Worker 2 = 20365011074
    Program done. Exit.

    real    0m49,387s
    user    1m38,402s
    sys     0m0,074s

## Go ~ 50 seconds

  ([source](./fib_go.go))

    go build fib_go.go

    time ./fib_go
    Start Worker 2
    Start Worker 1
    Worker 1 finished
    Worker 2 finished
    Result Worker 1 = 20365011074, Worker 2 = 20365011074

    real	0m50,710s
    user	1m41,356s
    sys	0m0,008s

## Julia ~ 55 seconds

  ([source](./fib_julia.jl))

    time julia -t2 fib_julia.jl
    Started with 2 threads
    Worker 1 started!
    Worker 2 started!
    Worker 2 finished!
    Worker 1 finished!
    Fibonacci worker 1 = 20365011074, worker 2 = 20365011074
    Program done. Exit.

    real	0m54,917s
    user	1m49,747s
    sys	0m0,581s

## Dart AOT ~ 1 minute

  > Same code as above, but with AOT compilation.

  ([source](./async_fib.dart))

    dart compile exe async_fib.dart -o async_fib
    time ./async_fib

    Worker 1 started!
    Worker 2 started!
    Worker 2 finished!
    Worker 1 finished!
    Result Worker 1 = 20365011074, Worker 2 = 20365011074
    Program done. Exit.

    real    1m15,381s
    user    2m30,728s
    sys     0m0,016s

## Elixir with JIT ~ 2 minutes

  ([source](./fib_elixir.exs))

    time elixir fib_elixir.exs
    worker_1 started!
    worker_2 started!
    worker_2 finished!
    worker_1 finished!
    Fibonacci worker 1 = 20365011074, worker 2 = 20365011074
    Program done. Exit.

    real	2m8,659s
    user	4m15,778s
    sys	0m0,070s


## Ruby ~ 16 minutes (JIT disabled)

  ([source](./fib_ruby.rb))

    time ruby fib_ruby.rb
    Worker 1 started!
    Worker 2 started!
    Worker 2 finished!
    Worker 1 finished!
    Fibonacci worker 1 = 20365011074, worker 2 = 20365011074
    Program done. Exit.

    real	16m4,214s
    user	31m51,984s
    sys	0m0,028s


## Notes

Ruby is my first implementation. Code is simple but on iteration 50, the time
spent is really too long (insanely long). I've tried the JIT, but it hurt the
perf more than it help. For my main programming language, I was a little
disappointed. The good news is we can do multi-core processing with Ractor now.

Go is my second implementation. Written blindly because I play with it since
years. No difficult in Go, the compilation is very fast and its speed is almost
correct. I fall shortly on C style with Go, but the core primitives are simple
and powerful.

The C++ version was surprisingly easy to write. Modern C++ make things -- like
parallel work -- a breeze. As 2021, memory safety is an ongoing topic which
dramatically impact the way applications are built. But this don't matter for
this simple test. The only diffuclt was the missing -pthread option resulting in
a strange failure... Quickly fixed, thanks Google.

Julia is as simple to write as Ruby (perhaps more approchable for newcomers).
For a dynamic language, with type hint if you want, its speed is incredible!
Very close to Go. A seriouse solution for scripting with performance.

Elixir is not new to me. It share a lot of concepts with Go. This is the reason
I use the same approach for Go and Elixir. Call it Channel in Go, or Mailbox in
Elixir, they are the same. Go Routine = Erlang process... Not as fast as Go but
really efficient. At scale, Elixir provide better concurrency schemes for long
processing in a completely safe way, and a good support for distributed
computing.

C# was my first crush 20 years ago (I hate Java from day one). I love it, but
found Microsoft badly promote it outside the Microsoft lands... And try to hook
potential users to MS licence quickly (even today at the era of Dotnet 5/6). So
bad! Having said that, C# is deadly simple and well designed. No difficult.
Documentation from MS is useful and accessible, but I confused the use of
async/await with the purpose of "Task" class for a time.


## Aside note

I wanted to write a NodeJS version, but the tool is definitely not designed for
such a task. The way it perform CPU bound processing recall me how Ruby work on
this area... Badly. For I/O bound, this is the opposite: NodeJS can do a
wonderful work. But it's not what I experiment today. For just my asking on
performance, the result with one thread:

### Javascript v8 ~ 2 minutes

NodeJS 16.10 on Linux.

  ([source](./fib_javascript.js))

    time node fib_javascript.js
    Fibonacci:  20365011074

    real	2m10,367s
    user	2m10,367s
    sys	0m0,004s

### Javascript v8 ~ 20 minutes (JIT disabled)

This result of Javascript is in the middle of intepreted programming language
having JIT support. What happen if I disable the JIT of NodeJS? (possible since
2019 to open v8 on TVs)

    time node --jitless fib_javascript.js

    Warning: disabling flag --expose_wasm due to conflicting flags
    Warning: disabling flag --regexp_tier_up due to conflicting flags

    Fibonacci:  20365011074

    real	19m53,465s
    user	19m53,481s
    sys	0m0,008s

This last test is perhaps not really faire.
