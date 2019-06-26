import core.stdc.stdlib : exit;
import core.sys.posix.unistd;
import std.format : format;
import std.getopt;
import std.stdio;

enum VERSION = "0.0.1";

extern (C)
{
    version (linux)
        int syncfs(int fd);
    else
    {
        int syncfs(int _)
        {
            core.sys.posix.unistd.sync();
            return 0;
        }
    }
}

enum Mode
{
    SYNC,
    DATA,
    FILE,
    FILE_SYSTEM,
}

void main(string[] args)
{
    bool data, filesystem, versions;

    // dfmt off
    auto helpInformation = args.getopt(
        std.getopt.config.caseSensitive,
        "d|data", &data,
        "f|file-system", &filesystem,
        "v|version", &versions);
    // dfmt on

    if (helpInformation.helpWanted)
    {
        writeln(`
sync %s

Usage: sync [OPTION] [FILE]...
Synchronize cached writes to persistent storage

 -d, --data         sync only file data, no unneeded metadata
 -f, --file-system  sync the file systems that contains the files
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

    // default mode is sync.
    Mode mode = Mode.SYNC;

    if (data && filesystem)
    {
        stderr.writeln("cannot specify both --data and --file-system");
        exit(1);
    }

    if (data && args.length < 2)
    {
        stderr.writeln("--data needs at least one argument");
        exit(1);
    }
    if (data)
        mode = Mode.DATA;
    if (filesystem)
        mode = Mode.FILE_SYSTEM;

    int status = 0;
    if (mode == Mode.SYNC)
    {
        core.sys.posix.unistd.sync();
    }
    else
    {
        foreach (filename; args[1 .. $])
            status &= syncArg(mode, filename);
    }
    exit(status);
}

bool syncArg(Mode mode, string filename)
{
    import core.sys.posix.fcntl;
    import std.file : exists;
    import std.string : toStringz;

    if (!filename.exists)
    {
        stderr.writefln("sync: error opening '%s': No such file or directory", filename);
        return false;
    }

    int fd = core.sys.posix.fcntl.open(filename.toStringz, O_RDONLY);
    if (fd == -1)
    {
        stderr.writefln("error opening: %s", filename);
        return false;
    }

    int status;
    switch (mode)
    {
    case Mode.DATA:
        status = fileDataSync(fd);
        break;
    case Mode.FILE:
        status = fsync(fd);
        break;
    case Mode.FILE_SYSTEM:
        status = syncfs(fd);
        break;
    default:
        stderr.writeln("invalid sync mode");
    }

    int ret = core.sys.posix.unistd.close(fd);
    if (status == 0 && ret < 0)
    {
        status = ret;
    }
    return status == 0;
}

int fileDataSync(int fd)
{
    version(OSX)
    {
        core.sys.posix.unistd.sync();
        return 0;
    }
    else
        return fdatasync(fd);
}
