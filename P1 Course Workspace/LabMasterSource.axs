PROGRAM_NAME='LabMasterSource'
(***********************************************************)
(*  FILE CREATED ON: 06/11/2016  AT: 16:30:44              *)
(***********************************************************)
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 07/23/2016  AT: 15:16:37        *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    $History: $
*)
(*
    AMX Master IP Details
    IP: 147.153.59.40
    Subnet: 255.255.255.0
    Gateway: 147.153.59.1
    Wireless SSID: 
    Wireless Password: 

*)

#include 'SNAPI.axi';
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

//IP Ports
dvMyMaster		= 0:1:0;		// Master
//Controller
dvDVD			= 5001:1:0;		// DVX - RS232 Port 1 - Lexicon RT20
dvVideoSwitcher		= 5001:3:0;		// DVX - Switcher
//dvDVD			= 5001:11:0;		// DVX - IR Port 1 - DVD Player
dvSTB			= 5001:12:0;		// DVX - IR Port 2 - STB
dvRelays		= 5001:21:0;		// DVX - Relays
dvDigital_IO		= 5001:22:0;		// DVX - Digital IO
dvDVX_Aud_Out1		= 5002:1:0;		// DVX - Audio Output 1
// Touch Panel
dvTP			= 10001:1:0;		// AMX MXT-701 G5 Touch Panel
dvTP_DVD		= 10001:2:0;		// DVD Buttons
dvTP_STB		= 10001:3:0;		// STB Buttons
dvTP_VideoSWT		= 10001:8:0;		// Switcher Buttons 
//Virtual Devices
vdvDVD			=41001:1:0;		// DVD Virtual Devices
    
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

// PLAY = 1;			SNAPI CONSTANT

SCREEN_UP		= 2;
SCREEN_DOWN		= 3;
SCREEN_STOP		= 4; 
SCREEN_PRESET		= 6;

BEAM_BREAKER		= 8;

ROOM_COMBINED_BUTTON 	= 401;
RACK_POWER_BUTTON	= 501;
SYSTEM_OFF_BUTTON	= 99;

long tl_EVERY_SECOND	= 6;
long tl_FEEDBACK	= 7;					
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

volatile integer nAmpPowerStatus;
volatile integer nLastButton;

persistent long lMasterRebootCounter;
volatile integer nActivePreset;

volatile integer nBluRayButtons[]=
{
    1,2,3,4,5,6,7
};

volatile char sLexiconCommands[5][7];

volatile long lEverySecond[]=
{
    1000	// 1 second = 1 * 1000ms
};

volatile integer nVideoSwitcherButton[]=
{
    41,42,43,44,51,52,53,54,61
};

volatile integer nSelectedInput;	
volatile integer nSelectedOutput;

volatile long lFeedbackTime[]=
{
    100
};

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

([dvRelays,SCREEN_UP]..[dvRelays,SCREEN_STOP],[dvRelays,SCREEN_PRESET])


