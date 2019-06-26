import core.stdc.stdlib : exit;
import std.file;
import std.format : format;
import std.getopt;
import std.stdio : writeln, stderr;

enum VERSION = "0.0.1";

void main(string[] args)
{
    bool versions;

    auto helpInformation = args.getopt(
        std.getopt.config.caseSensitive,
        "v|version", &versions
        );

    if (helpInformation.helpWanted)
    {
        writeln(`
cp %s

Usage: cp [OPTION]... SOURCE DEST
Copy files.

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

    if (args.length < 3)
    {
        stderr.writeln("missing an argument");
        stderr.writeln("for help, try cp --help");
        exit(1);
    }

    int status;
    if (args.length == 3)
    {
        string src = args[1];
        string dest = args[2];
        if (!src.exists)
        {
            stderr.writeln("cp: %s: No such file or directory", src);
            exit(1);
        }
        else if (src.isDir)
        {
            stderr.writeln("cp: omitting directory '%s'", src);
        }
        status = copySourceToDest(src, dest);
    }
    else
    {
        string[] srcs = args[1..$-1];
        string dir = args[$-1];

        bool notSourceGiven = false;
        foreach (src; srcs)
        {
            if (!src.exists)
            {
                stderr.writefln("cp: %s: No such file or directory.", src);
                if (!notSourceGiven)
                    notSourceGiven = true;
            }
        }

        if (!dir.isDir)
        {
            stderr.writeln("cp: target '%s' is not a directory", dir);
            exit(1);
        }

        status = copyMultipleSourceToDir(srcs, dir);
        if (notSourceGiven)
            status = 1;
    }
    exit(status);
}

int copySourceToDest(string src, string dest)
{
    try
    {
        std.file.copy(src, dest);
        return 0;
    }
    catch (FileException e)
    {
        return 1;
    }
}

int copyMultipleSourceToDir(string[] srcs, string dir)
{
    try
    {
        foreach (src; srcs)
            std.file.copy(src, dir);
        return 0;
    }
    catch (FileException e)
    {
        return 1;
    }
}
