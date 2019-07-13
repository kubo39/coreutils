import core.sys.posix.sys.utsname;
import core.stdc.stdlib : exit;
import std.format : format;
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
        writeln(`arch %s

Usage: arch [OPTION]...
Print machine architecture.

  --help     display this.help and exit
  --version  output version information and exit
`.format(VERSION));
        exit(0);
    }
    else if (versions)
    {
        writeln(VERSION);
        exit(0);
    }

    if (args.length > 1)
    {
        stderr.writefln("arch: extra operand %s", args[1 .. $]);
        exit(1);
    }

    utsname utsname = void;
    if (uname(&utsname) == -1)
    {
        import std.exception : errnoEnforce;
        errnoEnforce(false, "failed uname(2)");
    }

    writeln(utsname.machine);
    exit(0);
}
