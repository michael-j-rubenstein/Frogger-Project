#####################################################################
#
#
# Student: Michael Jordan Rubenstein, 1006901033
#
#
#
#
# CSC258H5S Fall 2021 Assembly Final Project
# University of Toronto, St. George
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 5 
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. Easy - Display the number of lives remaining
# 2. Hard - Make a second level that starts after first level
# 3. Hard - Add powerup to scene, extra lives!!
# 4. Hard - Display the player's score at the top of the screen (Binary representation - out of 15)
#
# Any additional information that the TA needs to know:
# - It was very fun!!! Hope you will enjoy my game!! Have a great winter break!!
#
#####################################################################

 
 .data
 	displayAddress: .word 0x10008000
 	frogLocation: .word 0x10008E44
 	frogSideLocation: .word 0x10008E40
 	logsIndex: .word 0x000000
 	logsLocation1_1: .word 0x10008400
 	logsLocation1_2: .word 0x10008410
 	logsLocation1_3: .word 0x10008420
 	logsLocation1_4: .word 0x10008400
 	logsLocation2_1: .word 0x10008620
 	logsLocation2_2: .word 0x10008610
 	logsLocation2_3: .word 0x10008600
 	logsLocation2_4: .word 0x10008600
 	carsLocation1_1: .word 0x10008A00
 	carsLocation1_2: .word 0x10008A00
 	carsLocation1_3: .word 0x10008A20
 	carsLocation1_4: .word 0x10008A10
 	carsLocation2_1: .word 0x10008C20
 	carsLocation2_2: .word 0x10008C00
 	carsLocation2_3: .word 0x10008C00
 	carsLocation2_4: .word 0x10008C10
 	currDrawItteration: .word 0x000001
 	colourBlack: .word 0x000000
 	colourRed: .word 0xff0000
 	colourGreen: .word 0x00ff00
 	colourBlue: .word 0x0000ff
 	colourDarkGreen: .word 0x00b300
 	colourYellow: .word 0xffff00
 	colourBrown: .word 0x964B00
 	iteration: .word 0x000000
 	numLives: .word 0x000003
 	powerUp: .word 0x000001
 	playerScore: .word 0x000000
 	currLevel: .word 0x000000
 
 .text 
	lw $t0,displayAddress # $t0 stores the base address for display
	li $t1,0xff0000 # $t1 stores the red colour code
	li $t2,0x00ff00 # $t2 stores the green colour code
	li $t3,0x0000ff # $t3 stores the blue colour code
	li $t6,0x00b300 # t6 stores the dark green colour code
	li $t7,0x964B00 # t7 stores the brown colour code
	

LOOP_MAP_BEGIN:
	li $t4,0 #t4 stores the value of the indexing
	lw $t5,displayAddress #t5 stores the value of the current address
	lw $t1,colourRed # $t1 stores the red colour code
	lw $t2,colourGreen # $t2 stores the green colour code
	lw $t3,colourBlue # $t3 stores the blue colour code
	lw $t6,colourDarkGreen # t6 stores the dark green colour code
	lw $t7,colourBrown # t7 stores the brown colour code
LOOP_GRASS1:
	beq $t4,1024,GRASS1_END
	sw $t2, 0($t5)
	addi $t4,$t4,4
	add $t5,$t0,$t4
	j LOOP_GRASS1
GRASS1_END:
LOOP_WATER1:
	beq $t4,2048,WATER_END
	sw $t3, 0($t5)
	addi $t4,$t4,4
	add $t5,$t0,$t4
	j LOOP_WATER1
WATER_END:
LOOP_GRASS2:
	beq $t4,2560,GRASS2_END
	sw $t2, 0($t5)
	addi $t4,$t4,4
	add $t5,$t0,$t4
	j LOOP_GRASS2
GRASS2_END:
LOOP_ROAD1:
	beq $t4,3584,LOOP_GRASS3
	lw $t9,colourBlack
	sw $t9, 0($t5)
	addi $t4,$t4,4
	add $t5,$t0,$t4
	j LOOP_ROAD1
LOOP_GRASS3:
	beq $t4,4096,GRASS3_END
	sw $t2, 0($t5)
	addi $t4,$t4,4
	add $t5,$t0,$t4
	j LOOP_GRASS3
GRASS3_END:
	j ITTERATOR_CASE_DETECTOR
	

