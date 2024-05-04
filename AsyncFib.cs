using System;
using System.Threading.Tasks;

class AsyncFib
{
    static void Main(string[] args)
    {
        var t1 = Task.Run(() => RunFib(50, "1"));
        var t2 = Task.Run(() => RunFib(50, "2"));

        Task.WaitAll(t1, t2);
        Console.WriteLine($"Fibonacci worker 1 = {t1.Result}, worker 2 = {t2.Result}");
        Console.WriteLine("Program done. Exit.");
    }

    public static long RunFib(int n, string name)
    {
        Console.WriteLine($"Worker {name} started!");
        long result = Fib(n);
        Console.WriteLine($"Worker {name} finished!");
        return result;
    }

    public static long Fib(long n)
    {
        if (n <= 1)
        {
            return 1;
        }
        else
        {
            return Fib(n - 1) + Fib(n - 2);
        }
    }
}
