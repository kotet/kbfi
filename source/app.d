import std.stdio;
import std.getopt;
import core.stdc.stdio;
import std.file;
import std.conv;

const BUFFSIZE = 30000;

void main(string[] args)
{
    string filename = args[1];
    string code = readText(filename);
    size_t ptr = 0;
    size_t codeptr = 0;
    ubyte[] memory = new ubyte[BUFFSIZE];
    while(codeptr < code.length)
    {
        switch(code[codeptr])
        {
            case '+':
                memory[ptr]++;
                break;
            case '-':
                memory[ptr]--;
                break;
            case '>':
                ptr++;
                break;
            case '<':
                ptr--;
                break;
            case '.':
                putchar(memory[ptr]);
                break;
            case ',':
                int tmp = getchar();
                if(tmp == EOF) return;
                memory[ptr] = tmp.to!ubyte;
                break;
            case '[':
                if(memory[ptr] == 0)
                {
                    int loopnest = 1;
                    do
                    {
                        codeptr++;
                        if(code[codeptr] == '[') loopnest++;
                        if(code[codeptr] == ']') loopnest--;
                    }while(0 < loopnest);
                }
                break;
            case ']':
                if(memory[ptr] != 0)
                {
                    int loopnest = 1;
                    do
                    {
                        codeptr--;
                        if(code[codeptr] == '[') loopnest--;
                        if(code[codeptr] == ']') loopnest++;
                    }while(0 < loopnest);
                   /* codeptr--;
                    for(int loopnest=1;0 < loopnest;codeptr--)
                    {
                        if(code[codeptr] == '[') loopnest--;
                        if(code[codeptr] == ']') loopnest++;
                    }
                    codeptr++;*/
                }
                break;
            default:
        }
        codeptr++;
    }
}

