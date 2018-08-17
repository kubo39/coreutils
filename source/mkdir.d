import core.stdc.stdlib : exit;
import std.conv : parse;
import std.format : format;
import std.getopt;
import std.stdio;

enum VERSION = "0.0.1";

int mkdir(string path, bool recurse, ushort mode, bool verbose)
{
    import std.file;

    try
    {
        if (!recurse)
            std.file.mkdir(path);
        else
            mkdirRecurse(path);
        path.setAttributes(mode);

        if (verbose)
            writefln("mkdir: created directory '%s'", path);
        return 0;
    }
    catch (FileException e)
    {
        return 1;
    }
}

void main(string[] args)
{
    bool help, parents, versions, verbose;
    string mode = "755";
    args.getopt(std.getopt.config.caseSensitive, "h|help", &help, "V|version",
            &versions, "p|parents", &parents, "m|mode", &mode, "v|verbose", &verbose,);
    ushort attr = parse!ushort(mode, 8);

    if (help)
    {
        writeln(`
mkdir %s

Usage: mkdir [OPTIONS]... DIRECTORY...

Create the DIRECTORY(ies), if they do not already exist.

  -m,--mode=MODE   set file mode (as in chmod), not a=rwx - umask
  -p,--parents     no error if existing, make new parent directories as needed
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

    if (args.length < 1)
    {
        stderr.writeln("missing an argument");
        stderr.writeln("for help, try mkdir --help");
        exit(1);
    }
    int status;
    foreach (path; args[1 .. $])
        status |= mkdir(path, parents, attr, verbose);
    exit(status);
}
