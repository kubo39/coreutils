import core.stdc.stdlib : exit;
import std.file : getcwd;
import std.format;
import std.getopt;
import std.stdio;

enum VERSION = "0.0.1";

void main(string[] args)
{
    bool versions;

    // dfmt off
    const helpInformation = args.getopt(
        std.getopt.config.caseSensitive,
        "v|version", &versions);
    // dfmt on

    if (helpInformation.helpWanted)
    {
        writeln(`pwd %s

Usage: pwd [OPTION]

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
    writeln(getcwd());
    exit(0);
}