DRAW_FROG:
	lw $t4,frogLocation #store the frog location in $t4
	lw $t6, colourDarkGreen
	sw $t6, 0($t4)
	sw $t6, 4($t4)
	addi $t4,$t4,124
	sw $t6, 0($t4)
	sw $t6, 4($t4)
	sw $t6, 8($t4)
	sw $t6, 12($t4)
	addi $t4,$t4,132
	sw $t6, 0($t4)
	sw $t6, 4($t4)
	addi $t4,$t4,124
	sw $t6, 0($t4)
	sw $t6, 4($t4)
	sw $t6, 8($t4)
	sw $t6, 12($t4)
DRAW_FROG_END:
	jr $ra
	
DRAW_LOGS_BEGIN:
	li $t8,0 # inner loop variable i to draw each segment
	li $t9,0 # outer loop variable j to draw each row
	lw $t7, colourBrown # load $t7 as brown colour
LOGS_OUTER:
	beq $t9,8,DRAW_LOGS_END # if j == 8 then branch to DRAW LOGS END (itterate outerloop 8 times)
	addi $t9,$t9,1  # accumulate j => j+=1
LOGS_INNER1:
	beq $t8,8,LOGS_INNER2_INITIALIZER #first inner for loop, draws the row of the first log
	sw $t7, 0($t4) # draw pixel
	addi $t4,$t4,4 # accumulate memory location
	addi $t8,$t8,1 # accumulate i
	j LOGS_INNER1
LOGS_INNER2_INITIALIZER:
	li $t8, 0 # reset variable i = 0
	addi $t4,$t4,32 # add 32 to the memory location (next log)
LOGS_OUTER_END:
	j LOGS_OUTER
	
DRAW_LOGS_END:
	jr $ra


DRAW_S_LOGS_BEGIN:
	li $t8,0 # inner loop variable i to draw each segment
	li $t9,0 # outer loop variable j to draw each row
	lw $t7, colourBrown # load $t7 as brown colour
S_LOGS_OUTER:
	beq $t9,4,S_LOGS_END
	addi $t9,$t9,1
S_LOGS_LOOP1:
	beq $t8,4,S_LOGS_RESET1
	sw $t7, 0($t4)
	addi $t4, $t4, 4
	addi $t8, $t8, 1
	j S_LOGS_LOOP1
S_LOGS_RESET1:
	li $t8, 0
	addi $t4, $t4, 32
S_LOGS_LOOP2:
	beq $t8, 8, S_LOGS_RESET2
	sw $t7, 0($t4)
	addi $t4, $t4, 4
	addi $t8, $t8, 1
	j S_LOGS_LOOP2
S_LOGS_RESET2:
	li $t8, 0
	addi $t4, $t4, 32
S_LOGS_LOOP3:
	beq $t8,4,S_LOGS_RESET3
	sw $t7, 0($t4)
	addi $t4, $t4, 4
	addi $t8, $t8, 1
	j S_LOGS_LOOP3
S_LOGS_RESET3:
	li $t8, 0
	j S_LOGS_OUTER
S_LOGS_END:
	jr $ra



DRAW_CARS_BEGIN:
	li $t8,0 # inner loop variable i to draw each segment
	li $t9,0 # outer loop variable j to draw each row
	lw $t1, colourRed # load $t7 as red colour
CARS_OUTER:
	beq $t9,8,DRAW_CARS_END # if j == 8 then branch to DRAW LOGS END (itterate outerloop 8 times)
	addi $t9,$t9,1  # accumulate j => j+=1
CARS_INNER1:
	beq $t8,8,CARS_INNER2_INITIALIZER #first inner for loop, draws the row of the first log
	sw $t1, 0($t4) # draw pixel
	addi $t4,$t4,4 # accumulate memory location
	addi $t8,$t8,1 # accumulate i
	j CARS_INNER1
CARS_INNER2_INITIALIZER:
	li $t8, 0 # reset variable i = 0
	addi $t4,$t4,32 # add 16 to the memory location (next log)
CARS_OUTER_END:
	addi $t4,$t4,0 # add 16 to the memory location (next row)
	j CARS_OUTER
	
DRAW_CARS_END:
	jr $ra


DRAW_S_CARS_BEGIN:
	li $t8,0 # inner loop variable i to draw each segment
	li $t9,0 # outer loop variable j to draw each row
	lw $t1, colourRed # load $t7 as red colour
S_CARS_OUTER:
	beq $t9,4,S_CARS_END
	addi $t9,$t9,1
