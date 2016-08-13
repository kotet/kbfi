import std.stdio;
import std.getopt;
import std.file;
import interpreter;

const BUFFSIZE = 30000;

void main(string[] args)
{
    string filename = args[1];
    string code = readText(filename);
    
    auto interpreter = new Interpreter(code,BUFFSIZE);
    interpreter.run();
}

