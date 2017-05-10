import std.file : getcwd;
import std.format;
import std.getopt;
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
        writeln(getcwd());
    }
}
