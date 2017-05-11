import core.stdc.stdlib : exit;
import core.sys.posix.unistd : geteuid;
import core.sys.posix.pwd : getpwuid;

import std.format;
import std.getopt;
import std.stdio;
import std.string : fromStringz;

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
whoami %s

Usage: whoami [OPTIONS]

print effective userid

  --help       display this help and exit.
  --version  output version information and exit.

`.format(VERSION));
        exit(0);
    } else if (versions) {
        writeln(VERSION);
        exit(0);
    }

    auto uid = geteuid();
    auto pw = getpwuid(uid);
    if (pw is null) {
        stderr.writefln("No such id: %d", uid);
        exit(1);
    }
    writeln(pw.pw_name.fromStringz);
    exit(0);
}
