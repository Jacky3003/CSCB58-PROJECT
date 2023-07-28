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
.eqv baseAddress 0x10008000
.eqv sleepTime 1000

# Game Variables, 8192 is the maximun coordinate
playerStartPos: .word 520, 524, 776, 780
#currPos: .word 520, 524, 776, 780
currPos: .word 520, 524, 776, 780
platPos: .word 0:8
platColors: .word 0:8
enemyPos: .word 0, 0, 0, 0, 0
projpos: .word 0
warpArrLoc: .word 640, 644, 896, 900
reduceEnemiesLoc: .word 3672, 3676, 3928, 3932
reducePlatformsLoc: .word 7408, 7412, 7664, 7668
# A test message for debugging.
TEST_MSG: .asciiz "Testing Controls...\n"

.text
clear:
	# clear needs to make sure moving objects have their positions reset (player, platform, enemy)
	li $t0, baseAddress # $t0 stores the base address for display
	li $t1, 0x000000
	addi $t2, $zero, 0
	reloadMap:
		beq $t2, 8192, nextOne
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		addi $t2, $t2, 4
		j reloadMap
	# reset player positions
	nextOne:
		addi $t2, $zero, 0
		li $t1, 0
		la $a0, currPos
		la $a1, playerStartPos
	resetPlayer:
		lw $t1, 0($a1)
		sw $t1, 0($a0)
		addi $t2, $t2, 4
		beq $t2, 20, resetPlatform
		addi $a0, $a0, 4
		addi $a1, $a1, 4
		j resetPlayer
	resetPlatform:
		j resetEnemy
	resetEnemy:
		j resetProj
	resetProj:
		j loadCharacter
		
#TODO
# Left and Right movement DONE
# Left and Right collision DONE
# Gravity DONE
# Jumping PROG
# upwards and downwards(DONE) collision

# li $t2, 0x00ff00 -> Sample of how to assign colors to registers.
# 0x999fc2 -> Color of the platformer layout
# Loading Character
loadCharacter: # The character itself is 2x2
	li $t0, baseAddress
	li $t1, 0xffffff # Stores white
	sw $t1, 520($t0)
	sw $t1, 780($t0)
	li $t1, 0x7de7ff #Stores light blue
	sw $t1, 524($t0)
	sw $t1, 776($t0)
	
# Loading Map
	li $t0, baseAddress
	li $t1, 0x999fc2
	li $t3, 64
# Loads the celing border
loadCeli:
	sw $t1, 0($t0)
	sw $t1, 256($t0)
	addi $t0, $t0, 4
	addi $t3, $t3, -1
	bnez $t3, loadCeli

	li $t3, 64
	li $t0, baseAddress
# Loads the ground border
loadFloor:
	sw $t1, 7936($t0)
	sw $t1, 7680($t0)
	addi $t0, $t0, 4
	addi $t3, $t3, -1
	bnez $t3, loadFloor
	
	li $t3, 32
	li $t0, baseAddress
# Loads the Left and Right borders
loadWalls:
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 252($t0)
	sw $t1, 248($t0)
	addi $t0, $t0, 256
	addi $t3, $t3, -1
	bnez $t3, loadWalls

	li $t0, baseAddress
	li $t3, 16
	
# Loads various platforms
	sw $t1, 4424($t0)
loadInnerWalls:
	sw $t1, 332($t0)
	sw $t1, 328($t0)
	sw $t1, 336($t0)
	sw $t1, 340($t0)
	addi $t0, $t0, 256
	addi $t3, $t3, -1
	bnez $t3, loadInnerWalls
	li $t3, 17
	loadExtraOne:
		sw $t1, 332($t0)
		sw $t1, 76($t0)
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
		sw $t1, 328($t0)
		sw $t1, 336($t0)
		sw $t1, 340($t0)
		sw $t1, 344($t0)
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
	li $t3, 9
	loadExtraFour:
		sw $t1, 0($t0)
		sw $t1, 256($t0)
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
		sw $t1, 256($t0)
		addi $t0, $t0, -4
		addi $t3, $t3, -1
		bnez $t3, loadExtraFive
	
