module interpreter;

import std.conv;
import core.stdc.stdio;


class Interpreter
{
    private:
        size_t ptr;
        size_t codeptr;
        ubyte[] memory;
        string code;
    public:
        this(string _code, size_t buffsize)
        {
             memory = new ubyte[buffsize];
             code = _code;
             ptr = 0;
             codeptr = 0;
        }
        void run()
        {
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
                        }
                        break;
                    default:
                }
                codeptr++;
            }
        }
}