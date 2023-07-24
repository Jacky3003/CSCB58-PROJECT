#####################################################################
#
# CSCB58 Summer 2023 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Jacky Chen, 1008049666, chenja54, jackyj.chen@mail.utoronto.ca
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8 (update this as needed)
# - Unit height in pixels: 8 (update this as needed)
# - Display width in pixels: 512 (update this as needed)
# - Display height in pixels: 256 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
# 
# Milestone 1 Goals:
# - Create a skeleton of the level design and the colours that could work well together
# - Make the player character that has an attacking option
# - Create breakable walls and obstacles in the players way
# - Have a start and a finish to the game
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3 (choose the one the applies)
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it!
#
# Are you OK with us sharing the video with people outside course staff?
# - yes / no / yes, and please share this project github link as well!
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################

.data

# Constants
.eqv sleepTime 1000
.eqv baseAddress 0x10008000

# Game Variables
xCor: .word 780
yCor: .word 780
gravSpeed: .word 256

# A test message for debugging.
TEST_MSG: .asciiz "Testing Controls...\n"

.text
	li $t0, baseAddress # $t0 stores the base address for display

# li $t2, 0x00ff00 -> Sample of how to assign colors to registers.
# 0x999fc2 -> Color of the platformer layout
# Loading Character
loadChararcter: # The character itself is 4x4
	li $t1, 0xffffff # Stores white (body)
	sw $t1, 520($t0)
	sw $t1, 536($t0)
	sw $t1, 784($t0) 
	sw $t1, 1036($t0)
	sw $t1, 1040($t0)
	sw $t1, 1044($t0)
	
	li $t1, 0x596c98 #Stores dark blue (legs)
	sw $t1, 1300($t0)
	sw $t1, 1292($t0)
	
	li $t1, 0x7de7ff #Stores light blue (eyes)
	sw $t1, 788($t0)
	sw $t1, 780($t0)
	
# Loading Map
	li $t0, baseAddress
	li $t1, 0x999fc2
	li $t3, 64
# Loads the celing border
loadCeli:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	addi $t3, $t3, -1
	bnez $t3, loadCeli

	li $t3, 64
	li $t0, baseAddress
# Loads the ground border
loadFloor:
	sw $t1, 7936($t0)
	addi $t0, $t0, 4
	addi $t3, $t3, -1
	bnez $t3, loadFloor
	
	li $t3, 32
	li $t0, baseAddress
# Loads the Left and Right borders
loadWalls:
	sw $t1, 0($t0)
	sw $t1, 252($t0)
	addi $t0, $t0, 256
	addi $t3, $t3, -1
	bnez $t3, loadWalls

	li $t0, baseAddress
	li $t3, 16
	
# Loads various platforms

loadInnerWalls:
	sw $t1, 332($t0)
	addi $t0, $t0, 256
	addi $t3, $t3, -1
	bnez $t3, loadInnerWalls
	li $t3, 16
	loadExtraOne:
		sw $t1, 332($t0)
		addi $t0, $t0, 4
		addi $t3, $t3, -1
		bnez $t3, loadExtraOne
	li $t3, 12
	prepExtraThree:
		addi $t0, $t0, 4
		addi $t3, $t3, -1
		bnez $t3, prepExtraThree
	li $t3, 16
	loadExtraThree:
		sw $t1, 332($t0)
		addi $t0, $t0, 256
		addi $t3, $t3, -1
		bnez $t3, loadExtraThree
	li $t3, 64
	li $t0, baseAddress
	prepExtraFourX:
		addi $t0, $t0, 4
		addi $t3, $t3, -1
		bnez $t3, prepExtraFourX
	li $t3, 8
	prepExtraFourY:
		addi $t0, $t0, 256
		addi $t3, $t3, -1
		bnez $t3, prepExtraFourY
	li $t3, 8
	loadExtraFour:
		sw $t1, 0($t0)
		addi $t0, $t0, -4
		addi $t3, $t3, -1
		bnez $t3, loadExtraFour
	li $t3, 8
	prepExtraFiveX:
		addi $t0, $t0, 4
		addi $t3, $t3, -1
		bnez $t3, prepExtraFiveX
	li $t3, 12
	prepExtraFiveY:
		addi $t0, $t0, 256
		addi $t3, $t3, -1
		bnez $t3, prepExtraFiveY
	li $t3, 8
	loadExtraFive:
		sw $t1, 0($t0)
		addi $t0, $t0, -4
		addi $t3, $t3, -1
		bnez $t3, loadExtraFive
