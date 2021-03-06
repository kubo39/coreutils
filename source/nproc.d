import core.sys.posix.unistd : sysconf, _SC_NPROCESSORS_CONF;
import core.stdc.stdlib : exit;
import std.conv : to;
import std.format;
import std.getopt;
import std.parallelism : totalCPUs;
import std.process : environment;
import std.stdio;
import std.string : fromStringz;

version (linux)
{
    import core.bitop : popcnt;
    import core.sys.linux.sched : sched_getaffinity, cpu_set_t;
}

enum VERSION = "0.0.1";

void main(string[] args)
{
    bool versions, all;
    ulong ignore;

    // dfmt off
    const helpInformation = args.getopt(
        std.getopt.config.caseSensitive,
        "v|version", &versions,
        "ignore", &ignore,
        "all", &all);
    // dfmt on

    if (helpInformation.helpWanted)
    {
        writeln(`nproc %s

Usage: nproc [OPTIONS]...

Print the number of cores available to the current process.

  --all       print the number of installed processors
  --ignore=N  if possible, exclude N processing units
  --help      display this help and exit.
  --version   output version information and exit.
`.format(VERSION));
        exit(0);
    }
    else if (versions)
    {
        writeln(VERSION);
        exit(0);
    }

    if (all)
    {
        const n = environment.get("OMP_NUM_THREADS");
        if (n !is null)
            ignore += n.to!ulong;
    }

    auto cores = getCPUs(all);

    if (cores <= ignore)
        cores = 1;
    else
        cores -= ignore;

    writeln(cores);
    exit(0);
}

ulong getCPUs(bool all) @nogc nothrow
{
    ulong cores = 0;

    if (all)
    {
        cores = sysconf(_SC_NPROCESSORS_CONF);
        if (cores == 1)
            cores = cast() totalCPUs;
    }
    else
    {
        version (linux)
        {
            cpu_set_t cpu = void;
            if (sched_getaffinity(0, cpu.sizeof, &cpu) == 0)
                foreach (i; cpu.__bits[0 .. (cpu.sizeof / ulong.sizeof)])
                    cores += popcnt(i);
            else
                cores = cast() totalCPUs;
        }
        else
        {
            cores = cast() totalCPUs;
        }
    }
    return cores;
}
