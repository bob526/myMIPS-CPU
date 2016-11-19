# My CPU note

## Abbreviation
IR = Instruction Regester
RD = Regester Destination

## Some Regester had been initialized
$0 = 00000 = 0 (decimal)
$1 = 00001 = 1 (decimal)
$2 = 00010 = 2 (decimal)
記住，機器碼是後encode Destination Regester


## Some Problem
### In decode
B <=REG[IR[20:16]];
What does "REG" mean?   -> Simulated regesters(r0~r31)??