S_CARS_LOOP1:
	beq $t8,4,S_CARS_RESET1
	sw $t1, 0($t4)
	addi $t4, $t4, 4
	addi $t8, $t8, 1
	j S_CARS_LOOP1
S_CARS_RESET1:
	li $t8, 0
	addi $t4, $t4, 32
S_CARS_LOOP2:
	beq $t8, 8, S_CARS_RESET2
	sw $t1, 0($t4)
	addi $t4, $t4, 4
	addi $t8, $t8, 1
	j S_CARS_LOOP2
S_CARS_RESET2:
	li $t8, 0
	addi $t4, $t4, 32
S_CARS_LOOP3:
	beq $t8,4,S_CARS_RESET3
	sw $t1, 0($t4)
	addi $t4, $t4, 4
	addi $t8, $t8, 1
	j S_CARS_LOOP3
S_CARS_RESET3:
	li $t8, 0
	j S_CARS_OUTER
S_CARS_END:
	jr $ra

#####################################################
MAIN_LOOP_START:
	lw $s0,frogLocation #store the frog location in $t4
	lw $s1,displayAddress
	lw $s4, iteration
	addi $s1,$s1,1020
	
MAIN: 
	ble $s0,$s1, GAME_WIN
	li $v0, 32
	li $a0, 70 #time
	syscall

MAIN_KEYBOARD_BEGIN:
	lw $t8, 0xffff0000
	beq $t8, 1, KEYBOARD_INPUT
	j MAIN_DRAW_MAP

KEYBOARD_INPUT:
	lw $t2, 0xffff0004
	la $t5, frogLocation
	beq $t2, 0x61, RESPOND_A
	beq $t2, 0x77, RESPOND_W
	beq $t2, 0x73, RESPOND_S
	beq $t2, 0x64, RESPOND_D
	j MAIN_DRAW_MAP
RESPOND_A:
	lw $t9, frogLocation
	addi $t9, $t9, -16
	sw $t9, 0($t5)
	j MAIN_DRAW_MAP
RESPOND_W:
	lw $t9, frogLocation
	addi $t9, $t9, -512
	sw $t9, 0($t5)
	j MAIN_DRAW_MAP
RESPOND_S:
	lw $t9, frogLocation
	addi $t9, $t9, 512
	sw $t9, 0($t5)
	j MAIN_DRAW_MAP
RESPOND_D:
	lw $t9, frogLocation
	addi $t9, $t9, 16
	sw $t9, 0($t5)
	j MAIN_DRAW_MAP
	
	

MAIN_DRAW_MAP:
	lw $t4, currLevel
	bne $t4, 0, MAIN_DRAW_MAP2
	j LOOP_MAP_BEGIN

MAIN_DRAW_MAP2:
	j LOOP_MAP2_BEGIN


ITTERATOR_CASE_DETECTOR:
	beq $s4, 10, ITTERATOR_SPECIAL_CASE

ITTERATOR_NORMAL_CASE:
	addi $s4, $s4, 1
	la $t3, iteration
	sw $s4, ($t3)
	j MAIN_DRAW_MAP_SETUP

ITTERATOR_SPECIAL_CASE:
	li $s4, 0
	la $t3, iteration
	sw $s4, ($t3)
	la $t1, currDrawItteration
	lw $t2, currDrawItteration
	beq $t2, 4, ITTERATOR_SPECIAL_SPECIAL
	
ITTERATOR_SPECIAL_NORMAL:
	addi $t2, $t2, 1
	sw $t2, ($t1)
	j MAIN_DRAW_MAP_SETUP

ITTERATOR_SPECIAL_SPECIAL:
	li $t2, 1
	sw $t2, ($t1)


MAIN_DRAW_MAP_SETUP:
	lw $t1, currDrawItteration
	la $t2, currDrawItteration
	beq $t1, 1, DRAW_MAP_1_HANDLER
	beq $t1, 2, DRAW_MAP_2_HANDLER
	beq $t1, 3, DRAW_MAP_3_HANDLER
	beq $t1, 4, DRAW_MAP_4_HANDLER
	

DRAW_MAP_1_HANDLER:
	lw $t4, logsLocation1_1
	jal DRAW_LOGS_BEGIN
	lw $t4, logsLocation2_1
	jal DRAW_LOGS_BEGIN
	lw $t4, carsLocation1_1
	jal DRAW_CARS_BEGIN
	lw $t4, carsLocation2_1
	jal DRAW_CARS_BEGIN
	j LIVES_SET_UP
	
