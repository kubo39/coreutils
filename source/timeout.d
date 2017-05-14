import core.time;
import core.stdc.stdlib;
import core.sync.condition;
import core.sync.mutex;
import core.sys.posix.unistd : setpgid;
import core.stdc.stdlib : exit;
import core.thread;

import std.conv : to;
import std.format;
import std.getopt;
import std.process;
import std.stdio;
import std.string : fromStringz;

enum VERSION = "0.0.1";

void main(string[] args)
{
    bool help, versions, foreground;

    getopt(
           args,
           "foreground", &foreground,
           "h|help",  &help,
           "v|version", &versions,
           );

    if (help) {
        writeln(r"timeout %s
Usage: timeout [OPTION] DURATION COMMAND [ARG]...

Start COMMAND, and kill it if still running after DURATION.

  --foreground when not running timeout directly from a shell prompt, allow COMMAND to read from the TTY and get TTY signals; in this mode, children of COMMAND will not be timed out
  --help      display this help and exit.
  --version   output version information and exit.

".format(VERSION));
        exit(0);
    } else if (versions) {
        writeln(VERSION);
        exit(0);
    }

    if (args.length < 3) {
        stderr.writeln("missing an argument");
        stderr.writeln("for help, try timeout --help");
        exit(1);
    }

    Duration duration = args[1].to!ulong.dur!"seconds";
    string[] cmd = args[2 .. $];

    int status = timeout(duration, cmd, foreground);
    exit(status);
}

int timeout(Duration duration, string[] cmd, bool foreground)
{
    int status;
    writeln(foreground);
    if (!foreground) {
        setpgid(0, 0);
    }

    auto pid = spawnProcess(cmd);

    Mutex m = new Mutex;
    Condition cond = new Condition(m);

    void spawnedFunc()
    {
        status = wait(pid);
        synchronized (m) {
            cond.notify;
        }
    }

    auto thread = new Thread(&spawnedFunc).start;
    auto target = MonoTime.currTime + duration;

    synchronized (m) {
        MonoTime now;
        do {
            now = MonoTime.currTime;

            if (target <= now) {
                _Exit(124);
            }
        } while (!cond.wait(target - now));
    }

    return status;
}
