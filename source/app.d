import std.stdio;
import std.file;

import vm;

const BUFFSIZE = 30000;

void main(string[] args)
{
    string filename = args[1];
    string code = readText(filename);

    auto vm = new VirtualMachine(code,BUFFSIZE);
    vm.parse();
    try
    {
        vm.run();
    } catch (Exception e){
        return;
    }
}

