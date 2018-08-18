import core.stdc.stdlib : exit;
import std.format : format;
import std.getopt : getopt;
import std.stdio : writeln;

enum VERSION = "0.0.1";

void main(string[] args)
{
    bool versions;

    auto helpInformation = args.getopt("v|version", &versions);

    if (helpInformation.helpWanted)
    {
        writeln(`
sync %s

Usage: sync [OPTION] [FILE]...
Synchronize cached writes to persistent storage

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

    sync();
    exit(0);
}

void sync()
{
    import core.sys.posix.unistd;
    core.sys.posix.unistd.sync();
}
