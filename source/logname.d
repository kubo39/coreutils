import core.stdc.stdlib : exit;
import core.sys.posix.unistd : getlogin;

import std.format;
import std.getopt;
import std.stdio;
import std.string : fromStringz;

enum VERSION = "0.0.1";

void getUserlogin()
{
    const login = getlogin();
    if (login is null)
    {
        stderr.writeln("no login name");
        exit(1);
    }
    writeln(login.fromStringz);
}

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
        writeln(`logname %s

Usage: logname [OPTION]
Print the name of the current user.

  --help       display this help and exit.
  --version  output version information and exit.

`.format(VERSION));
        exit(0);
    }
    else if (versions)
    {
        writeln(VERSION);
        exit(0);
    }

    getUserlogin();
    exit(0);
}