# Loads the game platforms
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
	li $t3, 6
	loadPlatOneA:
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		addi $t3, $t3, -1
		bnez $t3, loadPlatOneA
	addi $t0, $t0, 256
	addi $t0, $t0, -4
	li $t3, 6
	li $t1, 0x585b6f
	loadPlatOneB:
		sw $t1, 0($t0)
		addi $t0, $t0, -4
		addi $t3, $t3, -1
		bnez $t3, loadPlatOneB
	# Second Platform
	li $t0, baseAddress
	li $t3, 32
	li $t1, 0x999fc2
	li $t4, 0
	platTwoX:
		addi $t0, $t0, 4
		addi $t4, $t4, 4
		addi $t3, $t3, -1
		bnez $t3, platTwoX
	li $t3, 8
	platTwoY:
		addi $t0, $t0, 256
		addi $t4, $t4, 256
		addi $t3, $t3, -1
		bnez $t3, platTwoY
	li $t3, 4
	la $a0, platPos
	loadPlatTwoA:
		sw $t1, 0($t0)
		sw $t4, 0($a0)
		addi $t0, $t0, 4
		addi $a0, $a0, 4
		addi $t4, $t4, 4
		addi $t3, $t3, -1
		bnez $t3, loadPlatTwoA
	addi $t0, $t0, 256
	addi $t4, $t4, 252
	addi $t0, $t0, -4
	li $t3, 4
	li $t1, 0x585b6f
	loadPlatTwoB:
		sw $t1, 0($t0)
		sw $t4, 0($a0)
		addi $a0, $a0, 4
		addi $t0, $t0, -4
		addi $t4, $t4, -4
		addi $t3, $t3, -1
		bnez $t3, loadPlatTwoB

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
		li $t1, 0xdcff4b
		sw $t1, 1268($t0)
		sw $t1, 1264($t0)
		sw $t1, 1520($t0)
		sw $t1, 1524($t0)
		sw $t1, 1776($t0)
		sw $t1, 1780($t0)
		sw $t1, 2036($t0)
		sw $t1, 2032($t0)
	loadEnemy:
		li $t1, 0xfbbe27
		sw $t1, 4712($t0)
		sw $t1, 4968($t0)
		sw $t1, 4964($t0)
		li $t1, 0xffdc85
		sw $t1, 4708($t0)
	loadSpikes:
		spikeOne:
			li $t1, 0xfbbe27
			sw $t1, 7464($t0)
			sw $t1, 7468($t0)
			li $t1, 0xffdc85
			sw $t1, 7208($t0)
			sw $t1, 7212($t0)
		spikeTwo:
			li $t1, 0xfbbe27
			sw $t1, 2112($t0)
			sw $t1, 2368($t0)
			sw $t1, 2372($t0)
			sw $t1, 2376($t0)
			sw $t1, 2116($t0)
			sw $t1, 2120($t0)
			li $t1, 0xffdc85
			sw $t1, 2108($t0)
			sw $t1, 2104($t0)
			sw $t1, 2364($t0)
			sw $t1, 2360($t0)
		spikeThree:
			li $t1, 0xfbbe27
			sw $t1, 3588($t0)
			sw $t1, 3592($t0)
			sw $t1, 3596($t0)
			sw $t1, 4100($t0)
			li $t1, 0xffdc85
			sw $t1, 3844($t0)
			sw $t1, 3848($t0)
			sw $t1, 3852($t0)
			sw $t1, 4104($t0)
			sw $t1, 4108($t0)
			sw $t1, 4356($t0)
			sw $t1, 4360($t0)
			sw $t1, 4364($t0)
		spikeFour:
			li $t1, 0xfbbe27
			sw $t1, 7880($t0)
			li $t1, 0xffdc85
			sw $t1, 7884($t0)
			sw $t1, 7876($t0)
			sw $t1, 7624($t0)
			sw $t1, 7628($t0)
			sw $t1, 7372($t0)
			sw $t1, 7368($t0)
	loadReduceEnemies:
		li $t1, 0x0284be
		sw $t1, 3932($t0)
		sw $t1, 3928($t0)
		li $t1, 0x0be1f5
		sw $t1, 3672($t0)
		sw $t1, 3676($t0)
	loadReducePlatforms:
		li $t1 0xe2d2e7
		sw $t1, 7412($t0)
		sw $t1, 7664($t0)
		li $t1, 0xac6ca1
		sw $t1, 7408($t0)
		sw $t1, 7668($t0)
	loadWarp:
		li $t1 0xcba591
		sw $t1, 5108($t0)
		sw $t1, 4848($t0)
		li $t1 0xa46440
		sw $t1, 5104($t0)
		sw $t1, 4852($t0)
	loadRocks:
		rockOne:
			li $t1, 0x8d8fa5 
			sw $t1, 300($t0)
			li $t1, 0x054ca0
			sw $t1, 308($t0)
			sw $t1, 312($t0)
			li $t1, 0xc3c3cd
			sw $t1, 304($t0)
			li $t1, 0x52bbd7
			sw $t1, 316($t0)
		rockTwo:
			li $t1, 0x8d8fa5 
			sw $t1, 360($t0)
			li $t1, 0xc3c3cd
			sw $t1, 364($t0)
			li $t1, 0x52bbd7
			sw $t1, 368($t0)
		rockThree:
			li $t1, 0x8d8fa5 
			sw $t1, 4292($t0)
			sw $t1, 4296($t0)
			sw $t1, 4300($t0)
			sw $t1, 4288($t0)
			sw $t1, 4284($t0)
			li $t1, 0xc3c3cd
			sw $t1, 4536($t0)
			sw $t1, 4544($t0)
			sw $t1, 4548($t0)
			sw $t1, 4800($t0)
			sw $t1, 4804($t0)
			sw $t1, 4280($t0)
			sw $t1, 4792($t0)
		rockFour:
			li $t1, 0x8d8fa5
			sw $t1, 412($t0)
			sw $t1, 416($t0)
			li $t1, 0xc3c3cd
			sw $t1, 408($t0)
			li $t1, 0x52bbd7
			sw $t1, 420($t0)
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
			sw $t1, 6036($t0)
			sw $t1, 5780($t0)
			sw $t1, 5020($t0)
			sw $t1, 5276($t0)
			sw $t1, 5532($t0)
			sw $t1, 5784($t0)
			sw $t1, 5788($t0)
			sw $t1, 6044($t0)
			sw $t1, 6300($t0)
			sw $t1, 6556($t0)
			sw $t1, 7324($t0)
			sw $t1, 7580($t0)
			li $t1, 0x52bbd7
			sw $t1, 6812($t0)
			sw $t1, 6804($t0)
			sw $t1, 6800($t0)
			sw $t1, 6808($t0)
			sw $t1, 6796($t0)
			sw $t1, 6792($t0)
			sw $t1, 6788($t0)
			
			sw $t1, 7068($t0)
			sw $t1, 7060($t0)
			sw $t1, 7056($t0)
			sw $t1, 7064($t0)
			sw $t1, 7052($t0)
			sw $t1, 7048($t0)
			sw $t1, 7044($t0)
	j main
