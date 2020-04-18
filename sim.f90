
! gfortran -o simf90 sim.f90

PROGRAM  MontyHallGameSim
	IMPLICIT  NONE

	INTEGER  :: n, r             ! number of doors, number of losing doors revealed by host
	INTEGER  :: nn=10000000      ! number of simulations
	LOGICAL  :: Cond_a, Cond_b   ! two logical conditions
   
	INTEGER   :: i, j, jj, kk
	INTEGER   :: door_prize, door_select, xndx_p, xndx_s, door_switch
   
	INTEGER, DIMENSION(:), ALLOCATABLE  :: d_space
   
	INTEGER, DIMENSION(:), ALLOCATABLE  :: doors_can_reveal
	INTEGER, DIMENSION(:), ALLOCATABLE  :: doors_revealed
	INTEGER, DIMENSION(:), ALLOCATABLE  :: doors_can_switch_to
	INTEGER, DIMENSION(:), ALLOCATABLE  :: doors_not_available_for_switch
  
	LOGICAL    :: xcan_use
	INTEGER    :: bigSum_os, bigSum_sw
	REAL       :: prop_sw, prop_os
	REAL       :: u
   
	!n = 3
	!r = 1

	WRITE(*,*) "enter number of doors . . ."
	READ(*,*)  n
	WRITE(*,*) "enter number of revealed losing doors . . ."
	READ(*,*)  r
   
	IF(r > n-2) THEN
		WRITE(*,*) "Number of revealed losing doors must be < n - 1 -- stopping"
		STOP
	END IF
   
	ALLOCATE( d_space(n) )   
    
	ALLOCATE( doors_can_reveal(n-1) ) 
	ALLOCATE( doors_revealed(r) ) 
	ALLOCATE( doors_can_switch_to(n-r-1) ) 
	ALLOCATE( doors_not_available_for_switch(r+1) ) 
   
	DO i = 1,n
		d_space(i) = i
	END DO
   
	bigSum_os = 0
	bigSum_sw = 0
  
	DO i = 1,nn
		CALL RANDOM_NUMBER(u)
		xndx_p = CEILING(u*n)
		CALL RANDOM_NUMBER(u)
		xndx_s = CEILING(u*n)
	
		door_prize  = d_space( xndx_p )   !since fortran is 1 indexed, can equivalently simply assign xndx_p
		door_select = d_space( xndx_s )   
	
		kk = 1
		DO j = 1,n
			IF( (d_space(j) /= door_prize) .AND. (d_space(j) /= door_select)  ) THEN
				doors_can_reveal(kk) = d_space(j) ;
				kk = kk + 1 ;
			END IF
		END DO
	
		DO j = 1,r
			doors_revealed(j) = doors_can_reveal(j)    ! deterministic
		END DO
	
		doors_not_available_for_switch(1) = door_select
		DO jj = 1,r
			doors_not_available_for_switch(jj+1) = doors_revealed(jj)
		END DO
	
	

		DO j = 1,n
			xcan_use = .true.
			DO jj = 1,r+1
				IF( d_space( j ) == doors_not_available_for_switch(jj) ) THEN
					xcan_use = .false.
				END IF
			END DO
           
			IF(xcan_use) THEN ! deterministic -- first available
				door_switch = d_space( j )
				GOTO 96
			END IF
		END DO
	
		!  goto here
		96 CONTINUE 
	   
	   
	   
		IF(door_prize == door_select) THEN
			bigSum_os = bigSum_os + 1
		END IF
        
		IF(door_prize == door_switch) THEN
			bigSum_sw = bigSum_sw + 1 ;
		END IF
	
	
	END DO 

	prop_os = REAL(bigSum_os) / nn ;
	prop_sw = REAL(bigSum_sw) / nn ;
   
	WRITE(*,*) "total number of simulations:                ",  nn
	WRITE(*,*) "number of wins with original selection:     ",  bigSum_os
	WRITE(*,*) "number of wins by switching:                ",  bigSum_sw
	WRITE(*,*) "proportion of wins with original selection: ",  prop_os
	WRITE(*,*) "proportion of wins by switching:            ",  prop_sw


END PROGRAM  MontyHallGameSim


