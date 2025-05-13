------ Assembly Code ------

; t0 = 2
MOV [t0], 2

; t1 = 2
MOV [t1], 2

; t2 = t0 - t1
MOV AX, [t0]
SUB AX, [t1]
MOV [t2], AX

; t3 = 0
MOV [t3], 0

; t4 = 1
MOV [t4], 1