.globl main

main:	
	#reset registers
	jal resetRegisters
	
	# Other Movement
	
	# Check if player has been redrawn to black
	
	# Check for keypresses, movement, shooting
	li $t9, 0xffff0000
	lw $t8, 0($t9)
	beq $t8, 1, keyPress
	
	# Gravity Update
	addi $t3, $zero, 0
	la $a1, currPos
	gravityLoop:
		lw $t1, 0($a1)
		addi $t1, $t1, 512
		j checkGravCol
		backGrav:
		sw $t1, 0($a1)
		addi $t3, $t3, 4
		beq $t3, 16, backMain
		addi $a1, $a1, 4
		j gravityLoop
		checkGravCol:
			li $t0, baseAddress
			
			add $t0, $t0, $t1
			lw $t4, 0($t0)
			
			li $t8, 0xfbbe27
			beq $t4, $t8,  loseScreen
		
			li $t8, 0xffdc85
			beq $t4, $t8,  loseScreen
			
			li $t8, 0xcba591
			beq $t4, $t8,  warpTo
			
			li $t8, 0x0be1f5
			beq $t4, $t8, reduceEnemies
			
			li $t8, 0xac6ca1
			beq $t4, $t8, reducePlatforms
			
			li $t8, 0x000000
			beq $t4, $t8, backGrav
			j main
	backMain:
		jal changePosGrav
	#loop back to main
	li $v0, 32
	li $a0, sleepTime
	syscall
	j main