DRAW_MAP_2_HANDLER:
	lw $t4, logsLocation1_2
	jal DRAW_LOGS_BEGIN
	lw $t4, logsLocation2_2
	jal DRAW_LOGS_BEGIN
	lw $t4, carsLocation1_2
	jal DRAW_S_CARS_BEGIN
	lw $t4, carsLocation2_2
	jal DRAW_S_CARS_BEGIN
	j LIVES_SET_UP

DRAW_MAP_3_HANDLER:
	lw $t4, logsLocation1_3
	jal DRAW_LOGS_BEGIN
	lw $t4, logsLocation2_3
	jal DRAW_LOGS_BEGIN
	lw $t4, carsLocation1_3
	jal DRAW_CARS_BEGIN
	lw $t4, carsLocation2_3
	jal DRAW_CARS_BEGIN
	j LIVES_SET_UP

DRAW_MAP_4_HANDLER:
	lw $t4, logsLocation1_4
	jal DRAW_S_LOGS_BEGIN
	lw $t4, logsLocation2_4
	jal DRAW_S_LOGS_BEGIN
	lw $t4, carsLocation1_4
	jal DRAW_CARS_BEGIN
	lw $t4, carsLocation2_4
	jal DRAW_CARS_BEGIN
	j LIVES_SET_UP
	
	


LIVES_SET_UP:
	lw $t4, numLives
	lw $t5, displayAddress
	lw $t3, colourRed
	beq $t4, 5, LIVES_DRAW_5
	beq $t4, 4, LIVES_DRAW_4
	beq $t4, 3, LIVES_DRAW_3
	beq $t4 2, LIVES_DRAW_2
	beq $t4 1, LIVES_DRAW_1
	j EXIT

LIVES_DRAW_5:
	addi $t5, $t5, 216
	sw $t3, ($t5)
	sw $t3, 8($t5)
	sw $t3, 16($t5)
	sw $t3, 24($t5)
	sw $t3, 32($t5)
	j POWER_UP_BEGIN
	
LIVES_DRAW_4:
	addi $t5, $t5, 224
	sw $t3, ($t5)
	sw $t3, 8($t5)
	sw $t3, 16($t5)
	sw $t3, 24($t5)
	j POWER_UP_BEGIN		
	
LIVES_DRAW_3:
	addi $t5, $t5, 232
	sw $t3, ($t5)
	sw $t3, 8($t5)
	sw $t3, 16($t5)
	j POWER_UP_BEGIN
	
LIVES_DRAW_2:
	addi $t5, $t5, 240
	sw $t3, ($t5)
	sw $t3, 8($t5)
	j POWER_UP_BEGIN

LIVES_DRAW_1:
	addi $t5, $t5, 248
	sw $t3, ($t5)

POWER_UP_BEGIN:
	lw $t4, powerUp
	la $t5, powerUp
	beq $t4, 1, POWER_UP_DRAW
	j SCORE_SETUP

POWER_UP_DRAW:
	lw $t1, displayAddress
	lw $t2, colourYellow
	sw $t2, 2160($t1)
	
SCORE_SETUP:
	lw $t2, colourBlack
	lw $t1, colourDarkGreen
	lw $t3, displayAddress
	lw $t4, playerScore
	addi $t3, $t3, 480
	beq $t4, 0, SCORE_0_DRAW
	beq $t4, 1, SCORE_1_DRAW
	beq $t4, 2, SCORE_2_DRAW
	beq $t4, 3, SCORE_3_DRAW
	beq $t4, 4, SCORE_4_DRAW
	beq $t4, 5, SCORE_5_DRAW
	beq $t4, 6, SCORE_6_DRAW
	beq $t4, 7, SCORE_7_DRAW
	beq $t4, 8, SCORE_8_DRAW
	beq $t4, 9, SCORE_9_DRAW
	beq $t4, 10, SCORE_10_DRAW
	beq $t4, 11, SCORE_11_DRAW
	beq $t4, 12, SCORE_12_DRAW
	beq $t4, 13, SCORE_13_DRAW
	beq $t4, 14, SCORE_14_DRAW
	beq $t4, 15, SCORE_15_DRAW
	
SCORE_0_DRAW:
	sw $t1, 0($t3)
	sw $t1, 8($t3)
	sw $t1, 16($t3)
	sw $t1, 24($t3)
	j MAIN_FROG_BEGIN
