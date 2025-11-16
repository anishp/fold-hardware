# M Fold design notes



### PCB Stackup

[6 layers][1]

1. Top Signal
2. Ground Plane
3. Inner Signal
4. Power Plane
5. Ground Plane
6. Bottom Signals

This stackup places each signal layer immediately adjacent to a ground  plane for the best return path characteristics. Additionally, by having  the power and ground plane next to each other creates planner  capacitance. The disadvantage again though is that you do lose one  signal layer for routing.

The ECG section and the Audio section have separate isolated ground planes.




### References

[1]: https://resources.pcb.cadence.com/blog/2019-pcb-design-for-the-6-layer-board-stackup	""Test""