resetRegisters:
	addi $t0, $t0, 0
	addi $t1, $t1, 0
	addi $t2, $t2, 0
	addi $t3, $t3, 0
	addi $t4, $t4, 0
	addi $t5, $t5, 0
	addi $t6, $t6, 0
	addi $t7, $t7, 0
	addi $t8, $t8, 0
	addi $t9, $t9, 0
	addi $a0, $a0, 0
	addi $a1, $a1, 0
	addi $a2, $a2, 0
	addi $a3, $a3, 0
	jr $ra

keyPress:
	lw $t2, 4($t9)
	beq $t2, 0x61, left
	beq $t2, 0x64, right
	beq $t2, 0x77, up
	beq $t2, 0x70, reset
	beq $t2, 0x6f, finish
	j main
# For left and right movement, store 4 onto the stack for left, store -4 onto the stack for right
left:
	addi $t3, $zero, 4
	addi $sp, $sp, -4
	sw $t3, 0($sp)
	j moveCharacterLeftRight
right:
	addi $t3, $zero, -4
	addi $sp, $sp, -4
	sw $t3, 0($sp)
	j moveCharacterLeftRight
# Jumping requires to do -1536 to each framebuffer that positions the player
up:
	la $a0, currPos
	li $t3, 0
	jumpLoop:
		beq $t3, 16, jumpMove
		lw $t2, 0($a0)
		addi $t8, $t2, -1536
		jal checkJumpCol
		sw $t8, 0($a0)
		addi $t3, $t3, 4
		addi $a0, $a0, 4
		j jumpLoop
jumpMove:
	la $a0, currPos
	li $t0, baseAddress
	li $t5, 0x000000
	addi $t4, $zero, 0
		jumpChange:
			li $t0, baseAddress
			beq $t4, 16, main
			lw $t2, 0($a0)
			add $t0, $t0, $t2
			addi $t0, $t0, 1536
			lw $t6, 0($t0)
			
			li $t0, baseAddress
			add $t0, $t0, $t2
			sw $t6, 0($t0)
			addi $t0, $t0, 1536
			sw $t5, 0($t0)
			addi $t4, $t4, 4
			addi $a0, $a0, 4
			j jumpChange
checkJumpCol:
	li $t0, baseAddress
	add $t0, $t0, $t8
	addi $t6, $zero, 0
	vertCol:
		addi $t7, $zero, 0
		lw $t1, 0($t0)
		
		li $t2, 0xfbbe27
		beq $t1, $t2,  loseScreen
		
		li $t2, 0xffdc85
		beq $t1, $t2,  loseScreen
		
		li $t2, 0x000000
		beq $t1, $t2, checkOneVert
		addi $t7, $t7, 1
		checkOneVert:
			li $t2, 0xffffff
			beq $t1, $t2, checkTwoVert
		addi $t7, $t7, 1
		checkTwoVert:
			li $t2, 0x7de7ff 
			beq $t1, $t2, checkThreeVert
		addi $t7, $t7, 1
		checkThreeVert:
			beq $t7, 3, main
			addi $t6, $t6, 4
			add $t0, $t0, 256
			bne $t6, 24, vertCol
	li $t0, baseAddress
	jr $ra

reset:
	j clear
	
moveCharacterLeftRight:
	la $a0, currPos
	lw $t3, 0($sp)
	addi $sp, $sp, 4
	addi $t4, $zero, 0 # i for loops here
	beq $t3, -4, loopRight
	# adding -4 to the array values
	loopLeft:
		beq $t4, 16, changePos
		lw $t5, 0($a0)
		addi $t8, $t5, -8
		jal checkLeftRightCol
		sw $t8, 0($a0)
		addi $t4, $t4, 4
		addi $a0, $a0, 4
		j loopLeft
	# adding 4 to the array values
	loopRight:
		beq $t4, 16, changePos
		lw $t5, 0($a0)
		addi $t8, $t5, 8
		jal checkLeftRightCol
		sw $t8, 0($a0)
		addi $t4, $t4, 4
		addi $a0, $a0, 4
		j loopRight
changePos:
	li $t0, baseAddress
	la $a0, currPos
	addi $t4, $zero, 0
	loopPosChange:
		li $t0, baseAddress
		beq $t4, 16, main
		back:
			lw $t5, 0($a0)
			add $t0, $t0, $t5
			jal currDirOne
			lw $t1, 0($t0)
			li $t2, 0x000000
			li $t0, baseAddress
			add $t0, $t0, $t5
			sw $t1, 0($t0)
			addi $t0, $t0, 8
			beq $t3, -4, currDirTwo
			sw $t2, 0($t0)
			addi $t4, $t4, 4
			addi $a0, $a0, 4
			j loopPosChange
			currDirTwo:
				addi $t0, $t0, -8
				addi $t0, $t0, -8
			sw $t2, 0($t0)
			
			addi $t4, $t4, 4
			addi $a0, $a0, 4
			j loopPosChange