# Loads the game platforms, will be a length of 7-5-3 for each layer
loadPlatforms:
	li $t0, baseAddress
	li $t3, 8
	# li $t1, 0x999fc2 is the original color, platforms will be in 3 shades
	#585b6f is layer 2, #292a35 is layer 3
	# First platform
	platOneX:
		addi $t0, $t0, 4
		addi $t3, $t3, -1
		bnez $t3, platOneX
	li $t3, 12
	platOneY:
		addi $t0, $t0, 256
		addi $t3, $t3, -1
		bnez $t3, platOneY
	li $t3, 7
	loadPlatOneA:
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		addi $t3, $t3, -1
		bnez $t3, loadPlatOneA
	addi $t0, $t0, 256
	addi $t0, $t0, -8
	li $t3, 5
	li $t1, 0x585b6f
	loadPlatOneB:
		sw $t1, 0($t0)
		addi $t0, $t0, -4
		addi $t3, $t3, -1
		bnez $t3, loadPlatOneB
	addi $t0, $t0, 256
	addi $t0, $t0, 16
	li $t3, 3
	li $t1, 0x292a35
	loadPlatOneC:
		sw $t1, 0($t0)
		addi $t0, $t0, -4
		addi $t3, $t3, -1
		bnez $t3, loadPlatOneC
	# Second Platform
	li $t0, baseAddress
	li $t3, 32
	li $t1, 0x999fc2
	platTwoX:
		addi $t0, $t0, 4
		addi $t3, $t3, -1
		bnez $t3, platTwoX
	li $t3, 8
	platTwoY:
		addi $t0, $t0, 256
		addi $t3, $t3, -1
		bnez $t3, platTwoY
	li $t3, 7
	loadPlatTwoA:
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		addi $t3, $t3, -1
		bnez $t3, loadPlatTwoA
	addi $t0, $t0, 256
	addi $t0, $t0, -8
	li $t3, 5
	li $t1, 0x585b6f
	loadPlatTwoB:
		sw $t1, 0($t0)
		addi $t0, $t0, -4
		addi $t3, $t3, -1
		bnez $t3, loadPlatTwoB
	addi $t0, $t0, 256
	addi $t0, $t0, 16
	li $t3, 3
	li $t1, 0x292a35
	loadPlatTwoC:
		sw $t1, 0($t0)
		addi $t0, $t0, -4
		addi $t3, $t3, -1
		bnez $t3, loadPlatTwoC

# Loads art details and other features (enemies, obstacles, collectibles)
# Enemy colours
# ffdc85: projectile (for later)
# fbbe27: body

# Collectible colors
# 0284be: health stem
# 0be1f5: health light
# e2d2e7: gravity off light
# ac6ca1: gravity off dark
# cba591: warp light
# a46440: warp dark