SCORE_1_DRAW:
	sw $t1, 0($t3)
	sw $t1, 8($t3)
	sw $t1, 16($t3)
	sw $t2, 24($t3)
	j MAIN_FROG_BEGIN
SCORE_2_DRAW:
	sw $t1, 0($t3)
	sw $t1, 8($t3)
	sw $t2, 16($t3)
	sw $t1, 24($t3)
	j MAIN_FROG_BEGIN
SCORE_3_DRAW:
	sw $t1, 0($t3)
	sw $t1, 8($t3)
	sw $t2, 16($t3)
	sw $t2, 24($t3)
	j MAIN_FROG_BEGIN
SCORE_4_DRAW:
	sw $t1, 0($t3)
	sw $t2, 8($t3)
	sw $t1, 16($t3)
	sw $t1, 24($t3)
	j MAIN_FROG_BEGIN
SCORE_5_DRAW:
	sw $t1, 0($t3)
	sw $t2, 8($t3)
	sw $t1, 16($t3)
	sw $t2, 24($t3)
	j MAIN_FROG_BEGIN
SCORE_6_DRAW:
	sw $t1, 0($t3)
	sw $t2, 8($t3)
	sw $t2, 16($t3)
	sw $t1, 24($t3)
	j MAIN_FROG_BEGIN
SCORE_7_DRAW:
	sw $t1, 0($t3)
	sw $t2, 8($t3)
	sw $t2, 16($t3)
	sw $t2, 24($t3)
	j MAIN_FROG_BEGIN
SCORE_8_DRAW:
	sw $t2, 0($t3)
	sw $t1, 8($t3)
	sw $t1, 16($t3)
	sw $t1, 24($t3)
	j MAIN_FROG_BEGIN
SCORE_9_DRAW:
	sw $t2, 0($t3)
	sw $t1, 8($t3)
	sw $t1, 16($t3)
	sw $t2, 24($t3)
	j MAIN_FROG_BEGIN
SCORE_10_DRAW:
	sw $t2, 0($t3)
	sw $t1, 8($t3)
	sw $t2, 16($t3)
	sw $t1, 24($t3)
	j MAIN_FROG_BEGIN
SCORE_11_DRAW:
	sw $t2, 0($t3)
	sw $t1, 8($t3)
	sw $t2, 16($t3)
	sw $t2, 24($t3)
	j MAIN_FROG_BEGIN
SCORE_12_DRAW:
	sw $t2, 0($t3)
	sw $t2, 8($t3)
	sw $t1, 16($t3)
	sw $t1, 24($t3)
	j MAIN_FROG_BEGIN
SCORE_13_DRAW:
	sw $t2, 0($t3)
	sw $t2, 8($t3)
	sw $t1, 16($t3)
	sw $t2, 24($t3)
	j MAIN_FROG_BEGIN
SCORE_14_DRAW:
	sw $t2, 0($t3)
	sw $t2, 8($t3)
	sw $t2, 16($t3)
	sw $t1, 24($t3)
	j MAIN_FROG_BEGIN
SCORE_15_DRAW:
	sw $t2, 0($t3)
	sw $t2, 8($t3)
	sw $t2, 16($t3)
	sw $t2, 24($t3)

MAIN_FROG_BEGIN:
	jal DRAW_FROG
MAIN_FROG_END:
	lw $t1, colourRed
	lw $t2, colourBlue
	lw $t3, frogLocation
	lw $t7, colourYellow
	lw $t4, -4($t3)
	beq $t1, $t4, FROG_DEAD
	beq $t2, $t4, FROG_DEAD
	beq $t7, $t4, POWERUP
	j MAIN_RESET
FROG_DEAD:
	la $t4, numLives
	lw $t5, numLives
	addi $t5, $t5, -1
	sw $t5, ($t4)
	j MAIN_GAME_RESET

POWERUP:
	la $t4, numLives
	lw $t5, numLives
	bgt $t5, 5, MAIN_RESET
	
POWER_UP_BONUS:
	addi $t5, $t5, 1
	sw $t5, ($t4)
	la $t6, powerUp
	sw $zero, ($t6)
	

GAME_WIN:
	lw $t1, playerScore
	la $t2, playerScore
	addi $t1, $t1, 1
	sw $t1, ($t2)
	lw $t5, currLevel
	beq $t5, 0, GAME_LEVEL_1
	beq $t5, 1, GAME_LEVEL_2
	j MAIN_GAME_RESET
	
