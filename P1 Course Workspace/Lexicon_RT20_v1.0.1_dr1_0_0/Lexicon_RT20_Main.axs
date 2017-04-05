PROGRAM_NAME='Lexicon_RT20_Main'
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE
	dvDEVICE   = 5001:1:0			// Lexicon RT20, Serial Port
	dvTP       = 10001:1:0    // Touch Panel
	vdvDEVICE  = 41001:1:0		// Virtual Device
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE


VOLATILE INTEGER nTP_BUTTONS[] = {
1,				// POWER ON
2, 				// POWER OFF
3,				// VIDEO MUTE
4, 				// EJECT
5,				// PLAY
6,				// STOP
7,				// PAUSE
8,				// FRAME FORWARD
9,				// SKIP NEXT
10,				// SKIP PREVIOUS
11,  			// SCAN FORWARD
12,	 			// SCAN REWIND
13, 			// SLOW FORWARD
14, 			// SLOW REWIND
15, 			// RANDOM
16, 			// REPEAT
17,				// LETTER BOX ASPECT
18, 			// PANSCAN ASPECT
19,				// WIDE ASPECT
20,				// SQUEEZE ASPECT
21,				// CYCLE ASPECT RATIO
22,			 	// MENU
23,	 			// MENU EXIT
24,				// PAGE UP
25,				// PAGE DOWN
26,				// NAVIGATE UP
27,				// NAVIGATE DOWN
28,				// NAVIGATE RIGHT
29,				// NAVIGATE LEFT
30,				// ENTER
31, 			// TOP MENU
32, 			// SUBTITLE	
33,				// PROGRAM
34,				// SEARCH 
35, 			// RETURN
36, 			// DISPLAY
37,				// ANGLE
38,				// AUDIO
39,				// DIMMER
40,				// ZOOM
41,				// REPEAT
42,				// CLEAR
43,				// 10+
44,				// KEYPAD 0
45,				// KEYPAD 1
46,				// KEYPAD 2
47,				// KEYPAD 3
48,				// KEYPAD 4
49,				// KEYPAD 5
50,				// KEYPAD 6
51,				// KEYPAD 7
52,				// KEYPAD 8
53,				// KEYPAD 9
54,				// DATA INITIALIZED
55				// DEVICE ONLNE
} //  BUTTON CHANNELS ON TOUCH PANEL

VOLATILE INTEGER nTXT_BTN[] = { 
1
} // TEXT BUTTONS ON TOUCH PANEL

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
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_MODULE 'Lexicon_RT20_Comm_dr1_0_0' COMM1(vdvDEVICE, dvDEVICE)
DEFINE_MODULE 'Lexicon_RT20_UI'	TP1(vdvDEVICE, dvTP, nTP_BUTTONS, nTXT_BTN)

DEFINE_EVENT

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

