import core.stdc.stdlib : exit;
import std.format : format, formattedWrite;
import std.getopt;
import std.stdio;

enum VERSION = "0.0.1";

final class Settings
{
    bool kernelName;
    bool nodeName;
    bool kernelRelease;
    bool machine;

    this(bool kernelName, bool nodeName,
         bool kernelRelease, bool machine)
    {
    this.kernelName = kernelName;
    this.nodeName = nodeName;
    this.kernelRelease = kernelRelease;
    this.machine = machine;
    }
}

void main(string[] args)
{
    bool all, kernelName, nodeName, kernelRelease,
        machine, versions;
    auto helpInformation = args.getopt(
        std.getopt.config.bundling,
        std.getopt.config.caseSensitive,
        "a|all", &all,
        "s|kernel-name", &kernelName,
        "n|node-name", &nodeName,
        "r|kernel-release", &kernelRelease,
        "m|machine", &machine,
        "version", &versions);
    if (helpInformation.helpWanted)
    {
        writeln(`
uname %s

Usage: uname [OPTION]... [FILE]...
Print system information.  With no OPTION, same as -s.

  -a, --all                print all information, in the following order
  -s, --kernel-name        print the kernel name
  -n, --nodename           print the network node hostname
  -r, --kernel-release     print the kernel release
  -m, --machine            print the machine hardware name
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
    if (all)
        kernelName = nodeName = kernelRelease = machine = true;

    if (!kernelName && !nodeName && !kernelRelease && !machine)
        kernelName = true;

    auto settings = new Settings(kernelName, nodeName,
                                 kernelRelease, machine);
    int status = uname(settings);
    exit(status);
}

int uname(Settings settings)
{
    import core.sys.posix.sys.utsname;
    utsname utsname;
    if (core.sys.posix.sys.utsname.uname(&utsname) == -1)
    {
        import std.exception : errnoEnforce;
        errnoEnforce(false, "failed uname(2)");
    }
    scope buf = stdout.lockingTextWriter();
    if (settings.kernelName)
        buf.formattedWrite(" %s", utsname.sysname);
    if (settings.nodeName)
        buf.formattedWrite(" %s", utsname.nodename);
    if (settings.kernelRelease)
        buf.formattedWrite(" %s", utsname.release);
    if (settings.machine)
        buf.formattedWrite(" %s", utsname.machine);
    buf.put("\n");
    return 0;
}