finish:
	li $v0, 10
	syscall

currDirOne:
	beq $t3, -4, setCorrectPos
	addi $t0, $t0, 8
	jr $ra
	setCorrectPos:
		addi $t0, $t0, -8
		jr $ra
		
checkLeftRightCol:
	li $t0, baseAddress
	add $t0, $t0, $t8
	addi $t6, $zero, 0
	addi $t7, $zero, 0
	horCol:
		lw $t1, 0($t0)
		li $t2, 0xdcff4b
		beq $t1, $t2,  winScreen
		
		li $t2, 0xfbbe27
		beq $t1, $t2,  loseScreen
		
		li $t2, 0xffdc85
		beq $t1, $t2,  loseScreen
		
		li $t2, 0xcba591
		beq $t1, $t2, warpTo
		
		li $t2, 0x0be1f5
		beq $t1, $t2, reduceEnemies
		
		li $t2, 0xac6ca1
		beq $t1, $t2, reducePlatforms
		
		li $t2, 0x000000
		beq $t1, $t2, checkOne
		addi $t7, $t7, 1
		checkOne:
			li $t2, 0xffffff
			beq $t1, $t2, checkTwo
		addi $t7, $t7, 1
		checkTwo:
			li $t2, 0x7de7ff 
			beq $t1, $t2, checkThree
		addi $t7, $t7, 1
		checkThree:
			beq $t7, 3, main
			addi $t6, $t6, 4
			add $t0, $t0, $t3
			bne $t6, 8, horCol
	li $t0, baseAddress
	jr $ra
	warpTo:
		# make item dissapear
		li $t2, 0x000000
		li $t0, baseAddress
		addi $t0, $t0, 4848
		sw $t2, 0($t0)
		sw $t2, 4($t0)
		sw $t2, 256($t0)
		sw $t2, 260($t0)
		# Normally when an item is collected, put the player in the new position, but this item warps location,
		# So instead move the player when location gets warped.
		li $t0, baseAddress
		la $a0, currPos
		la $a1, warpArrLoc
		li $t3, 0
		warpLoop:
			li $t2, 0x000000
			li $t0, baseAddress
			lw $t4, 0($a0)
			add $t0, $t0, $t4
			lw $t6, 0($t0)
			sw $t2, 0($t0)
			lw $t5, 0($a1)
			add $t4, $zero, $t5
			sw $t4, 0($a0)
			# redraw the pixel
			li $t0, baseAddress
			add $t0, $t0, $t5
			sw $t6, 0($t0)
			
			addi $a0, $a0, 4
			addi $a1, $a1, 4
			addi $t3, $t3, 4
			blt $t3, 16, warpLoop
		j main
	reduceEnemies:
		li $t2, 0x000000
		li $t0, baseAddress
		sw $t2, 2112($t0)
		sw $t2, 2368($t0)
		sw $t2, 2372($t0)	
		sw $t2, 2116($t0)	
		sw $t2, 2108($t0)
		sw $t2, 2104($t0)
		sw $t2, 2364($t0)
		sw $t2, 2360($t0)
		sw $t2, 3592($t0)
		sw $t2, 3596($t0)
		sw $t2, 3848($t0)
		sw $t2, 3852($t0)
		sw $t2, 4104($t0)
		sw $t2, 4108($t0)
		sw $t2, 4360($t0)
		sw $t2, 4364($t0)
		
		# make item dissapear
		li $t0, baseAddress
		la $a0, currPos
		la $a1, reduceEnemiesLoc
		li $t3, 0
		reduceEnemiesLoop:
			li $t2, 0x000000
			li $t0, baseAddress
			lw $t4, 0($a0)
			add $t0, $t0, $t4
			lw $t6, 0($t0)
			sw $t2, 0($t0)
			lw $t5, 0($a1)
			add $t4, $zero, $t5
			sw $t4, 0($a0)
			# redraw the pixel
			li $t0, baseAddress
			add $t0, $t0, $t5
			sw $t6, 0($t0)
			addi $a0, $a0, 4
			addi $a1, $a1, 4
			addi $t3, $t3, 4
			blt $t3, 16, reduceEnemiesLoop
		j main
	reducePlatforms:
		li $t2, 0x000000
		li $t0, baseAddress
		sw $t2, 3360($t0)
		sw $t2, 3364($t0)
		sw $t2, 3368($t0)
		sw $t2, 3372($t0)
		sw $t2, 3376($t0)
		sw $t2, 3380($t0)
		sw $t2, 3104($t0)
		sw $t2, 3108($t0)
		sw $t2, 3112($t0)
		sw $t2, 3116($t0)
		sw $t2, 3120($t0)
		sw $t2, 3124($t0)
		
		sw $t2, 1352($t0)
		sw $t2, 1356($t0)
		sw $t2, 1360($t0)
		sw $t2, 1364($t0)
		sw $t2, 1096($t0)
		sw $t2, 1100($t0)
		sw $t2, 1104($t0)
		sw $t2, 1108($t0)	
		
		li $t0, baseAddress
		la $a0, currPos
		la $a1, reducePlatformsLoc
		li $t3, 0
		reducePlatformsLoop:
			li $t2, 0x000000
			li $t0, baseAddress
			lw $t4, 0($a0)
			add $t0, $t0, $t4
			lw $t6, 0($t0)
			sw $t2, 0($t0)
			lw $t5, 0($a1)
			add $t4, $zero, $t5
			sw $t4, 0($a0)
			# redraw the pixel
			li $t0, baseAddress
			add $t0, $t0, $t5
			sw $t6, 0($t0)
			addi $a0, $a0, 4
			addi $a1, $a1, 4
			addi $t3, $t3, 4
			blt $t3, 16, reducePlatformsLoop
		j main