(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

define_function fnSystemShutdown()
{
	off[dvDigital_IO,1];
	off[dvDigital_IO,2];
	off[dvDigital_IO,3];
	off[dvDigital_IO,4];
	off[dvDigital_IO,5];
	off[dvDigital_IO,6];
	nAmpPowerStatus=0;
}

define_function fnSendToSwitcher(integer nInputNum, integer nOutputNum)
{
    send_string dvVideoSwitcher,"'CL0I',itoa(nInputNum),'O',itoa(nOutputNum),'T'";
}


#include 'MyInclude.axi';

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
//Init Array
sLexiconCommands[1] = "'@PWR:1',$0d";
sLexiconCommands[2] = "'@PWR:2',$0d";
sLexiconCommands[3] = "'@PLY:0',$0d";
sLexiconCommands[4] = "'@STP:0',$0d";
sLexiconCommands[5] = "'@PPS:0',$0d";


//Timeline creation goes here
timeline_create(tl_EVERY_SECOND,lEverySecond,length_array(lEverySecond),timeline_absolute,timeline_repeat);
//create time line ( Time line constant, timeline array, array length, absolute, repeating )
timeline_create(tl_FEEDBACK,lFeedbackTime,length_array(lFeedbackTime),timeline_absolute,timeline_repeat);

//Modules must be defined after startup code. 
define_module 'Lexicon_RT20_Comm_dr1_0_0' COMM_DVD_1 (vdvDVD, dvDVD);


(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

button_event[dvTP,PLAY]
{
    push:
    {
    
    }
    release:
    {
    
    }
    hold[10,repeat]:
    {
    
    }
}

//button_event[dvTP,SCREEN_UP]
//{
//    push:
//    {
//	on[dvRelays,SCREEN_UP];
//    }
//    release:
//    {
//	off[dvRelays,SCREEN_UP];
//    }
//}
//
//button_event[dvTP,SCREEN_DOWN]
//{
//    push:
//    {
//	set_pulse_time(12);
//	pulse[dvRelays,SCREEN_DOWN];
//	set_pulse_time(5);
//    }
//}
//
//button_event[dvTP,SCREEN_STOP]
//{
//    push:
//    {
//	to[dvRelays,SCREEN_STOP];
//    }
//}
//
//button_event[dvTP,SCREEN_PRESET]
//{
//    push:
//    {
//	//min_to[dvRelays,SCREEN_PRESET];
//	on[dvRelays,SCREEN_DOWN]
//	wait 60 
//	{
//	    off[dvRelays,SCREEN_DOWN]
//	}
//    }
//}

button_event[dvTP,0]
{
    push:
    {
	select
	{
	    active(button.input.channel == SCREEN_UP):
	    {
		on[dvRelays,SCREEN_UP];
	    }
	    active(button.input.channel == SCREEN_DOWN):
	    {
		set_pulse_time(12);
		pulse[dvRelays,SCREEN_DOWN];
		set_pulse_time(5);
	    }
	    active(button.input.channel == SCREEN_STOP):
	    {
		to[dvRelays,SCREEN_STOP];
	    }
	    active(button.input.channel == SCREEN_PRESET):
	    {
		min_to[dvRelays,SCREEN_PRESET];
	    }
	}
    }
    release:
    {
	select
	{
	    active(button.input.channel):
	    {
		off[dvRelays,SCREEN_UP]
	    }
	}
    }
}


//Channel Event Feedback
(*channel_event[dvDigital_IO,BEAM_BREAKER]
{
    on:
    {
	on[dvTP,ROOM_COMBINED_BUTTON];
    }
    off:
    {
	off[dvTP,ROOM_COMBINED_BUTTON];
    }
}
*)


//DVD Controls

button_event[dvTP_DVD,nBluRayButtons]
{
    push:
    {
	to[vdvDVD,get_last(nBluRayButtons)];
    }
}

//STB controls

button_event[dvTP_STB,0]
{
    push:
    {
	nLastButton=button.input.channel;
	switch(nLastButton)
	{
	    case 101:
	    {
		send_command dvSTB,"'XCH 257'";
		nActivePreset=1;
	    }
	     case 102:
	    {
		send_command dvSTB,"'XCH 16'";
		nActivePreset=2;
	    }
	     case 103:
	    {
		send_command dvSTB,"'XCH 688'";
		nActivePreset=3;
	    }
	     case 104:
	    {
		send_command dvSTB,"'XCH 325'";
		nActivePreset=4;
	    }
	    default:
	    {
		to[dvSTB,nLastButton]
		nActivePreset=0;
	    }
	}
    }
}


data_event[dvSTB]
{
    online:
    {
	send_command dvSTB,"'SET MODE IR'";
	send_command dvSTB,"'CARON'";
	send_command dvSTB,"'XCHM-1'";
    }
}


//nesting waits example

button_event[dvTP,RACK_POWER_BUTTON]
{
    push:
    {
	on[dvDigital_IO,1]
	wait 10
	{
	    on[dvDigital_IO,2]
	    wait 10
	    {
		on[dvDigital_IO,3]
	    }
	}
    }
}


//stacking waits example
//system power on
button_event[dvTP,RACK_POWER_BUTTON]
{
    push:
    {
	if(!nAmpPowerStatus)
	{
	    on[dvDigital_IO,4];
	    wait 10
	    {
		on[dvDigital_IO,5];
	    }
	    wait 20
	    {
		on[dvDigital_IO,6]; 
		nAmpPowerStatus=1;
	    }
	}
	else
	{
	    off[dvDigital_IO,1];
	    off[dvDigital_IO,2];
	    off[dvDigital_IO,3];
	    off[dvDigital_IO,4];
	    off[dvDigital_IO,5];
	    off[dvDigital_IO,6];
	    nAmpPowerStatus=0;
	}
    }
}
//system power off
button_event[dvTP,SYSTEM_OFF_BUTTON]
{
    push:
    {
	fnSystemShutdown()
//	off[dvDigital_IO,1];
//	off[dvDigital_IO,2];
//	off[dvDigital_IO,3];
//	off[dvDigital_IO,4];
//	off[dvDigital_IO,5];
//	off[dvDigital_IO,6];
//	nAmpPowerStatus=0;
    }
}

//persistent variable example
data_event[dvMyMaster]
{
    online:
    {
	lMasterRebootCounter++;
    }
}
//bar graph volume 
level_event[dvTP,1]
{
    local_var integer nValue;
    nValue = level.value;
    send_level dvDVX_Aud_Out1,1,nValue;
}
level_event[dvDVX_Aud_Out1,1]
{
    stack_var integer nValue;
    nValue = level.value;
    send_level dvTP,1,nValue;
}

button_event[dvTP_VideoSWT,nVideoSwitcherButton]
{
    push:
    {
	switch(button.input.channel)
	{
	    case 41:
	    case 42:
	    case 43:
	    case 44:
	    {
		nSelectedInput = button.input.channel-40;
	    }
	    case 51:
	    case 52:
	    case 53:
	    case 54:
	    {
		nSelectedOutput = button.input.channel-50;
	    }
	    case 61:
	    {
		fnSendToSwitcher(nSelectedInput, nSelectedOutput)
//		send_string dvVideoSwitcher,"'CL0I',itoa(nSelectedInput),'O',itoa(nSelectedOutput),'T'";
		to[button.input];	//flashes take button
		nSelectedInput=0;
		nSelectedOutput=0;
	    }
	}
    }
}
data_event[dvVideoSwitcher]
{
    string:
    {
	local_var char sTemp_Buffer[8]
	local_var integer nInputNum;
	local_var integer nOutputNum;
	
	sTemp_Buffer = data.text;
	if(length_string(sTemp_Buffer)==8)
	{
	    if(find_string(sTemp_Buffer,'T',8))
	    {
		nInputNum=atoi(mid_string(sTemp_Buffer,5,1));
		nOutputNum=atoi(mid_string(sTemp_Buffer,7,1));
		send_command dvTP_VideoSWT,"'^TXT-10,0,Input ',itoa(nInputNum),' ','Routed to Output ',itoa(nOutputNum)"; //^TXT-10,0 ^TXT is send variable text to TP, 10 is address code, 0 is button state (all states)
	    }
	}
    }
}


timeline_event[tl_EVERY_SECOND]
{
    if(time == '22:00:00')
    {
//	do_push(dvTP,SYSTEM_OFF_BUTTON)
	fnSystemShutdown()
    }
}

timeline_event[tl_FEEDBACK]
{
    stack_var integer nLoop; //Loops Example
    
    
    
    
    
    [dvTP,ROOM_COMBINED_BUTTON] = [dvDigital_IO,BEAM_BREAKER];

    //DVD IR Feedback

    (*[dvTP_DVD,PLAY]	= [dvDVD,PLAY]; // PLAY IS JUST A CHANNEL NUMBER
    [dvTP_DVD,STOP]	= [dvDVD,STOP];
    [dvTP_DVD,PAUSE]= [dvDVD,PAUSE];
    [dvTP_DVD,FFWD]	= [dvDVD,FFWD];
    [dvTP_DVD,REW]	= [dvDVD,REW];
    [dvTP_DVD,SFWD]	= [dvDVD,SFWD];
    [dvTP_DVD,SREV]	= [dvDVD,SREV];
    *)
    //DVD RS232 Feedback
    [dvTP_DVD,PLAY] = [vdvDVD,PLAY_FB];
    [dvTP_DVD,STOP] = [vdvDVD,STOP_FB];
    [dvTP_DVD,PAUSE] = [vdvDVD,PAUSE_FB];
    [dvTP_DVD,SFWD] = [vdvDVD,SFWD_FB];
    [dvTP_DVD,SREV] = [vdvDVD,SREV_FB];

    //STB IR Feedback
    for(nLoop=1;nLoop<=7;nLoop++)
    {
	[dvTP_STB,nLoop] = [dvSTB,nLoop];
    }



//    [dvTP_STB,PLAY]	= [dvSTB,PLAY]; // PLAY IS JUST A CHANNEL NUMBER
//    [dvTP_STB,STOP]	= [dvSTB,STOP];
//    [dvTP_STB,PAUSE] 	= [dvSTB,PAUSE];
//    [dvTP_STB,FFWD]	= [dvSTB,FFWD];
//    [dvTP_STB,REW]	= [dvSTB,REW];
//    [dvTP_STB,SFWD]	= [dvSTB,SFWD];
//    [dvTP_STB,SREV]	= [dvSTB,SREV];
    [dvTP_STB,101]	= (nActivePreset==1);
    [dvTP_STB,102]	= (nActivePreset==2);
    [dvTP_STB,103]	= (nActivePreset==3);
    [dvTP_STB,104]	= (nActivePreset==4);
    //Rack Power Button Status
    [dvTP,RACK_POWER_BUTTON] = (nAmpPowerStatus==1);

    //Switcher Feedback
    [dvTP_VideoSWT,41] = (nSelectedInput==1);
    [dvTP_VideoSWT,42] = (nSelectedInput==2);
    [dvTP_VideoSWT,43] = (nSelectedInput==3);
    [dvTP_VideoSWT,44] = (nSelectedInput==4);
    [dvTP_VideoSWT,51] = (nSelectedOutput==1);
    [dvTP_VideoSWT,52] = (nSelectedOutput==2);
    [dvTP_VideoSWT,53] = (nSelectedOutput==3);
    [dvTP_VideoSWT,54] = (nSelectedOutput==4);


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

//[dvTP,ROOM_COMBINED_BUTTON] = [dvDigital_IO,BEAM_BREAKER];
//
////DVD IR Feedback
//
//(*[dvTP_DVD,PLAY]	= [dvDVD,PLAY]; // PLAY IS JUST A CHANNEL NUMBER
//[dvTP_DVD,STOP]	= [dvDVD,STOP];
//[dvTP_DVD,PAUSE]= [dvDVD,PAUSE];
//[dvTP_DVD,FFWD]	= [dvDVD,FFWD];
//[dvTP_DVD,REW]	= [dvDVD,REW];
//[dvTP_DVD,SFWD]	= [dvDVD,SFWD];
//[dvTP_DVD,SREV]	= [dvDVD,SREV];
//*)
////DVD RS232 Feedback
//[dvTP_DVD,PLAY] = [vdvDVD,PLAY_FB];
//[dvTP_DVD,STOP] = [vdvDVD,STOP_FB];
//[dvTP_DVD,PAUSE] = [vdvDVD,PAUSE_FB];
//[dvTP_DVD,SFWD] = [vdvDVD,SFWD_FB];
//[dvTP_DVD,SREV] = [vdvDVD,SREV_FB];
//
////STB IR Feedback
//
//[dvTP_STB,PLAY]	= [dvSTB,PLAY]; // PLAY IS JUST A CHANNEL NUMBER
//[dvTP_STB,STOP]	= [dvSTB,STOP];
//[dvTP_STB,PAUSE]= [dvSTB,PAUSE];
//[dvTP_STB,FFWD]	= [dvSTB,FFWD];
//[dvTP_STB,REW]	= [dvSTB,REW];
//[dvTP_STB,SFWD]	= [dvSTB,SFWD];
//[dvTP_STB,SREV]	= [dvSTB,SREV];
//[dvTP_STB,101]	= (nActivePreset==1);
//[dvTP_STB,102]	= (nActivePreset==2);
//[dvTP_STB,103]	= (nActivePreset==3);
//[dvTP_STB,104]	= (nActivePreset==4);
////Rack Power Button Status
//[dvTP,RACK_POWER_BUTTON] = (nAmpPowerStatus==1);
//
////Switcher Feedback
//[dvTP_VideoSWT,41] = (nSelectedInput==1);
//[dvTP_VideoSWT,42] = (nSelectedInput==2);
//[dvTP_VideoSWT,43] = (nSelectedInput==3);
//[dvTP_VideoSWT,44] = (nSelectedInput==4);
//[dvTP_VideoSWT,51] = (nSelectedOutput==1);
//[dvTP_VideoSWT,52] = (nSelectedOutput==2);
//[dvTP_VideoSWT,53] = (nSelectedOutput==3);
//[dvTP_VideoSWT,54] = (nSelectedOutput==4);
//

(*****************************************************************)
(*                       END OF PROGRAM                          *)
(*                                                               *)
(*         !!!  DO NOT PUT ANY CODE BELOW THIS COMMENT  !!!      *)
(*                                                               *)
(*****************************************************************)


