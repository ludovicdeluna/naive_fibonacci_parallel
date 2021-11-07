# run with: julia -t2 fib_julia.jl
function run_fib(n, name)
    println("$(name) started!")
    result = fib(n)
    println("$(name) finished!")
    result
end

function fib(n)
    if n <= 1
        1
    else
        fib(n - 1) + fib(n - 2)
    end
end

println("Started with $(Threads.nthreads()) threads")

input = 50

worker1 = Threads.@spawn run_fib(input, "Worker 1")
worker2 = Threads.@spawn run_fib(input, "Worker 2")

result1 = fetch(worker1)
result2 = fetch(worker2)

println("Fibonnacy worker 1 = $(result1), worker 2 = $(result2)")
println("Program done. Exit.")
