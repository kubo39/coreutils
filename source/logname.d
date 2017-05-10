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
    if (login is null) {
        writeln("no login name");
        exit(1);
    }
    writeln(login.fromStringz);
}

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
logname %s

USAGE:
  logname [OPTION] ..
OPTION:
  -h: display this help and exit.
  -v: output version information and exit.
`.format(VERSION));
    } else if (versions) {
        VERSION.writeln;
    } else {
        getUserlogin();
    }
}
