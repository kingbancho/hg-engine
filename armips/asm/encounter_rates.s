.nds
.thumb

// Aurora Crystal specific changes
// Adjust encounter rates

// These work by generating a number 0-99, then doing a load of >= checks
// The last one is == 99 so this has to be changed

.open "base/overlay/overlay_0002.bin", 0x02245B80

// Walking Encounters
// Change rates to 10/10/10/10/10/10/10/10/5/5/5/5

.org 0x022476A0

// 17%
.byte 17
.skip 9

// 17%
.byte 34
.skip 7
.byte 34
.skip 3

// 15%
.byte 49
.skip 7
.byte 49
.skip 3

// 14%
.byte 64
.skip 7
.byte 64
.skip 3

// 8%
.byte 72
.skip 7
.byte 72
.skip 3

// 6%
.byte 78
.skip 7
.byte 78
.skip 3

//

// 4%
.byte 82
.skip 7
.byte 82
.skip 3

// 4%
.byte 86
.skip 7
.byte 86
.skip 3

// 4%
.byte 90
.skip 7
.byte 90
.skip 3

// 4%
.byte 94
.skip 7

// 4%
// then values 95 - 99 activate last slot
.byte 97

// Changes instruction from i == 98 to i >= 98
//.skip 2
//.byte 0xD2

// Surfing Encounters
// Change rates to 27/27/26/10/10

.org 0x02247734

// 27%
.byte 27
.skip 9

// 27%
.byte 54
.skip 7
.byte 54
.skip 3

// 26%
.byte 80
.skip 7
.byte 80
.skip 3

// 10%
// then values 90 - 99 activate last slot
.byte 90

// Fishing Encounters
// Change rates to 27/27/26/10/10

.org 0x02247778

// 27%
.byte 27
.skip 7

// 27%
.byte 54
.skip 7

// 26%
.byte 80
.skip 7

// 10%
// then values 90 - 99 activate last slot
.byte 90

// Rock Smash encounters
// Change rates to 70/30

.org 0x022477B0

// 70%
// then values 70 - 99 activate last slot
.byte 70

// Headbutt encounters
// Change rates to 20/20/20/20/10/10

.org 0x022477D4

// 20%
.byte 20
.skip 7

// 20%
.byte 40
.skip 7

// 20%
.byte 60
.skip 7

// 10%
.byte 80
.skip 7

// 10%
// then values 90 - 99 activate last slot
.byte 90

.close