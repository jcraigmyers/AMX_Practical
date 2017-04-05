MODULE_NAME='Lexicon_RT20_UI'  (DEV vdvDevice, DEV dvTP, INTEGER nCHAN_BTN[], INTEGER nTXT_BTN[])
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE
	
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)

POWER_ON_BTN = 1	// POWER ON
POWER_OFF_BTN = 2 // POWER OFF

V_MUTE_BTN = 3		//VIDEO MUTE

EJECT_BTN = 4			// EJECT
PLAY_BTN = 5			// PLAY
STOP_BTN = 6			// STOP
PAUSE_BTN = 7			// PAUSE
FRAME_FWD_BTN = 8	// FRAME FORWARD
REW_BTN = 9			  // SKIP PREVIOUS
FFWD_BTN = 10			// SKIP NEXT
SREV_BTN = 11  		// SCAN REWIND
SFWD_BTN = 12	 		// SCAN FORWARD
SLOW_REV_BTN = 13 // SLOW REWIND
SLOW_FWD_BTN = 14 // SLOW FORWARD

DISC_RANDOM_CYCLE_BTN = 15 // RANDOM
DISC_REPEAT_CYCLE_BTN = 16 // REPEAT

AR_LETTERBOX_BTN = 17	// LETTER BOX ASPECT
AR_PANSCAN_BTN = 18 	// PANSCAN ASPECT
AR_WIDE_BTN = 19 			// WIDE ASPECT
AR_SQUEEZE_BTN = 20		// SQUEEZE ASPECT
AR_CYCLE_BTN = 21			// CYCLE ASPECT RATIO

MENU_BTN  = 22			 	// MENU
MENU_EXIT_BTN = 23	 	// MENU EXIT
MENU_PAGE_UP_BTN = 24 // PAGE UP
MENU_PAGE_DN_BTN = 25	// PAGE DOWN
MENU_UP_BTN = 26			// NAVIGATE UP
MENU_DN_BTN = 27			// NAVIGATE DOWN
MENU_RT_BTN = 28			// NAVIGATE RIGHT
MENU_LT_BTN = 29			// NAVIGATE LEFT
MENU_ENTER_BTN = 30		// ENTER
MENU_TOP_MENU_BTN =31 // TOP MENU
MENU_SUBTITLE_BTN =32 // SUBTITLE	
MENU_PROGRAM_BTN = 33	// PROGRAM
MENU_SEARCH_BTN = 34	// SEARCH 
MENU_RETURN_BTN = 35 	// RETURN
MENU_DISPLAY_BTN = 36 // DISPLAY
MENU_ANGLE_BTM = 37		// ANGLE
MENU_AUDIO_BTN = 38		// AUDIO
MENU_DIMMER_BTN = 39	// DIMMER
MENU_ZOOM_BTN = 40		// ZOOM
MENU_AB_REPEAT_BTN =41// REPEAT

MENU_CLEAR_BTN = 42		// CLEAR
MENU_PLUS_10_BTN = 43	// 10+
KEYPAD_DIGIT_0_BTN = 44	//KEYPAD 0
KEYPAD_DIGIT_1_BTN = 45	//KEYPAD 1
KEYPAD_DIGIT_2_BTN = 46	//KEYPAD 2
KEYPAD_DIGIT_3_BTN = 47	//KEYPAD 3
KEYPAD_DIGIT_4_BTN = 48	//KEYPAD 4
KEYPAD_DIGIT_5_BTN = 49	//KEYPAD 5
KEYPAD_DIGIT_6_BTN = 50	//KEYPAD 6
KEYPAD_DIGIT_7_BTN = 51	//KEYPAD 7
KEYPAD_DIGIT_8_BTN = 52	//KEYPAD 8
KEYPAD_DIGIT_9_BTN = 53	//KEYPAD 9

DATA_INITIALZIED_BTN = 54 // DATA INITIALIZED
DEVICE_ONLINE_BTN = 55	// DEVICE ONLNE

VIDEO_MUTE_CHANNEL_FB = 301
VIDEO_MUTE_CHANNEL = 302
MENU_SEARCH_CHANNEL = 303

#INCLUDE 'SNAPI.axi'
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

VOLATILE INTEGER nAspect = 0     // STORES THE CURRENT ASPECT RATIO
VOLATILE INTEGER nDEBUG = 1  		 // STORES THE CURRENT SETTING OF THE DEBUG MSG FLAG
VOLATILE CHAR sVERSION[20] = ''  // STORES NETLINX COMM MODULE VERSION NUMBER

