PROGRAM_NAME='P1_Exercises_J_Myers'
(***********************************************************)
(*  FILE CREATED ON: 06/11/2016  AT: 16:40:06              *)
(***********************************************************)
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 07/23/2016  AT: 15:25:18        *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    $History: $
*)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE


//RS232 Devices
dvDVD			= 5001:1:0;	// Tascam on RS232 Port 1
dvProj			= 5001:2:0	// Epson PowerLite 905
dvBSS_Blu50		= 5001:4:0;	// Blu50
//IR
dvAppleTV 		= 5001:13:0;	// Apple TV on IR Port 3
//Relays
dvRelays		= 5001:21:0;	// Relays
//TP
dvTP			= 10001:1:0;	// TP
dvTP_AppleTV		= 10001:4:0;	// Apple TV Buttons
dvTP_DVD		= 10001:5:0;	// Tascam Buttons
//dvTP_Lift		= 10001:6:0;	// Proj Lift
dvTP_Proj		= 10001:6:0;	// Proj Control
dvTP_Sensors		= 10001:7:0	// Sensors
dvTP_AudioRouter	= 10001:9:0	// Audio
//Virtual Devices
vdvDVD			= 41001:1:0;	// Tascam Virtual
vdvProj			= 41002:1:0;	// Epson Virtual
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
//BUTTONS
RELAY_1_ON		= 301;
RELAY_1_OFF		= 302;
RELAY_2_PULSE		= 303;
RELAY_3_TO		= 304;
RELAY_4_MIN_TO 		= 305;
LIFT_UP			= 601;
LIFT_DOWN		= 602;
//RELAYS
RELAY_1			= 1;
RELAY_2			= 2;
RELAY_3			= 3;
RELAY_4			= 4;
RELAY_7			= 7;
RELAY_8			= 8;
//Projector Status
PROJECTOR_OFF		= 0;
PROJECTOR_ON		= 1;
PROJECTOR_COOLING 	= 2;
PROJECTOR_WARMING	= 3;
//Projector Lift Status
LIFT_IS_UP		= 0;
LIFT_IS_DOWN		= 1;

//Timeline Constant
long TL_FEEDBACK	= 1;
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

non_volatile integer nLiftStatus;
volatile integer nProjectorStatus;

volatile integer nAspectRatioButtons[]=
{
    101,102,103,104,105,106,107
};

volatile char sAspectRatioCommands[][17]=
{
    'ASPECT-NORMAL',
    'ASPECT-ASPECT16_9',
    'ASPECT-AUTO',
    'ASPECT-ASPECT4_3',
    'ASPECT-FULL',
    'ASPECT-ZOOM',
    'ASPECT-NATIVE'
};

volatile integer nProjLiftBtns[]=
{
    27,
    28,
    601,
    602
};

volatile long lFeedBackTime[]=
{
    100	// 100ms
};

volatile integer nAudioRouterButton[]=
{
    41,42,51,52
};

volatile integer nSelectedInput;	
volatile integer nSelectedOutput;

