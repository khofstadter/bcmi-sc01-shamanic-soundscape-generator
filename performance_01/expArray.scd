//here 1.5 is  exponent
Array.geom(16, 1, 1.5).normalize(0, 1800).plot

//with some randomness added...
(Array.geom(16, 1, 1.5).normalize(0, 1800)+{0.gauss(50)}.dup(16)).plot

//or, more advanced, scale randomness depending on position in the curve
(Array.geom(16, 1, 1.5).normalize(0, 1800)+{|i| 0.gauss(i.linlin(15, 0, 100, 1))}.dup(16)).plot


((0..1799).collect{|x| x.linexp(0, 1799, 1, 1800)+0.gauss(10)}).plot

({|i| 2**i/16}.dup(16).normalize(0, 1)).plot