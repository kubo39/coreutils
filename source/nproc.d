import core.stdc.stdlib : exit;
import std.conv : to;
import std.format;
import std.getopt;
import std.parallelism : totalCPUs;
import std.process : environment;
import std.stdio;
import std.string : fromStringz;

enum VERSION = "0.0.1";

void main(string[] args)
{
    bool help, versions, all;
    ulong ignore;

    getopt(
           args,
           "h|help", &help,
           "v|version", &versions,
           "ignore", &ignore,
           "all", &all,
           );

    if (help) {
        writeln(`
nproc %s

Usage: nproc [OPTIONS]...

Print the number of cores available to the current process.

  --all       print the number of installed processors
  --ignore=N  if possible, exclude N processing units
  --help      display this help and exit.
  --version   output version information and exit.

`.format(VERSION));
        exit(0);
    } else if (versions) {
        writeln(VERSION);
        exit(0);
    }

    if (all) {
        auto n = environment.get("OMP_NUM_THREADS");
        if (n !is null) {
            ignore += n.to!ulong;
        }
    }

    auto cores = cast() totalCPUs;
    if (cores <= ignore)
        cores = 1;
    else
        cores -= ignore;
    writeln(cores);
    exit(0);
}
