module vm;

import std.stdio;
import std.string;
import std.regex;
import std.array;
import std.conv;
import core.stdc.stdio;

struct Instruction
{
    void delegate(in size_t) dg;
    size_t value;
}

class VirtualMachine
{
    private:
        size_t pcnt;
        size_t ptr;
        ubyte[] memory;
        string source;
        Instruction[] instructions;

        void padd(in size_t n)
        {
            ptr += n;
        }
        void psub(in size_t n)
        {
            ptr -= n;
        }
        void dadd(in size_t n)
        {
            memory[ptr] += n;
        }
        void dsub(in size_t n)
        {
            memory[ptr] -= n;
        }
        void skip(in size_t n)
        {
            if(memory[ptr] == 0) pcnt = n;
        }
        void loop(in size_t n)
        {
            if(memory[ptr] != 0) pcnt = n;
        }
        void putc(in size_t n)
        {
            putchar(memory[ptr]);
        }
        void getc(in size_t n)
        {
            int tmp = getchar();
            if(tmp == EOF) throw new Error("EOF");
            memory[ptr] = tmp.to!ubyte;
        }
        void zero(in size_t n)
        {
            memory[ptr] = 0;
        }
        void end(in size_t n)
        {
            throw new Exception("end");
        }
    public:
        this(string _source, size_t buffsize)
        {
            memory = new ubyte[](buffsize);
            source = _source;
        }
        void parse()
        {
            string formatted;
            foreach(c;source)
            {
                if("+-<>[].,".indexOf(c) != -1) formatted ~= c;
            }
            formatted = formatted.replace(regex(r"\[-\]","g"),"z");
            size_t[] loopstack;
            auto prev = ' ';
            foreach(c;formatted)
            {
                switch(c)
                {
                    case '>':
                        if(prev == '>')
                        {
                            instructions.back.value++;
                        }else{
                            instructions ~= Instruction(&this.padd,1);
                        }
                        break;
                    case '<':
                        if(prev == '<')
                        {
                            instructions.back.value++;
                        }else{
                            instructions ~= Instruction(&this.psub,1);
                        }
                        break;
                    case '+':
                        if(prev == '+')
                        {
                            instructions.back.value++;
                        }else{
                            instructions ~= Instruction(&this.dadd,1);
                        }
                        break;
                    case '-':
                        if(prev == '-')
                        {
                            instructions.back.value++;
                        }else{
                            instructions ~= Instruction(&this.dsub,1);
                        }
                        break;
                    case '[':
                        loopstack ~= instructions.length;
                        instructions ~= Instruction(&this.skip,0);
                        break;
                    case ']':
                        instructions[loopstack.back].value = instructions.length;
                        instructions ~= Instruction(&this.loop,loopstack.back);
                        loopstack.popBack();
                        break;
                    case '.':
                        instructions ~= Instruction(&this.putc,0);
                        break;
                    case ',':
                        instructions ~= Instruction(&this.getc,0);
                        break;
                    case 'z':
                        instructions ~= Instruction(&this.zero,0);
                        break;
                    default:
                }
                prev = c;
            }
            instructions ~= Instruction(&this.end,0);
        }
        void run()
        {
            pcnt = 0;
            ptr = 0;
            while(true)
            {
                instructions[pcnt].dg(instructions[pcnt].value);
                pcnt++;
            }
        }
}
