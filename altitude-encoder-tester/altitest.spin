{{ DS1302-demo.spin}}

CON
  _clkmode = xtal1 + pll16x 
  _xinfreq = 5_000_000

 
OBJ
  display : "7segbar"
  encoder : "altiread"


VAR

PUB main 
  display.Start(8, 0, 6)

  encoder.Initialize

  altiloop

PUB altiloop
    repeat
       encoder.Poll 
    
       display.SetValue(encoder.GetAltitude / 100)
       display.SetBar(encoder.GetRawBits << 1)
