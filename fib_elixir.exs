# run with: elixir fib_elixir.exs
defmodule FibElixir do
  import IO

  def start do
    main_job = self()
    input = 50

    workers = [
      spawn(fn -> run_fib(main_job, input, :worker_1) end),
      spawn(fn -> run_fib(main_job, input, :worker_2) end)
    ]

    results = workers |> Enum.map(&__MODULE__.receive_fib_results/1)

    puts("Fibonacci worker 1 = #{results[:worker_1]}, worker 2 = #{results[:worker_2]}")
    puts("Program done. Exit.")
  end

  def run_fib(main_job, n, name) do
    puts("#{name} started!")
    send(main_job, {:fib_result, name, fib(n)})
    puts("#{name} finished!")
  end

  def fib(n) do
    if n <= 1 do
      1
    else
      fib(n - 1) + fib(n - 2)
    end
  end

  def receive_fib_results(_worker) do
    receive do
      {:fib_result, key, value} -> {key, value}
    end
  end
end

FibElixir.start()