volatile integer nRouteButtons[]=
{
    101,102,103,104
};
volatile char sRoute[4][18];
volatile char sUnRoute[4][18];
volatile char sSubscribe[4][18];
volatile integer nMatrixRouterStatus[4];
(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

([dvRelays,RELAY_7],[dvRelays,Relay_8])

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

define_function fnParseBlu(char sToParse[18])
{
    local_var char cStatusByte;
    local_var char cChecksumByte;
    
    cStatusByte = type_cast(mid_string(sToParse,16,1));
    cChecksumByte = type_cast(mid_string(sToParse,17,1));
    select 
    {
	active(cStatusByte == "$01" && cChecksumByte == "$17"):
	{
	    on[dvTP_AudioRouter,101];
	}
	active(cStatusByte == "$01" && cChecksumByte == "$16"):
	{
	    on[dvTP_AudioRouter,102];
	}
	active(cStatusByte == "$01" && cChecksumByte == "$97"):
	{
	    on[dvTP_AudioRouter,103];
	}
	active(cStatusByte == "$01" && cChecksumByte == "$96"):
	{
	    on[dvTP_AudioRouter,104];
	}
	  active(cStatusByte == "$00" && cChecksumByte == "$17"):
	{
	    off[dvTP_AudioRouter,101];
	}
	active(cStatusByte == "$00" && cChecksumByte == "$16"):
	{
	    off[dvTP_AudioRouter,102];
	}
	active(cStatusByte == "$00" && cChecksumByte == "$97"):
	{
	    off[dvTP_AudioRouter,103];
	}
	active(cStatusByte == "$00" && cChecksumByte == "$96"):
	{
	    off[dvTP_AudioRouter,104];
	}
	
    }
}

#include 'SNAPI.axi';
#include 'Apple TV Control.axi';
(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
//Init Array
sRoute[1] = "$02,$88,$19,$87,$1B,$83,$00,$01,$1B,$82,$00,$00,$00,$00,$00,$01,$17,$03";
sRoute[2] = "$02,$88,$19,$87,$1B,$83,$00,$01,$1B,$82,$00,$01,$00,$00,$00,$01,$16,$03";
sRoute[3] = "$02,$88,$19,$87,$1B,$83,$00,$01,$1B,$82,$00,$80,$00,$00,$00,$01,$97,$03";
sRoute[4] = "$02,$88,$19,$87,$1B,$83,$00,$01,$1B,$82,$00,$81,$00,$00,$00,$01,$96,$03";

sUnRoute[1] = "$02,$88,$19,$87,$1B,$83,$00,$01,$1B,$82,$00,$00,$00,$00,$00,$00,$16,$03";
sUnRoute[2] = "$02,$88,$19,$87,$1B,$83,$00,$01,$1B,$82,$00,$01,$00,$00,$00,$00,$17,$03";
sUnRoute[3] = "$02,$88,$19,$87,$1B,$83,$00,$01,$1B,$82,$00,$80,$00,$00,$00,$00,$96,$03";
sUnRoute[4] = "$02,$88,$19,$87,$1B,$83,$00,$01,$1B,$82,$00,$81,$00,$00,$00,$00,$97,$03";

sSubscribe[1] = "$02,$89,$19,$87,$1B,$83,$00,$01,$1B,$82,$00,$00,$00,$00,$00,$00,$17,$03";
sSubscribe[2] = "$02,$89,$19,$87,$1B,$83,$00,$01,$1B,$82,$00,$01,$00,$00,$00,$00,$16,$03";
sSubscribe[3] = "$02,$89,$19,$87,$1B,$83,$00,$01,$1B,$82,$00,$80,$00,$00,$00,$00,$97,$03";
sSubscribe[4] = "$02,$89,$19,$87,$1B,$83,$00,$01,$1B,$82,$00,$81,$00,$00,$00,$00,$96,$03";

//Feedback Timeline
timeline_create(TL_Feedback,lFeedBackTime,length_array(lFeedBackTime),timeline_absolute,timeline_repeat);
//Timeline ID, time array, how many times in array?, absolute or relative?, run once or repeat?

define_module 'TASCAM_DVD01U_Comm_dr1_0_0' COMM_DVD_1 (vdvDVD, dvDVD);
define_module 'Epson_PowerLite905_Comm_dr1_0_0' COMM_PROJ_1 (vdvProj, dvProj);

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT


//Relay Controls
button_event[dvTP,RELAY_1_ON]
{
    push:
    {
	on[dvRelays,RELAY_1];
    }
}
button_event[dvTP,RELAY_1_OFF]
{
    push:
    {
	off[dvRelays,RELAY_1];
    }
}
button_event[dvTP,RELAY_2_PULSE]
{
    push:
    {
	set_pulse_time(10);
	pulse[dvRelays,RELAY_2];
	set_pulse_time(5);
    }
}
button_event[dvTP,RELAY_3_TO]
{
    push:
    {
	to[dvRelays,RELAY_3];
    }
}
button_event[dvTP,RELAY_4_MIN_TO]
{
    push:
    {
	set_pulse_time(10);
	min_to[dvTP,RELAY_4];
	set_pulse_time(5);
    }

}



//DVD Controls
button_event[dvTP_DVD,0]
{
    push:
    {
	to[vdvDVD,button.input.channel];
    }
}

//Proj Lift Controls
//button_event[dvTP_Proj,LIFT_UP]
//{
//    push:
//    {
//	on[dvRelays,RELAY_7];
//	wait 200
//	{
//	    off[dvRelays,RELAY_7];
//	}
//    }
//}
//button_event[dvTP_Proj,LIFT_DOWN]
//{
//    push:
//    {
//	on[dvRelays,RELAY_8];
//	wait 200
//	{
//	    off[dvRelays,RELAY_8];
//	}
//    }
//}
channel_event[dvRelays,Relay_7]
{
    on:
    {
	nLiftStatus=LIFT_IS_UP;
    }
}
channel_event[dvRelays,Relay_8]
{
    on:
    {
	nLiftStatus=LIFT_IS_DOWN; 
    }
}
//Proj Controls
button_event[dvTP_Proj,nProjLiftBtns]
{
    push:
    {
	switch(button.input.channel)
	{
	    case LIFT_UP:
	    {
		    if(nProjectorStatus == PROJECTOR_OFF)
		    {
		    on[dvRelays,RELAY_7];
		    wait 200
		    {
			off[dvRelays,RELAY_7];
		    }
		}
	    }
	    case LIFT_DOWN:
	    {
		on[dvRelays,RELAY_8];
		wait 200
		{
		    off[dvRelays,RELAY_8];
		}
	    }
	    case PWR_ON:
	    {
		if(nProjectorStatus == PROJECTOR_OFF);
		{
		   pulse[nProjectorStatus,PWR_ON];
		}
	    }
	    case PWR_OFF:
	    {
		if(nProjectorStatus == PROJECTOR_ON &&
		 !(nProjectorStatus == PROJECTOR_COOLING ||
		   nProjectorStatus == PROJECTOR_WARMING))
		{
		    pulse[vdvProj,PWR_OFF];
		}
	    }
	}
	
    }
}
//Aspect Ratio Buttons
button_event[dvTP_Proj,nAspectRatioButtons]
{
    push:
    {
	send_command vdvProj,"sAspectRatioCommands[get_last(nAspectRatioButtons)]";
	to[dvTP_Proj,button.input.channel];
    }
}



//Projector Feedback
channel_event[vdvProj,0]
    {
	on:
	{
	    switch(channel.channel)
	    {
		case LAMP_WARMING_FB:
		{
		    nProjectorStatus=PROJECTOR_WARMING;
		    if(nLiftStatus == LIFT_IS_UP)
		    {
			on[dvRelays,RELAY_8];
			wait 200
			{
			    off[dvRelays,RELAY_8];
			}
		    }
		}
		case LAMP_COOLING_FB:
		{
		    nProjectorStatus=PROJECTOR_COOLING;
		    if(nLiftStatus == LIFT_IS_DOWN)
		    {
			on[dvRelays,RELAY_7];
			wait 200
			{
			    off[dvRelays,RELAY_7];
			}
		    }
		}
		case POWER_FB:
		{
		    nProjectorStatus=PROJECTOR_ON;
		}
	    }
	}
	off:
	{
	    switch(channel.channel)
	    {
		case LAMP_WARMING_FB:
		{
		
		}
		case LAMP_COOLING_FB:
		{
		
		}
		case POWER_FB:
		{
		    nProjectorStatus=PROJECTOR_OFF;
		}
	    }
	}
    }
level_event[dvTP_Sensors,1]
{
   local_var integer nLightLevel;
   nLightLevel = level.value;
   send_level dvTP_Sensors,2,nLightLevel;
}

data_event[dvBSS_Blu50]
{
    online:
    {
	stack_var integer nLoop;
	send_command dvBSS_Blu50,"'SET BAUD 115200,N,8,1 485 DISABLE'";
//	send_string dvBSS_Blu50,"sSubscribe[1]";
//	send_string dvBSS_Blu50,"sSubscribe[2]";
//	send_string dvBSS_Blu50,"sSubscribe[3]";
//	send_string dvBSS_Blu50,"sSubscribe[4]";
	for(nLoop=1;nLoop<=4;nLoop++)
	{
	    send_string dvBSS_Blu50,"sSubscribe[nLoop]";
	}
	
	
	
    }
    string:
    {
	local_var char sFromBlu50[18];

	sFromBlu50 = data.text;
	fnParseBlu(sFromBlu50);
    }
}

button_event[dvTP_AudioRouter,nRouteButtons]
{
    push:
    {
	local_var integer nIndex;
	
	nIndex = (get_last(nRouteButtons));
	nMatrixRouterStatus[nIndex] = !nMatrixRouterStatus[nIndex];
	if(nMatrixRouterStatus[nIndex]==1)
	{
	    send_string dvBSS_Blu50,"sRoute[nIndex]";
	}
	else if(nMatrixRouterStatus[nIndex]==0)
	{
	    send_string dvBSS_Blu50,"sUnRoute[nIndex]";
	}
    }
}

//Feedback handling
timeline_event[TL_FEEDBACK]
{
    //Relay Feedback
    [dvTP,RELAY_1_ON]		= [dvRelays,RELAY_1];
    [dvTP,RELAY_1_OFF]		= ![dvRelays,RELAY_1];
    [dvTP,RELAY_2_PULSE]	= [dvRelays,RELAY_2];
    [dvTP,RELAY_3_TO]		= [dvRelays,RELAY_3];
    [dvTP,RELAY_4_MIN_TO]	= [dvRelays,RELAY_4];

    //Apple TV Feedback
    [dvTP_AppleTV,PLAY]		= [dvAppleTV,PLAY];
    [dvTP_AppleTV,MENU_FUNC]	= [dvAppleTV,MENU_FUNC];
    [dvTP_AppleTV,MENU_UP]	= [dvAppleTV,MENU_UP];
    [dvTP_AppleTV,MENU_DN]	= [dvAppleTV,MENU_DN];
    [dvTP_AppleTV,MENU_LT]	= [dvAppleTV,MENU_LT];
    [dvTP_AppleTV,MENU_RT]	= [dvAppleTV,MENU_RT];
    [dvTP_AppleTV,MENU_SELECT]	= [dvAppleTV,MENU_SELECT];

    //DVD RS232 Feedback
    [dvTP_DVD,PLAY] 		= [vdvDVD,PLAY_FB];
    [dvTP_DVD,STOP] 		= [vdvDVD,STOP_FB];
    [dvTP_DVD,PAUSE] 		= [vdvDVD,PAUSE_FB];
    [dvTP_DVD,SFWD] 		= [vdvDVD,SFWD_FB];
    [dvTP_DVD,SREV] 		= [vdvDVD,SREV_FB];
    [dvTP_DVD,SLOW_FWD] 	= [vdvDVD,SLOW_FWD_FB];
    [dvTP_DVD,SLOW_REV] 	= [vdvDVD,SLOW_REV_FB];

    //Lift Feedback -- Now handled by channel events
    //[dvTP_Lift,LIFT_UP]	= [dvRelays,Relay_7];
    //[dvTP_Lift,LIFT_DOWN]	= [dvRelays,Relay_8];
    //Lift Feedback using variable
    [dvTP_Proj,LIFT_UP]		= (nLiftStatus==LIFT_IS_UP);
    [dvTP_Proj,LIFT_DOWN]	= (nLiftStatus==LIFT_IS_DOWN);

    //Projector Feedback
    [dvTP_Proj,PWR_ON]		= (nProjectorStatus==PROJECTOR_ON)
    [dvTP_Proj,PWR_OFF]		= (nProjectorStatus==PROJECTOR_OFF)
}

(*****************************************************************)
(*                                                               *)
(*                      !!!! WARNING !!!!                        *)
(*                                                               *)
(* Due to differences in the underlying architecture of the      *)
(* X-Series masters, changing variables in the DEFINE_PROGRAM    *)
(* section of code can negatively impact program performance.    *)
(*                                                               *)
(* See “Differences in DEFINE_PROGRAM Program Execution” section *)
(* of the NX-Series Controllers WebConsole & Programming Guide   *)
(* for additional and alternate coding methodologies.            *)
(*****************************************************************)

DEFINE_PROGRAM

//FEEDBACK HAS BEEN MOVED TO TIMELINE

//Relay Feedback
//[dvTP,RELAY_1_ON]		= [dvRelays,RELAY_1];
//[dvTP,RELAY_1_OFF]		= ![dvRelays,RELAY_1];
//[dvTP,RELAY_2_PULSE]		= [dvRelays,RELAY_2];
//[dvTP,RELAY_3_TO]		= [dvRelays,RELAY_3];
//[dvTP,RELAY_4_MIN_TO]		= [dvRelays,RELAY_4];
//
//Apple TV Feedback
//[dvTP_AppleTV,PLAY]		= [dvAppleTV,PLAY];
//[dvTP_AppleTV,MENU_FUNC]	= [dvAppleTV,MENU_FUNC];
//[dvTP_AppleTV,MENU_UP]		= [dvAppleTV,MENU_UP];
//[dvTP_AppleTV,MENU_DN]		= [dvAppleTV,MENU_DN];
//[dvTP_AppleTV,MENU_LT]		= [dvAppleTV,MENU_LT];
//[dvTP_AppleTV,MENU_RT]		= [dvAppleTV,MENU_RT];
//[dvTP_AppleTV,MENU_SELECT]	= [dvAppleTV,MENU_SELECT];
//
//DVD RS232 Feedback
//[dvTP_DVD,PLAY] 		= [vdvDVD,PLAY_FB];
//[dvTP_DVD,STOP] 		= [vdvDVD,STOP_FB];
//[dvTP_DVD,PAUSE] 		= [vdvDVD,PAUSE_FB];
//[dvTP_DVD,SFWD] 		= [vdvDVD,SFWD_FB];
//[dvTP_DVD,SREV] 		= [vdvDVD,SREV_FB];
//[dvTP_DVD,SLOW_FWD] 		= [vdvDVD,SLOW_FWD_FB];
//[dvTP_DVD,SLOW_REV] 		= [vdvDVD,SLOW_REV_FB];
//
//Lift Feedback -- Now handled by channel events
//[dvTP_Lift,LIFT_UP]		= [dvRelays,Relay_7];
//[dvTP_Lift,LIFT_DOWN]		= [dvRelays,Relay_8];
//Lift Feedback using variable
//[dvTP_Proj,LIFT_UP]		= (nLiftStatus==LIFT_IS_UP);
//[dvTP_Proj,LIFT_DOWN]		= (nLiftStatus==LIFT_IS_DOWN);
//
//Projector Feedback
//[dvTP_Proj,PWR_ON]		= (nProjectorStatus==PROJECTOR_ON)
//[dvTP_Proj,PWR_OFF]		= (nProjectorStatus==PROJECTOR_OFF)

(*****************************************************************)
(*                       END OF PROGRAM                          *)
(*                                                               *)
(*         !!!  DO NOT PUT ANY CODE BELOW THIS COMMENT  !!!      *)
(*                                                               *)
(*****************************************************************)