changePosGrav:
	la $a1, currPos
	addi $t3, $zero, 0
	li $t2, 0x000000
	changePosGravEach:
		li $t0, baseAddress
		lw $t5, 0($a1)
		add $t0, $t0, $t5
		addi $t0, $t0, -512
		lw $t1, 0($t0)
		sw $t2, 0($t0)
		addi $t0, $t0, 512
		sw $t1, 0($t0)
		addi $t3, $t3, 4
		beq $t3, 16, gravEnd
		addi $a1, $a1, 4
		j changePosGravEach
	gravEnd:
		jr $ra
winScreen:
	li $t0, baseAddress
	li $t1, 0x000000
	addi $t2, $zero, 0
	reloadMapWin:
		beq $t2, 8192, winScreenShow
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		addi $t2, $t2, 4
		j reloadMapWin
winScreenShow:
	li $t0, baseAddress
	li $t1, 0xffffff
	# Write You Win
	sw $t1, 4160($t0) #Y
	sw $t1, 4416($t0)
	sw $t1, 4672($t0)
	
	sw $t1, 4676($t0)
	sw $t1, 4680($t0)
	sw $t1, 4684($t0)
	
	sw $t1, 4172($t0)
	sw $t1, 4428($t0)
	sw $t1, 4684($t0)
	sw $t1, 4940($t0)
	
	sw $t1, 4180($t0) #O
	sw $t1, 4436($t0)
	sw $t1, 4692($t0)
	sw $t1, 4948($t0)
	sw $t1, 4184($t0)
	sw $t1, 4188($t0)
	sw $t1, 4192($t0)
	sw $t1, 4448($t0)
	sw $t1, 4704($t0)
	sw $t1, 4960($t0)
	sw $t1, 4952($t0)
	sw $t1, 4956($t0)
	
	sw $t1, 4968($t0) #U
	sw $t1, 4972($t0)
	sw $t1, 4976($t0)
	sw $t1, 4980($t0)
	sw $t1, 4712($t0)
	sw $t1, 4456($t0)
	sw $t1, 4200($t0)
	sw $t1, 4724($t0)
	sw $t1, 4468($t0)
	sw $t1, 4212($t0)
	
	sw $t1, 4992($t0) #W
	sw $t1, 4736($t0)
	sw $t1, 4480($t0)
	sw $t1, 4224($t0)
	sw $t1, 4996($t0)
	sw $t1, 5000($t0)
	sw $t1, 5004($t0)
	sw $t1, 4748($t0)
	sw $t1, 4744($t0)
	sw $t1, 4492($t0)
	sw $t1, 4236($t0)
	
	sw $t1, 5012($t0) #I
	sw $t1, 5016($t0)
	sw $t1, 5020($t0)
	sw $t1, 5024($t0)
	sw $t1, 4760($t0)
	sw $t1, 4504($t0)
	sw $t1, 4248($t0)
	sw $t1, 4244($t0)
	sw $t1, 4252($t0)
	sw $t1, 4256($t0)
	
	sw $t1, 5032($t0) #N
	sw $t1, 4776($t0)
	sw $t1, 4520($t0)
	sw $t1, 4264($t0)
	sw $t1, 4268($t0)
	sw $t1, 4528($t0)
	sw $t1, 4532($t0)
	sw $t1, 4788($t0)
	sw $t1, 5044($t0)
	sw $t1, 4276($t0)
	
	li $v0, 32
	li $a0, 10000
	syscall
	j clear

