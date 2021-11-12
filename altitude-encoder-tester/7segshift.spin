VAR 
   long SegPin0, DigCount, SegPin7, Data, Clk
   long myStack[12]
   long dispValue[4]
   long dispDot

PUB Start(digpin, segpin, digits)
   Data := digpin
   Clk := digpin+1
   SegPin0 := segpin
   SegPin7 := segpin+7
   DigCount := digits

   dispValue[0] := 56
   dispValue[1] := 34
   dispValue[2] := 12
   
   cognew(ShowValue, @myStack)

PUB SetValue(v0, v1, v2)
   dispValue[0] := v0
   dispValue[1] := v1
   dispValue[2] := v2

PUB SetColons(v)                        
   if v
       dispValue[3] := 22
   else
       dispValue[3] := 0

PUB SetDot(n, v) | mask
   mask := (1 << n)
   if v
      dispDot |= mask
   else
      dispDot &= ! mask 
      
   
PRI ShowValue | displayValue, wordPos, v, digit
   dira[Clk] ~~
   dira[Data] ~~
   dira[SegPin0..SegPin7] ~~

   repeat
      displayValue := dispValue

      outa[Data] := 1
      repeat digit from 0 to 5
          wordPos := digit/2

          if (digit // 2) == 0
              v := byte[@Dig0bug + dispValue[wordPos] // 10]
          else
              v := byte[@Dig0bug + dispValue[wordPos] / 10 // 10]
              
          if (dispDot & (1<<digit))
              v := v | %10000000

          outa[SegPin7..SegPin0] := 0

          outa[Clk] := 0
          outa[Clk] := 1

          outa[SegPin7..SegPin0] := v  

          waitcnt(clkfreq / 1_000 + cnt) 

          outa[Data] := 0

      outa[SegPin7..SegPin0] := 0
      repeat digit from 6 to 7
           outa[Clk] := 0
           outa[Clk] := 1           

' segPin0 top
' segPin1 rtop
' segPin2 rbot
' segPin3 bot
' SegPin4 lbot
' SegPin5 ltop
' SegPin6 mid

DAT
   Dig0          byte %00111111
   Dig1          byte %00000110
   Dig2          byte %01011011
   Dig3          byte %01001111
   Dig4          byte %01100110
   Dig5          byte %01101101
   Dig6          byte %01111101
   Dig7          byte %00000111
   Dig8          byte %01111111
   Dig9          byte %01100111

   '                       BAEDCGF
   Dig0bug          byte %01111101
   Dig1bug          byte %01000100
   Dig2bug          byte %01111010
   Dig3bug          byte %01101110
   Dig4bug          byte %01000111
   Dig5bug          byte %00101111
   Dig6bug          byte %00111111
   Dig7bug          byte %01100100
   Dig8bug          byte %01111111
   Dig9bug          byte %01100111

   