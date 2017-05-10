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
    bool help, versions;

    getopt(
           args,
           "h|help", &help,
           "v|version", &versions,
           );

    if (help) {
        writeln(`
sleep %s

Usage: sleep NUMBER[SUFFIX]...
    or:    sleep OPTION


Pause for NUMBER seconds.  SUFFIX may be 's' for seconds (the default),
'm' for minutes, 'h' for hours or 'd' for days.  Unlike most implementations
that require NUMBER be an integer, here NUMBER may be an arbitrary floating
point number.  Given two or more arguments, pause for the amount of time
specified by the sum of their values.

  --help       display this help and exit.
  --version  output version information and exit.

`.format(VERSION));
    } else if (versions) {
        VERSION.writeln;
    } else {
        auto dur = args.dropOne
            .map!(a => a.to!int.dur!"seconds"())
            .fold!((a, b) => a + b)(Duration.zero);
        Thread.sleep(dur);
        exit(0);
    }
}