# Environment colors
# 054ca0: color 1
# 52bbd7: color 2
# 8d8fa5: color 3
# c3c3cd: color 4
loadDetails:
	li $t0, baseAddress
	loadFinish:
		li $t1, 0xffffff
		sw $t1, 1012($t0)
		sw $t1, 1268($t0)
		sw $t1, 1520($t0)
		sw $t1, 1776($t0)
	loadEnemy:
		li $t1, 0xfbbe27
		sw $t1, 4712($t0)
		sw $t1, 4964($t0)
		sw $t1, 4972($t0)
		sw $t1, 5224($t0)
		li $t1, 0xffdc85
		sw $t1, 4968($t0)
	loadSpikes:
		spikeOne:
			li $t1, 0xfbbe27
			sw $t1, 7716($t0)
			sw $t1, 7724($t0)
			li $t1, 0xffdc85
			sw $t1, 7720($t0)
			sw $t1, 7464($t0)
		spikeTwo:
			li $t1, 0xfbbe27
			sw $t1, 2112($t0)
			sw $t1, 2116($t0)
			sw $t1, 2120($t0)
			li $t1, 0xffdc85
			sw $t1, 2108($t0)
		spikeThree:
			li $t1, 0xfbbe27
			sw $t1, 4100($t0)
			li $t1, 0xffdc85
			sw $t1, 3844($t0)
			sw $t1, 4104($t0)
			sw $t1, 4356($t0)
		spikeFour:
			li $t1, 0xfbbe27
			sw $t1, 7880($t0)
			li $t1, 0xffdc85
			sw $t1, 7884($t0)
			sw $t1, 7876($t0)
			sw $t1, 7624($t0)
	loadHealth:
		li $t1, 0x0284be
		sw $t1, 3932($t0)
		sw $t1, 3924($t0)
		sw $t1, 3420($t0)
		sw $t1, 3412($t0)
		li $t1, 0x0be1f5
		sw $t1, 3672($t0)
	loadGravPack:
		li $t1 0xe2d2e7
		sw $t1, 7412($t0)
		sw $t1, 7664($t0)
		li $t1, 0xac6ca1
		sw $t1, 7408($t0)
		sw $t1, 7668($t0)
	loadWarp:
		li $t1 0xcba591
		sw $t1, 4852($t0)
		sw $t1, 4592($t0)
		li $t1 0xa46440
		sw $t1, 4848($t0)
		sw $t1, 4596($t0)
	loadRocks:
		rockOne:
			li $t1, 0x8d8fa5 
			sw $t1, 300($t0)
			sw $t1, 552($t0)
			li $t1, 0x054ca0
			sw $t1, 308($t0)
			sw $t1, 312($t0)
			li $t1, 0xc3c3cd
			sw $t1, 304($t0)
			sw $t1, 560($t0)
			li $t1, 0x52bbd7
			sw $t1, 816($t0)
		rockTwo:
			li $t1, 0x8d8fa5 
			sw $t1, 360($t0)
			li $t1, 0xc3c3cd
			sw $t1, 364($t0)
			sw $t1, 620($t0)
			li $t1, 0x52bbd7
			sw $t1, 368($t0)
		rockThree:
			li $t1, 0x8d8fa5 
			sw $t1, 4292($t0)
			sw $t1, 4288($t0)
			sw $t1, 4284($t0)
			li $t1, 0xc3c3cd
			sw $t1, 4536($t0)
			sw $t1, 4280($t0)
			sw $t1, 4792($t0)
		rockFour:
			li $t1, 0x8d8fa5
			sw $t1, 412($t0)
			sw $t1, 416($t0)
			li $t1, 0xc3c3cd
			sw $t1, 408($t0)
			sw $t1, 668($t0)
			li $t1, 0x52bbd7
			sw $t1, 672($t0)
		rockFive:
			li $t1, 0x8d8fa5
			sw $t1, 7700($t0)
			li $t1, 0xc3c3cd
			sw $t1, 7704($t0)
			li $t1, 0x52bbd7
			sw $t1, 7708($t0)
		rockSix:
			li $t1, 0x8d8fa5
			sw $t1, 7732($t0)
			li $t1, 0xc3c3cd
			sw $t1, 7740($t0)
			sw $t1, 7736($t0)
			li $t1, 0x52bbd7
			sw $t1, 7744($t0)
		bigRock:
			addi $t0, $t0, 6304
			li $t1, 0x8d8fa5
			li $t3, 7
			bigRockLoopOne:
				sw $t1, 0($t0)
				sw $t1, 256($t0)
				addi $t0, $t0, 4
				addi $t3, $t3, -1
				bnez $t3, bigRockLoopOne
			addi $t0, $t0, -6304
			li $t1, 0x054ca0
			sw $t1, 6044($t0)
			sw $t1, 6040($t0)
			li $t1, 0x52bbd7
			sw $t1, 6812($t0)
			sw $t1, 6804($t0)
			sw $t1, 6800($t0)
	j main
.globl main

main:	
	# Check for keypresses
	li $t9, 0xffff0000
	lw $t8, 0($t9)
	beq $t8, 1, keyPress
	j main

keyPress:
	lw $t2, 4($t9)
	beq $t2, 0x61, left
	beq $t2, 0x64, right
	beq $t2, 0x77, up
	beq $t2, 0x70, reset
	beq $t2, 0x6f, finish
	j main

left:
	li $v0, 4
	la $a0, TEST_MSG
	syscall
	j main

right:
	li $v0, 4
	la $a0, TEST_MSG
	syscall
	j main

up:
	li $v0, 4
	la $a0, TEST_MSG
	syscall
	j main

reset:
	li $v0, 4
	la $a0, TEST_MSG
	syscall
	j main 

finish:
	li $v0, 10
	syscall