GAME_LEVEL_1:
	la $t4, currLevel
	addi $t5, $t5, 1
	sw $t5, ($t4)
	j MAIN_GAME_RESET
GAME_LEVEL_2:
	la $t4, currLevel
	li $t5, 0
	sw $t5, ($t4)
	j MAIN_GAME_RESET
	
	
MAIN_RESET:
	j MAIN_LOOP_START
	
MAIN_RESET_SPECIAL:
	j MAIN_LOOP_START
	

MAIN_GAME_RESET:

	la $t1, displayAddress
	li, $t2, 0x10008000
	sw $t2, ($t1)
	la $t1, frogLocation
	li, $t2, 0x10008E44
	sw $t2, ($t1)
	la $t1, logsIndex
	li, $t2, 0x10008400
	sw $t2, ($t1)
	la $t1, logsLocation1_1
	li, $t2, 0x10008400
	sw $t2, ($t1)
	la $t1, logsLocation2_1
	li, $t2, 0x10008620
	sw $t2, ($t1)
	la $t1, carsLocation1_1
	li, $t2, 0x10008A00
	sw $t2, ($t1)
	la $t1, carsLocation2_1
	li, $t2, 0x10008C20
	sw $t2, ($t1)
	la $t1, iteration
	li, $t2, 0x000000
	sw $t2, ($t1)
	li $s4, 0
	j LOOP_MAP_BEGIN

MAIN_FULL_GAME_RESET:

	la $t1, displayAddress
	li, $t2, 0x10008000
	sw $t2, ($t1)
	la $t1, frogLocation
	li, $t2, 0x10008E44
	sw $t2, ($t1)
	la $t1, logsIndex
	li, $t2, 0x10008400
	sw $t2, ($t1)
	la $t1, logsLocation1_1
	li, $t2, 0x10008400
	sw $t2, ($t1)
	la $t1, logsLocation2_1
	li, $t2, 0x10008620
	sw $t2, ($t1)
	la $t1, carsLocation1_1
	li, $t2, 0x10008A00
	sw $t2, ($t1)
	la $t1, carsLocation2_1
	li, $t2, 0x10008C20
	sw $t2, ($t1)
	la $t1, iteration
	li, $t2, 0x000000
	sw $t2, ($t1)
	la $t1, numLives
	li, $t2, 0x000003
	sw $t2, ($t1)
	li $s4, 0
	j LOOP_MAP_BEGIN
	
MAIN_END :

	
EXIT:
	li $v0, 10 # terminate the program gracefully
	syscall


LOOP_MAP2_BEGIN:
	li $t4, 0
	lw $t2, colourGreen
	lw $t5, displayAddress
	
LOOP_MAP2_GRASS:
	beq $t4,1024,MAP2_GRIDS_DRAW1
	sw $t2, 0($t5)
	addi $t4,$t4,4
	add $t5,$t0,$t4
	j LOOP_MAP2_GRASS

	
MAP2_GRIDS_DRAW1:
	li $t4, 1024
	add $t4, $t0, $t4
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourBlue
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourBlue
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourBlue
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourBlue
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourBlue
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourBlue
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourBlue
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 400
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourBlue
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourBlue
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 400
	lw $t2, colourBlue
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourBlue
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourBlue
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 400
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourBlue
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourBlue
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourBlue
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourBlue
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 400
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourBlue
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourBlue
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourBlue
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 400
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourBlue
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP
	addi $t4, $t4, 16
	lw $t2, colourGreen
	jal MAP2_GRID_DRAW_SETUP

	
	j LIVES_SET_UP

MAP2_GRID_DRAW_SETUP:
	li $t3, 0 # For loop start
	li $t5, 4 # For loop end
	li $t6, 0 # Accumulator
	
MAP2_SQUARE_DRAW_LOOP:
	beq $t3, $t5, MAP2_SQUARE_END
	li $t7, 0
	add $t7, $t4, $t6
	sw $t2, 0($t7)
	sw $t2, 4($t7)
	sw $t2, 8($t7)
	sw $t2, 12($t7)
	addi $t3, $t3, 1
	addi $t6, $t6, 128
	j MAP2_SQUARE_DRAW_LOOP
MAP2_SQUARE_END:
	jr $ra


	


