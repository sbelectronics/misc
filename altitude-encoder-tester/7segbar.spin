VAR 
   long DigPin0, DigPin2, SegPin0, DigCount, SegPin7
   long myStack[12]
   long dispValue[4]
   long dispDot

PUB Start(digpin, segpin, digits)
   DigPin0 := digpin
   DigPin2 := digpin+2
   SegPin0 := segpin
   SegPin7 := segpin+7
   DigCount := digits

   dispValue[0] := 56
   dispValue[1] := 34
   dispValue[2] := 12
   
   cognew(ShowValue, @myStack)

PUB SetValue(v)
   dispValue[0] := v

PUB SetBar(v)
   dispValue[1] := v      
   
PRI ShowValueOld | digPos, displayValue, wordPos, divisor, v
   dira[DigPin0..DigPin2] ~~
   dira[SegPin0..SegPin7] ~~

   repeat
      displayValue := dispValue

      repeat wordPos from 0 to 3
          divisor := 1
          repeat digPos from 0 to 1
             outa[SegPin7..SegPin0] ~
             outa[DigPin0..DigPin2] := byte[@DigSel + (wordPos*2) + digPos]
             if (wordPos*2+digPos)>2
                 v := byte[@Dig0i + dispValue[wordPos] / divisor // 10] 
             else
                 v := byte[@Dig0 + dispValue[wordPos] / divisor // 10]
             if (dispDot & (1 << (wordPos*2+digPos)))
                 v := v | %10000000             
             outa[SegPin7..SegPin0] := v

             divisor := divisor * 10

             waitcnt (clkfreq / 10_000 + cnt)

PRI ShowValue | bitValue
   dira[DigPin0..DigPin2] ~~
   dira[SegPin0..SegPin7] ~~

   repeat
       ' ones
       outa[SegPin7..SegPin0] ~
       outa[DigPin0..DigPin2] := 5
       outa[SegPin7..SegPin0] := byte[@Dig0 + dispValue[0] // 10]
       waitcnt (clkfreq / 10_000 + cnt)

      ' tens
       outa[SegPin7..SegPin0] ~
       outa[DigPin0..DigPin2] := 1
       outa[SegPin7..SegPin0] := byte[@Dig0 + dispValue[0] / 10 // 10]
       waitcnt (clkfreq / 10_000 + cnt)  

       ' hundreds
       outa[SegPin7..SegPin0] ~
       outa[DigPin0..DigPin2] := 6
       outa[SegPin7..SegPin0] := byte[@Dig0 + dispValue[0] / 100 // 10]
       waitcnt (clkfreq / 10_000 + cnt)

       ' I messed up the pin assignments on the LED bar
       bitValue := 0
       if (dispValue[1] & $01)
           bitValue |= $20
       if (dispValue[1] & $02)
           bitValue |= $08
       if (dispValue[1] & $04)
           bitValue |= $04
       if (dispValue[1] & $08)
           bitValue |= $02
       if (dispValue[1] & $10)
           bitValue |= $01

       outa[SegPin7..SegPin0] ~
       outa[DigPin0..DigPin2] := 4
       outa[SegPin7..SegPin0] := bitValue
       waitcnt (clkfreq / 1_000 + cnt)

       ' messed it up real bad!
       bitValue := 0
       if (dispValue[1] & $20)
           bitValue |= $40
       if (dispValue[1] & $40)
           bitValue |= $10
       if (dispValue[1] & $80)
           bitValue |= $04
       if (dispValue[1] & $100)
           bitValue |= $02
       if (dispValue[1] & $200)
           bitValue |= $01

       outa[SegPin7..SegPin0] ~
       outa[DigPin0..DigPin2] := 0
       outa[SegPin7..SegPin0] := bitValue
       waitcnt (clkfreq / 1_000 + cnt)                     
     

          

' segPin0 top
' segPin1 rtop
' segPin2 rbot
' segPin3 bot
' SegPin4 lbot
' SegPin5 ltop
' SegPin6 mid

DAT
   DigSelOld     byte 3
                 byte 5
                 byte 1
                 byte 6
                 byte 2
                 byte 4

  ' I hooked up the pins backwards, so they go C,B,A instead of A,B,C

   DigSel        byte 5   ' 5
                 byte 1   ' 4
                 byte 6   ' 3
                 byte 2   ' 2 
                 byte 4   ' 1
                 byte 0   ' 0
                 byte 7   ' 7 
                 byte 3   ' 6

                 

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


   
   Dig0i          byte %00111111
   Dig1i          byte %00110000
   Dig2i          byte %01011011
   Dig3i          byte %01111001
   Dig4i          byte %01110100
   Dig5i          byte %01101101
   Dig6i          byte %01101111
   Dig7i          byte %00111000
   Dig8i          byte %01111111
   Dig9i          byte %01111101
   