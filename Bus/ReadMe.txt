Various test for open bus emulation. Note that GBA Tek gives an essentially complete description of bus behavior, see there for details.

Sme minor detials that are tested here:

DMA updates the cpu bus. In particular, DMA (16 bit) from 0x04010000 updates cpu open bus (both 16 bit halves.) 

DMA from addresses it cannot access do not update the DMA bus.


