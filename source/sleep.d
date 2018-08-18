import core.stdc.stdlib : exit;
import core.thread : Thread;
import core.time : dur, Duration;

import std.algorithm : fold, map;
import std.conv : to;
import std.format;
import std.getopt;
import std.range : dropOne;
import std.stdio;

enum VERSION = "0.0.1";

void main(string[] args)
{
    bool versions;

    auto helpInformation = args.getopt("v|version", &versions);

    if (helpInformation.helpWanted)
    {
        writeln(`
sleep %s

Usage: sleep NUMBER[SUFFIX]...
    or:    sleep OPTION


Pause for NUMBER seconds.

  --help     display this help and exit.
  --version  output version information and exit.

`.format(VERSION));
        exit(0);
    }
    else if (versions)
    {
        writeln(VERSION);
        exit(0);
    }

    auto dur = args.dropOne
        .map!(a => a.to!int
                .dur!"seconds"())
        .fold!((a, b) => a + b)(Duration.zero);
    Thread.sleep(dur);
    exit(0);
}
