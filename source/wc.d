import core.stdc.stdlib : exit;
import std.format : format, formattedWrite;
import std.getopt;
import std.stdio;

enum VERSION = "0.0.1";

final class Settings
{
    bool showBytes;
    bool showChars;
    bool showWords;
    bool showLines;

    this(bool showBytes, bool showChars, bool showWords, bool showLines)
    {
        this.showBytes = showBytes;
        this.showChars = showChars;
        this.showWords = showWords;
        this.showLines = showLines;
    }
}

void main(string[] args)
{
    bool showBytes, showChars, showWords, showLines, versions;
    auto helpInformation = args.getopt("c|bytes", &showBytes,
                                       "m|chars", &showChars,
                                       "w|words", &showWords,
                                       "l|lines", &showLines,
                                       "v|version", &versions);
    if (helpInformation.helpWanted)
    {
        writeln(`
wc %s

Usage: wc [OPTION]... [FILE]...

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

    if (!showBytes && !showChars && !showWords && !showLines)
        showBytes = showWords = showLines = true;

    auto settings = new Settings(showBytes, showChars, showWords, showLines);

    int status = wc(args[1 .. $], settings);
    exit(status);
}

int wc(string[] filenames, Settings settings)
{
    import std.file : exists, isDir;
    import std.range : walkLength;
    import std.string : split;

    int status = 0;

    size_t totalByteCount = 0;
    size_t totalCharCount = 0;
    size_t totalWordCount = 0;
    size_t totalLineCount = 0;

    foreach (filename; filenames)
    {
        if (!filename.exists)
        {
            stderr.writefln("wc: %s: No such file or directory", filename);
            status |= 1;
            continue;
        }
        else if (filename.isDir)
        {
            stderr.writefln("wc: %s: Is a directory", filename);
            status |= 1;
            continue;
        }

        size_t byteCount = 0;
        size_t charCount = 0;
        size_t wordCount = 0;
        size_t lineCount = 0;
        auto f = File(filename);
        foreach (string line; f.byLineCopy(KeepTerminator.yes))
        {
            byteCount += line.length;
            charCount += line.walkLength;
            wordCount += line.split().length;
            lineCount++;
        }
        totalByteCount += byteCount;
        totalCharCount += charCount;
        totalWordCount += wordCount;
        totalLineCount += lineCount;
        writeStats(byteCount, charCount, wordCount, lineCount, settings, filename);
    }
    if (filenames.length > 1)
        writeStats(totalByteCount, totalCharCount, totalWordCount,
                   totalLineCount, settings, "total");

    return status;
}


void writeStats(size_t byteCount, size_t charCount, size_t wordCount,
                size_t lineCount, Settings settings, string filename)
{
    scope buf = stdout.lockingTextWriter();
    if (settings.showLines)
        buf.formattedWrite(" %d", lineCount);
    if (settings.showWords)
        buf.formattedWrite(" %d", wordCount);
    if (settings.showChars)
        buf.formattedWrite(" %d", charCount);
    if (settings.showBytes)
        buf.formattedWrite(" %d", byteCount);
    buf.formattedWrite(" %s", filename);
    buf.put("\n");
}