CHAR sAR[4][50] = 
{
'WIDESCREEN', // Letter Box
'NORMAL', 		// Panscan
'ANAMORPHIC',	// Wide
'SQUEEZE'			// Squeeze
}

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
//
// Function : fnPARSE()
// Purpose  : STRING PARSING USING A DELIMITER
// Params   : CHAR cDELIMITER[], CHAR cSTRING[], CHAR cNEW_STRING[][]
// Return   : nCOUNTER
// Notes    : THIS FUNCTION PARSES A STRING USING A DELIMITER PASSED BY THE USER. 
//            MAXIMUM OF 10 PARAMETERS OF LENGTH 50 EACH- DELIMITER CAN HAVE LENGTH 1 OR 2.
//            THIS FUNCTION RETURNS THE NUMBER OF PARAMETERES PARSED. cNEW_STRING CONTAINS THE PARSED INFO.

DEFINE_FUNCTION INTEGER fnPARSE(CHAR cDELIMITER[2], CHAR cSTRING[500], CHAR cNEW_STRING[11][50])
{
	STACK_VAR INTEGER nCOUNTER
	nCOUNTER=0
	WHILE(nCOUNTER<=10)
	{
		IF(FIND_STRING(cSTRING,"cDELIMITER",1))  
		{
			cNEW_STRING[nCOUNTER+1]=REMOVE_STRING(cSTRING,"cDELIMITER",1)
			SET_LENGTH_STRING(cNEW_STRING[nCOUNTER+1],LENGTH_STRING(cNEW_STRING[nCOUNTER+1])-LENGTH_STRING(cDELIMITER))
			nCOUNTER++
		}
		ELSE
		{
			cNEW_STRING[nCOUNTER+1]=cSTRING
			IF(LENGTH_STRING(cSTRING))
				nCOUNTER++
			BREAK  
		}
	}
	RETURN nCOUNTER
}
(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

BUTTON_EVENT[dvTP,nCHAN_BTN]
{
	PUSH:
	{
			STACK_VAR INTEGER nIndex
			STACK_VAR INTEGER nDefPulseTime
			
			nIndex = GET_LAST(nCHAN_BTN)
			nDefPulseTime = GET_PULSE_TIME
	
			SWITCH(nIndex)
			{
				CASE POWER_ON_BTN: // Discrete Power On
				{
					PULSE[vdvDEVICE, PWR_ON]
					BREAK
				}
				CASE POWER_OFF_BTN:	// Discrete Power Off
				{
					PULSE[vdvDEVICE, PWR_OFF]
					BREAK	
				}
				CASE  V_MUTE_BTN: // CYCLE V-MUTE
				{
						PULSE[vdvDEVICE, VIDEO_MUTE_CHANNEL]
						BREAK
				}
				CASE EJECT_BTN:
				{
					PULSE[vdvDevice, DISC_TRAY]
					BREAK
				}
				CASE STOP_BTN:
				{
					PULSE[vdvDEVICE, STOP]
					BREAK
				}
				CASE PLAY_BTN:
				{
					PULSE[vdvDEVICE, PLAY]
					BREAK
				}
				CASE PAUSE_BTN:
				{
					PULSE[vdvDEVICE, PAUSE]
					BREAK
				}
				CASE SLOW_FWD_BTN:
				{
					PULSE[vdvDEVICE, SLOW_FWD]
					BREAK
				}
				CASE SLOW_REV_BTN:
				{
					PULSE[vdvDEVICE, SLOW_REV]
					BREAK
				}
				CASE SFWD_BTN:
				{
					PULSE[vdvDEVICE, SFWD]
					BREAK
				}
				CASE SREV_BTN:
				{
					PULSE[vdvDEVICE, SREV]
					BREAK
				}
				CASE FFWD_BTN:
				{
					PULSE[vdvDEVICE, FFWD]
					BREAK
				}
				CASE REW_BTN:
				{
					PULSE[vdvDEVICE, REW]
					BREAK
				}
				CASE FRAME_FWD_BTN:
				{
					PULSE[vdvDEVICE, FRAME_FWD]
					BREAK
				}
				CASE DISC_RANDOM_CYCLE_BTN:
				{
					PULSE[vdvDEVICE, DISC_RANDOM]
					BREAK
				}
				CASE DISC_REPEAT_CYCLE_BTN:
				{
					PULSE[vdvDEVICE, DISC_REPEAT]
					BREAK
				}
				CASE AR_LETTERBOX_BTN:	// ASPECT RATIO
				CASE AR_PANSCAN_BTN:
				CASE AR_WIDE_BTN:
				CASE AR_SQUEEZE_BTN:
				{
					SEND_COMMAND vdvDEVICE, "'ASPECT-',sAR[BUTTON.INPUT.CHANNEL - AR_LETTERBOX_BTN + 1]"
					BREAK
				}
				CASE AR_CYCLE_BTN:
				{
					SEND_COMMAND vdvDEVICE, "'ASPECT-+'"
					BREAK;
				}
				CASE MENU_BTN : // Menu 
				{
					PULSE[vdvDEVICE, MENU_FUNC]
					BREAK
				}
				CASE MENU_EXIT_BTN:
				{
					PULSE[vdvDEVICE, MENU_EXIT]
					BREAK
				}
				CASE MENU_PAGE_UP_BTN:	
				{
					PULSE[vdvDevice,MENU_PAGE_UP]
					BREAK
				}
				CASE MENU_PAGE_DN_BTN:	
				{
					PULSE[vdvDevice,MENU_PAGE_DN]
					BREAK
				}
				CASE MENU_ENTER_BTN:
				{
					PULSE[vdvDEVICE, MENU_ENTER]
					BREAK
				}
				CASE MENU_RETURN_BTN:
				{
					PULSE[vdvDEVICE, MENU_RETURN]
					BREAK
				}
				CASE MENU_TOP_MENU_BTN:
				{
					PULSE[vdvDEVICE, MENU_TOP_MENU]
					BREAK
				}
				CASE MENU_CLEAR_BTN:
				{
					PULSE[vdvDEVICE, MENU_CLEAR]
					BREAK
				}
				CASE MENU_UP_BTN:
				{
					PULSE[vdvDEVICE, MENU_UP]
					BREAK
				}
				CASE MENU_DN_BTN:
				{
					PULSE[vdvDEVICE, MENU_DN]
					BREAK
				}
				CASE MENU_LT_BTN:
				{
					PULSE[vdvDEVICE, MENU_LT]
					BREAK
				}
				CASE MENU_RT_BTN:
				{
					PULSE[vdvDEVICE, MENU_RT]
					BREAK
				}
				CASE MENU_SUBTITLE_BTN:	
				{
					PULSE[vdvDevice,MENU_SUBTITLE]
					BREAK
				}
				CASE MENU_AUDIO_BTN:	
				{
					PULSE[vdvDevice,MENU_AUDIO]
					BREAK
				}
				CASE MENU_PLUS_10_BTN:	
				{
					PULSE[vdvDevice,MENU_PLUS_10]
					BREAK
				}
				CASE MENU_DISPLAY_BTN:	
				{
					PULSE[vdvDevice,MENU_DISPLAY]
					BREAK
				}
				CASE MENU_DIMMER_BTN:	
				{
					PULSE[vdvDevice,MENU_DIMMER]
					BREAK
				}
				CASE MENU_ANGLE_BTM:
				{
					PULSE[vdvDEVICE, MENU_ANGLE]
					BREAK
				}
				CASE MENU_AB_REPEAT_BTN:
				{
					PULSE[vdvDEVICE, MENU_AB_REPEAT]
					BREAK
				}
				CASE MENU_ZOOM_BTN:
				{
					PULSE[vdvDEVICE, MENU_ZOOM]
					BREAK
				}
				CASE MENU_PROGRAM_BTN:
				{
					PULSE[vdvDEVICE, MENU_PROGRAM]
					BREAK
				}
				CASE MENU_SEARCH_BTN:
				{
					PULSE[vdvDevice, MENU_SEARCH_CHANNEL]
					BREAK
				}
				CASE KEYPAD_DIGIT_0_BTN:
				{
					PULSE[vdvDevice,DIGIT_0]
					BREAK
				}
				CASE KEYPAD_DIGIT_1_BTN:	
				{
					PULSE[vdvDevice,DIGIT_1]
					BREAK
				}
				CASE KEYPAD_DIGIT_2_BTN:	
				{
					PULSE[vdvDevice,DIGIT_2]
					BREAK
				}
				CASE KEYPAD_DIGIT_3_BTN:	
				{
					PULSE[vdvDevice,DIGIT_3]
					BREAK
				}
				CASE KEYPAD_DIGIT_4_BTN:	
				{
					PULSE[vdvDevice,DIGIT_4]
					BREAK
				}
				CASE KEYPAD_DIGIT_5_BTN:	
				{
					PULSE[vdvDevice,DIGIT_5]
				}
				CASE KEYPAD_DIGIT_6_BTN:	
				{
					PULSE[vdvDevice,DIGIT_6]
					BREAK
				}
				CASE KEYPAD_DIGIT_7_BTN:	
				{
					PULSE[vdvDevice,DIGIT_7]
					BREAK
				}
				CASE KEYPAD_DIGIT_8_BTN:	
				{
					PULSE[vdvDevice,DIGIT_8]
					BREAK
				}
				CASE KEYPAD_DIGIT_9_BTN:	
				{
					PULSE[vdvDevice,DIGIT_9]
					BREAK
				}		
		}
	}
}

 

//
// Feedback from comm module to touch panel
//
DATA_EVENT[vdvDEVICE]	// MAIN ROOM
{
	COMMAND:
	{
		STACK_VAR CHAR datum[30]
		STACK_VAR CHAR cCOMMAND[20][20]
		
		IF (nDEBUG > 2) 
			SEND_STRING 0, "'UI/Virtual Device 1 received from Comm: ',data.text" 
		datum  = remove_string(data.text, '-', 1)
        
		SWITCH(datum) {
			CASE 'ASPECT-':
			{
			   STACK_VAR INTEGER INDEX

					FOR(INDEX = 1; INDEX <= LENGTH_ARRAY(sAR); INDEX++) {
						IF (FIND_STRING(sAR[INDEX], DATA.TEXT, 1)) {
							nAspect = INDEX;
							BREAK
						}
					}
				BREAK
			}
			CASE 'TITLECOUNTER-':
			{
				SEND_COMMAND dvTP, "'@TXT',1,DATA.TEXT" 
			}
			CASE 'TITLEINFO-':
			{
				fnPARSE(',',DATA.TEXT,cCOMMAND)
				IF(cCOMMAND[1] == '-2147483648')
				{
					SEND_COMMAND dvTP, "'@TXT',2,'TITLE: --'"//TITLE
				}
				ELSE
				{
					SEND_COMMAND dvTP, "'@TXT',2,'TITLE: ',cCOMMAND[1]"//TITLE
				}				
			}
			CASE 'TRACKCOUNTER-':
			{
				SEND_COMMAND dvTP, "'@TXT',1,DATA.TEXT" 
			}
			CASE 'TRACKINFO-':
			{
				SEND_COMMAND dvTP, "'@TXT',3,DATA.TEXT"
				fnPARSE(',',DATA.TEXT, cCOMMAND)
				IF(cCOMMAND[1] == '-2147483648')
				{
					SEND_COMMAND dvTP, "'@TXT',3,'CHP/TRK: -- '"//CHAPTER
				}
				ELSE
				{
					SEND_COMMAND dvTP, "'@TXT',3,'CHP/TRK: ',cCOMMAND[1]"//CHAPTER
				}
			}
			CASE 'VERSION-': 
			{
				sVERSION = DATA.TEXT 
			}
			CASE 'DEBUG-': {
				nDebug = atoi(data.text)
				IF (nDebug)  
					SEND_STRING 0, "'Debug messages are now on.'" 
				ELSE  
					SEND_STRING 0, "'Debug messages are now off.'" 
				BREAK
			}
		}
	}
}


(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

// DEVICE ONLINE
[dvTP, nCHAN_BTN[DEVICE_ONLINE_BTN]] = [vdvDEVICE, DEVICE_COMMUNICATING]

// DATA INITAILIZED
[dvTP, nCHAN_BTN[DATA_INITIALZIED_BTN]]	= [vdvDEVICE, DATA_INITIALIZED]

// POWER FEEDBACK
[dvTP, nCHAN_BTN[POWER_ON_BTN]] = [vdvDEVICE, POWER_FB]		// DISCRETE POWER ON
[dvTP, nCHAN_BTN[POWER_OFF_BTN]] = ![vdvDEVICE, POWER_FB]	// DISCRETE POWER OFF

// PICTURE MUTE FEEDBACK
[dvTP, nCHAN_BTN[V_MUTE_BTN]] = [vdvDEVICE, VIDEO_MUTE_CHANNEL_FB] 	// MUTE

// ASPECT FEEDBACK
[dvTP, nCHAN_BTN[AR_LETTERBOX_BTN]] = (nAspect == 1)  
[dvTP, nCHAN_BTN[AR_PANSCAN_BTN]] = (nAspect == 2)  
[dvTP, nCHAN_BTN[AR_WIDE_BTN]] = (nAspect == 3)  
[dvTP, nCHAN_BTN[AR_SQUEEZE_BTN]] = (nAspect == 4)  

// DISC TRANSPORT FEEDBACK
[dvTP,nCHAN_BTN[STOP_BTN]] 	=	[vdvDEVICE,STOP_FB] 
[dvTP,nCHAN_BTN[PLAY_BTN]] 	=	[vdvDEVICE,PLAY_FB]
[dvTP,nCHAN_BTN[PAUSE_BTN]] 	=	[vdvDEVICE,PAUSE_FB]
[dvTP,nCHAN_BTN[SLOW_FWD_BTN]] 	=	[vdvDEVICE,SLOW_FWD_FB]
[dvTP,nCHAN_BTN[SLOW_REV_BTN]] 	=	[vdvDEVICE,SLOW_REV_FB]
[dvTP,nCHAN_BTN[SFWD_BTN]] 	=	[vdvDEVICE,SFWD_FB]
[dvTP,nCHAN_BTN[SREV_BTN]] 	=	[vdvDEVICE,SREV_FB]


(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
