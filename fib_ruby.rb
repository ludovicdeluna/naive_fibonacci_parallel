# Remove warning on experimental functions (Ractor)
Warning[:experimental] = false

module Calculator
  def self.run_fib(input, worker_name)
    puts "#{worker_name} started!"
    fib(input).tap { puts "#{worker_name} finished!" }
  end

  def self.fib(n)
    if n <= 1
      1
    else
      fib(n - 1) + fib(n - 2)
    end
  end
end

input = 50

w1 = Ractor.new(input) { Calculator.run_fib(_1, "Worker 1") }
w2 = Ractor.new(input) { Calculator.run_fib(_1, "Worker 2") }

puts "Fibonacci worker 1 = #{w1.take}, worker 2 = #{w2.take}"
puts "Program done. Exit."
