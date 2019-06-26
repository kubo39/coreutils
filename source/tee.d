import core.stdc.stdlib : exit, malloc, free;
import std.format : format;
import std.getopt;
import std.stdio;

enum VERSION = "0.0.1";

void main(string[] args)
{
    bool append, ignore_interrupts, versions;

    // dfmt off
    auto helpInformation = args.getopt(
        std.getopt.config.caseSensitive,
        "a|append", &append,
        "i|ignore_interrupts", &ignore_interrupts,
        "v|version", &versions);
    // dfmt on

    if (helpInformation.helpWanted)
    {
        writeln(`
tee %s

Usage: tee [OPTION]... [FILE]...
Copy standard input to each FILE, and also to standard output.

-a, --append             append to given FILEs, do not overwrite
-i, --ignore-interrupts  ignore interrupt signals

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

    int status = tee(args[1 .. $], append, ignore_interrupts);
    exit(status);
}

int tee(string[] filenames, bool append, bool ignore_interrupts)
{
    import core.stdc.errno;
    import core.sys.posix.signal;
    import core.sys.posix.unistd;
    import std.algorithm : map;
    import std.array : array;

    if (ignore_interrupts)
        signal(SIGINT, SIG_IGN);

    auto outputs = [std.stdio.stdout];
    outputs ~= filenames
        .map!(filename => File(filename, append ? "a" : "w"))
        .array;

    immutable BUFSIZE = 4096;
    auto buf = malloc(BUFSIZE);
    if (!buf)
    {
        import core.exception : onOutOfMemoryError;
        onOutOfMemoryError();
    }
    scope(exit) free(buf);

    ptrdiff_t nbytes = void;
    while (true)
    {
        nbytes = core.sys.posix.unistd.read(0, buf, buf.sizeof);
        if (nbytes < 0 && errno == EINTR)
            continue;
        if (nbytes <= 0)
            break;
        foreach (output; outputs)
            output.rawWrite(buf[0 .. nbytes]);
    }
    if (nbytes == -1)
        return 1;
    return 0;
}
