import core.stdc.stdlib : exit;
import std.format : format;
import std.getopt;
import std.stdio : writeln;

enum VERSION = "0.0.1";

void main(string[] args)
{
    bool versions;

    // dfmt off
    auto helpInformation = args.getopt(
        std.getopt.config.caseSensitive,
        "v|version", &versions);
    // dfmt on

    if (helpInformation.helpWanted)
    {
        writeln(`
hostid %s

Usage: hostid [OPTIONS]...

Print the numerical identifier for the current host.

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

    hostid();
    exit(0);
}

void hostid()
{
    import core.sys.posix.unistd : gethostid;
    import std.stdio : writefln;

    long hostId = gethostid();
    writefln("%08x", hostId & 0xffff_ffff);
}
