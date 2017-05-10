import core.sys.posix.unistd : getcwd;
import core.stdc.stdlib : exit;

import std.format;
import std.getopt;
import std.stdio;
import std.string;

enum VERSION = "0.0.1";

immutable ulong PATHNAME_SIZE = 512;

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
pwd %s

USAGE:
  pwd [OPTION] ..
OPTION:
  -h: display this help and exit.
  -v: output version information and exit.
`.format(VERSION));
    } else if (versions) {
        VERSION.writeln;
    } else {
        char[PATHNAME_SIZE] pathname;
        getcwd(cast(char*) pathname, PATHNAME_SIZE);
        (cast(char*) pathname).fromStringz.writeln;
        exit(0);
    }
}