loseScreen:
	li $t0, baseAddress # $t0 stores the base address for display
	li $t1, 0x000000
	addi $t2, $zero, 0
	reloadMapLose:
		beq $t2, 8192, loseScreenShow
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		addi $t2, $t2, 4
		j reloadMapLose

loseScreenShow:
	li $t0, baseAddress
	li $t1, 0xffffff
	# Write You Lose
	sw $t1, 4160($t0) #Y
	sw $t1, 4416($t0)
	sw $t1, 4672($t0)
	
	sw $t1, 4676($t0)
	sw $t1, 4680($t0)
	sw $t1, 4684($t0)
	
	sw $t1, 4172($t0)
	sw $t1, 4428($t0)
	sw $t1, 4684($t0)
	sw $t1, 4940($t0)
	
	sw $t1, 4180($t0) #O
	sw $t1, 4436($t0)
	sw $t1, 4692($t0)
	sw $t1, 4948($t0)
	sw $t1, 4184($t0)
	sw $t1, 4188($t0)
	sw $t1, 4192($t0)
	sw $t1, 4448($t0)
	sw $t1, 4704($t0)
	sw $t1, 4960($t0)
	sw $t1, 4952($t0)
	sw $t1, 4956($t0)
	
	sw $t1, 4968($t0) #U
	sw $t1, 4972($t0)
	sw $t1, 4976($t0)
	sw $t1, 4980($t0)
	sw $t1, 4712($t0)
	sw $t1, 4456($t0)
	sw $t1, 4200($t0)
	sw $t1, 4724($t0)
	sw $t1, 4468($t0)
	sw $t1, 4212($t0)
	
	sw $t1, 4992($t0) #L
	sw $t1, 4736($t0)
	sw $t1, 4480($t0)
	sw $t1, 4224($t0)
	sw $t1, 4996($t0)
	sw $t1, 5000($t0)
	sw $t1, 5004($t0)
	
	sw $t1, 5012($t0) #O
	sw $t1, 5016($t0)
	sw $t1, 5020($t0)
	sw $t1, 5024($t0)
	sw $t1, 4756($t0)
	sw $t1, 4768($t0)
	sw $t1, 4500($t0)
	sw $t1, 4512($t0)
	sw $t1, 4248($t0)
	sw $t1, 4244($t0)
	sw $t1, 4252($t0)
	sw $t1, 4256($t0)
	
	sw $t1, 5036($t0) #S
	sw $t1, 5040($t0)
	sw $t1, 5044($t0)
	sw $t1, 4788($t0)
	sw $t1, 4784($t0)
	sw $t1, 4780($t0)
	sw $t1, 4776($t0)
	sw $t1, 4520($t0)
	sw $t1, 4264($t0)
	sw $t1, 4268($t0)
	sw $t1, 4272($t0)
	sw $t1, 4276($t0)
	
	sw $t1, 5052($t0) #E
	sw $t1, 5056($t0)
	sw $t1, 5060($t0)
	sw $t1, 5064($t0)
	sw $t1, 4796($t0)
	sw $t1, 4540($t0)
	sw $t1, 4544($t0)
	sw $t1, 4548($t0)
	sw $t1, 4284($t0)
	sw $t1, 4288($t0)
	sw $t1, 4292($t0)
	sw $t1, 4296($t0)
	
	li $v0, 32
	li $a0, 10000
	syscall
	j clear
		
	
