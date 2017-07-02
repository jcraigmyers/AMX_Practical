PROGRAM_NAME='craig.myers.practical'
//#WARN	'I spent about 80 hrs on ths program'
//#WARN	'System Requirements ver: 2.5 Device Specs ver: 2.2 Video Flow ver: 2.2 Connector Detail ver: 2.2 ControlSingleLines ver:2.2'
//#WARN	'Code tested on master/controller type NI-3100 with firmware version 4.1.419'
(***********************************************************)
(*  FILE CREATED ON: 06/18/2016  AT: 15:50:26              *)
(***********************************************************)
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 12/11/2016  AT: 14:03:52        *)
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

//NI-3101-SIG
dvMaster		=	0:1:0;		// Master
//232 Devices
//dvSWT1		=	5001:1:0;	// Switchback 12x1
//dvVPJ1		=	5001:2:0;	// LightThrower 3000
//dvDVD			=	5001:3:0;	// Disco Tech
dvCAM			=	5001:4:0;	// Sony EVID100

//Emulator Devices
dvSWT1			=	8001:1:0;	// Switchback 12x1
dvVPJ1			=	8002:1:0;	// LightThrower 3000
dvDVD			=	8003:1:0;	// Disco Tech
dvIR1			=	8005:1:0;	// DirecTV HR-20
//Relay Devices
dvRelays		=	5001:8:0;	// Screen Relays & Rack Power

//IR Devices
//dvIR1			= 	5001:9:0;	// DirecTV HR-20

//IP Devices
dvLIGHTS		=	0:4:0;

//NXD-700VI
dvTP			=	10001:1:0;	// NXD-700VI

dvTP_CAM		=	10001:10:0;	// Camera Buttons
dvTP_DVD		=	10001:11:0;	// DVD/CD Buttons
dvTP_LIGHT		=	10001:12:0;	// Lighting Control
dvTP_ROOM		=	10001:13:0;	// Room Control
//dvTP_ROOM is handled by dvTP 
dvTP_SAT		=	10001:14:0;	// Sat Buttons
dvTP_SEC		=	10001:15:0;	// Security Camera Buttons


//Virtual Devices
vdvCAM			=	41001:1:0	//	Sony EVID100 Module
//vdvKEYPAD		=	42001:1:0	//	Virtual Keypad
//dvKEYPAD		=	0:3:0	//	Virtual Keypad
VIRTUALKEYPAD		=	42001:1:0	//	Virtual Keypad
dvVIRTUALKEYPAD		=	0:3:0	//	Virtual Keypad

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

    LIGHTING_IP_ADDRESS = '10.0.0.26'
    LIGHTING_PORT	= 24
//Virtual Keypad Button Labels
BUTTON1		=	'1'
BUTTON2 	=	'2'
BUTTON3		=	'3'
BUTTON4		=	'4'
BUTTON5		=	'DVD/CD'
BUTTON6		=	'Camera'
BUTTON7		=	'Sat. Rcvr.'
BUTTON8		=	'Security Camera'
BUTTON9		=	'5'
BUTTON10	=	'6'
BUTTON11	=	'7'
BUTTON12	=	'System Power'



//Virtual Keypad Button Numbers
integer	BTNS[]	=
{
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12
}



long tl_FEEDBACK	=7;
long tl_COUNT		=8;
long tl_LAMPHOURS	=9;
long tl_LAMPPOLL	=1;
long tl_COUNTDOWN	=2;
long tl_DVDPOLL		=10;



//Relays
SCREEN_UP		=	1;
SCREEN_DN		=	2;
SCREEN_ST		=	3;
DEV_POWER		=	5;
AMP_POWER		=	6;

//Inputs

COMPONENT		=	1;
SVIDEO			=	2;
HDMI			=	3;
VIDEO			=	4;

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

STRUCTURE LIGHTS
{
    INTEGER lightIntensity
    INTEGER fadeTime
}
STRUCTURE SCENES
{
    CHAR sceneName[7]
    LIGHTS instancedLights[4]
}
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE


//Lighting

NON_VOLATILE SCENES instancedScenes[3]
VOLATILE INTEGER SceneFeedback

//File parsing stuff
VOLATILE CHAR Protocol // Need to compare... IF TCP = 1 UDP = 2 UDP with Receive = 3
VOLATILE integer cPos1 // Position of the first comma
VOLATILE integer cPos2 // Position of the second comma
VOLATILE integer cPos3 // Position of the third comma

//IP stuff
VOLATILE INTEGER nLocalPort		//Integer
VOLATILE CHAR LocalPort[15]
VOLATILE CHAR IPAddress[15]// = '10.0.0.26';
VOLATILE char IPPort[3]//	= 24
VOLATILE INTEGER nProtocol	//Integer



//volatile integer nSource; Don't need this now
volatile integer nActiveSource;
volatile integer nActiveDisk;
volatile integer nDVDButton;

volatile long lFeedbackTime[]=
{
    100
};

volatile long lCountTime[]=
{
    1000		// 1 sec
};
volatile long lLampHoursTime[]=
{
    30000		// 30 seconds
};

volatile long lLAMPPOLLTIME[]=
{
    30000		// 30 seconds
};

volatile long lCOUNTDOWNTIME[]=
{
    1000		// 1 sec
};
volatile long lDVDPOLLTIME[]=
{
    1000	// .001 sec
};


volatile integer nSystemStatus;
volatile integer nProjStatus;

volatile integer nCountCool;	
volatile integer nCountWarm;
volatile integer nCountLamp;


volatile char sInputSelect[4][8]; //first part is items in array // second is longest individual part of array. eg X commands. longest command is Y in length
volatile char sProjCommands[6][7];
volatile char sDVDCommands[49][3];
volatile char Checksum;

//2D Array Example
INTEGER Num2D[3][2] = 
{
    {1, 3}, 
    {2, 4}, 
    {7, 8}
};

(* This sets the dimensions to Num2D[3][2] *)

//Array for Switcher Button Feedback
volatile char nVideoSwitcherButtons[4][12] =

{
    {11,21,31,41,51,61,71,81,91,101,111,121},
    {12,22,32,42,52,62,72,82,92,102,112,122},
    {13,23,33,43,53,63,73,83,93,103,113,123},
    {14,24,34,44,54,64,74,84,94,104,114,124}
};

volatile integer nCDButtons[]=
{
    4,5
};


//Lighting Arrays
volatile integer nRaiseDimButtons[]=
{
    35,37,39,41
};

volatile integer nLowerDimButtons[]=
{
    36,38,40,42
};

volatile integer nSceneButtons[]=
{
    30,31,32
};

volatile integer nLevelArray[] = 
{
    10,11,12,13
};

volatile integer nPresetButtons[]=
{
    261,262,263
};

volatile integer nCameraButtons[]=
{
    132,133,134,135,158,159
};

volatile integer nSatButtons[]=
{
    1041,1042,1043,1044,1045,1046
};

//volatile integer Array1[6]; //This doesn't work with the emulator
//volatile char Array1[6][8];
volatile integer nTVStations[6];


//Timeline helpers
constant long TL_PROJ_WARM_COUNT	=	1
constant long TL_PROJ_COOL_COUNT	=	2
constant long TL_PROJ_LAMPHOURS		=	3



constant integer PROJ_ON_DELAY		=	30
constant integer PROJ_OFF_DELAY		=	75
constant integer LAMP_POLL		=	30

volatile integer nVideoSwitcherButton[]=
{
    11,12,13,14,21,22,23,24,31,32,33,34,41,42,43,44,51,52,53,54,61,62,63,64,71,72,73,74,81,82,83,84,91,92,93,94,101,102,103,104,111,112,113,114,121,122,123,124
};



volatile integer nSelectedInput;	
volatile integer nSelectedOutput;


volatile integer nFlag;
volatile char sFromTP[1024];
volatile CHAR sToSend[1024]
volatile char cTIME[20]
volatile char cDATE[20]

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE
([dvRelays,1]..[dvRelays,6])


(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)





//Switcher Functions
//
//

define_function fnRouteActive()
{

}

//Projector Functions
//
//

define_function fnProjectorOn()
{
    send_string dvVPJ1,"sProjCommands[6]"; //asks projector for status. See parse function for what it does.
    fnStartPolling()	//creates timeline & timeline event checks power status and asks for lamp information. String comes back and is handled by parse function. Parse function then updates text box on TP
    //fnCountDown()
}


//SENDS STRINGS TO PROJECTOR
define_function fnSendToProj() // Changes input
{
    send_string dvVPJ1,"sInputSelect[nActiveSource]";
}

define_function fnSendToProj2() // Sends Projector commands based on what was requested. Power is handled here. Need a better name too...
{
    send_string dvVPJ1,"sProjCommands[1]"; //Right now, only sends power on. Need to define variable to determine command.  
}



//DEFINE_FUNCTION CHAR[1] fnCalculateChecksum()
//
////local_var char Checksum;
//
//{
//    Checksum = $02+$03+$00+$00+$02+$01+$01;
//    RETURN Checksum;
//}

//To call this function and to retrieve the RETURN value, use the following syntax:

//Checksum = fnCalculateChecksum()
define_function fnParseLights(char sToParse[12])
{
	local_var integer nZone
	local_var integer nLevel
	
	nZone = ATOI(mid_string(sToParse,7,1));	//Get Zone
	nLevel = ATOI(mid_string(sToParse,10,3));	//Get Level
	send_level dvTP_LIGHT, nLevelArray[nZone],(nLevel * 2.55);
}
//GETS STRINGS FROM PROJECTOR AND ACTS ACCORDINGLY
define_function fnParseProj(char sToParse[9]) // This gets all strings from the projector & handles feedback appropriately // 9 is length of longest string returned
{
    local_var char cStatusByte; // if you don't use type cast, use cStatusByte[1];
    local_var char cChecksumByte;
    
    //Lamp Information Vars
    local_var char cByte4;
    local_var char cByte5;
    local_var char cByte6;
    local_var char cByte7;
    local_var char cByte8;
    local_var char cLampSec;
    
    
    cStatusByte = type_cast(mid_string(sToParse,6,1)); // type_case makes it so you don't have to define your array
    cChecksumByte = type_cast(mid_string(sToParse,7,1));
    
    //Lamp Information -- AKA Super Janky - I'll fix this later
    cByte4 = type_cast(mid_string(sToParse,4,1));
    cByte5 = type_cast(mid_string(sToParse,5,1));
    cByte6 = type_cast(mid_string(sToParse,6,1));
    cByte7 = type_cast(mid_string(sToParse,7,1));
    cByte8 = type_cast(mid_string(sToParse,8,1));
    
    
    select
    {
	//
	// THIS IS ALL PASSIVE - STILL NEED TO INITIATE SOMETHING TO GET SOMETHING BACK -- NONE OF THIS WILL WORK WITHOUT AN EMULATOR
	//
	//
	//Input Status - Updates input text on TP with input reported by projector
	active(cStatusByte == "$11" && cChecksumByte == "$07"): //if both are true, do this -- !!!!!!!Still need to figure out feedback handling!!!!!!
	{
	    nActiveSource = COMPONENT; // updates source var which turns on button
	    send_command dvTP_ROOM,"'^TXT-15,0,Component'";
	}
	active(cStatusByte == "$08" && cChecksumByte == "$01"): //needs to be changed to $0B --> fix chksum // Would it be possible to get these string from Running Status Request? 
	{
	    nActiveSource = SVIDEO;
	    send_command dvTP_ROOM,"'^TXT-15,0,S-Video'";
	}
	active(cStatusByte == "$01" && cChecksumByte == "$F7"): 
	{
	    nActiveSource = HDMI; 
	    send_command dvTP_ROOM,"'^TXT-15,0,HDMI'";
	}
	active(cStatusByte == "$06" && cChecksumByte == "$FC"): 
	{
	    nActiveSource = VIDEO; 
	    send_command dvTP_ROOM,"'^TXT-15,0,Video'";
	}
	//Running Status 
	active(cStatusByte == "$00"): 			//Idle
	{
	    send_string dvVPJ1,"sProjCommands[1]";	//If projector is idle, send power on. 
	    nProjStatus = 1;				//button feedback
	    nCountWarm = 30;
	    fnCountDown()
	}
	active(cStatusByte == "$03"): 			//Warming
	{
	   
	}
	active(cStatusByte == "$04"): 			//Power On
	{
	    send_string dvVPJ1,"sProjCommands[2]";	//If projector is on, send power off. 
	    nProjStatus = 0;
	    nCountCool = 75;
	    fnCountDown()
	}
	//active(cStatusByte == "$05"): 			//Cooling
//	{
//	    send_command dvTP_ROOM,"'^TXT-12,0,',ITOA(nCountCool)";
//	}
	//Lamp Information
	//Get bytes 5,6,7,8, reverse them & hextoi print to button
	active(cByte4 == "$04"): 			//
	{
	   
	    send_command dvTP_ROOM,"'^TXT-14,0,TEST'"; //Need to revisit this. Not sure if it will even work. 
	    //send_command dvTP_ROOM,"'^TXT-14,0,',HDMI"; //Need to revisit this. Not sure if it will even work. 
	    
	}
    }
    
}

//DVD Functions
//
//

define_function fnSendToDVD()
{
    send_string dvDVD,"sDVDCommands[button.input.channel]";
}

define_function fnParseDVD(char sToParse[2])
{
    local_var char cStatusByte1; // if you don't use type cast, use cStatusByte[1];
    local_var char cStatusByte2; // if you don't use type cast, use cStatusByte[1];
    cStatusByte1 = type_cast(mid_string(sToParse,1,1)); // type_case makes it so you don't have to define your array
    cStatusByte2 = type_cast(mid_string(sToParse,2,1)); // type_case makes it so you don't have to define your array
    select
    {
	active(cStatusByte1 == "$05"): //Power
	{
	    send_string dvDVD,"sDVDCommands[10]";
	}
	active(cStatusByte1 == "$11" && cStatusByte2== "$01"): //DVD
	{
	    nActiveDisk = 1;
	}
	active(cStatusByte1 == "$11" && cStatusByte2== "$02"): //CD
	{
	    nActiveDisk = 2;
	}
	active(cStatusByte1 == "$12" && cStatusByte2== "$01"): //Play
	{
	    nDVDButton = 1;
	}
	active(cStatusByte1 == "$12" && cStatusByte2== "$02"): //Stop
	{
	    nDVDButton = 2;
	}
	active(cStatusByte1 == "$12" && cStatusByte2== "$03"): //Pause
	{
	    nDVDButton = 3;
	}
	active(cStatusByte1 == "$12" && cStatusByte2== "$06"): //Search Rev
	{
	    nDVDButton = 7;
	}
	active(cStatusByte1 == "$12" && cStatusByte2== "$07"): //Search Fwd
	{
	    nDVDButton = 6;
	}
	
    }
}


//Camera Functions
//
//

//Projection Screen Functions
//
//

define_function fnScreenUp()
{
    set_pulse_time(25);
    pulse[dvRelays,SCREEN_UP];
    set_pulse_time(5);
}

define_function fnScreenDown()
{
    set_pulse_time(25);
    pulse[dvRelays,SCREEN_DN];
    set_pulse_time(5);
}

define_function fnScreenStop()
{
    pulse[dvRelays,SCREEN_ST];
}



//Power Functions / Power Macro
//
//


define_function fnStartupMacro()
{

}

define_function fnShutdownMacro()
{

}




define_function fnShutdown()
{
    
    send_command dvTP,'@PPN-Confirm'
    
    
}

define_function fnShutdown1()
{
//everything below this needs to be moved to a button event for the confirm page
    
    //Turn off Sat Receiver
    
    
    
    //Turn off DVD/CD Player
    timeline_kill(tl_DVDPOLL)
    send_string dvDVD,"sDVDCommands[10]";
    
    
    
    //Turn off VDP
    
    fnProjectorOn()
    wait 20
    fnScreenUp()
    wait 60
    pulse[dvRelays,AMP_POWER];
    wait 100
    pulse[dvRelays,DEV_POWER];
    nSystemStatus=0; //this happens last
    nActiveSource=0;
}

define_function fnStartup()
{
    pulse[dvRelays,DEV_POWER];		//Turn on device power relay
    fnScreenDown()			//Lower Screen
    fnProjectorOn()
    //Turn on VDP
    wait 10
    pulse[dvRelays,AMP_POWER];		// Turn on amp power relay
    wait 310
    //If source button initiated macro, then turn on the source and switch video projector to the appropriate input
    switch(button.input.channel)
    {
	//let's see if we can stack these
	case 11:
	{
	    nActiveSource = COMPONENT;
	    fnSendToProj()
	}
	case 12:
	{
	    nActiveSource = SVIDEO;
	    fnSendToProj()
	}
	case 13:
	{
	    nActiveSource = HDMI;
	    fnSendToProj()
	}
	case 14:
	{
	    nActiveSource = VIDEO;
	    fnSendToProj()
	}
    }	
    nSystemStatus=1; //this happens last
}

define_function fnCheckPowerStatus()
{
    if(!nSystemStatus)
	{
	    fnStartup()
	}
	else
	{
	   // fnShutdown()	//need to figure out how to handle the power macro. Basically, any time the power macro is called, it opens the popup page -- the power macro is called every input change.
	}
}

//Sat Functions
//
//


//Lighting Functions
//
//
DEFINE_FUNCTION fnOpenTCPConnect(DEV dvIP, CHAR IP4_ADDRESS[15], LONG IP_PORT) //do nothing is device is communicating. reconnect if not
{
    IF(![dvIP, 251])
    {
	IP_CLIENT_OPEN (dvIP.PORT, IP4_ADDRESS, IP_PORT, IP_TCP)
    }
}
(*
define_function	fnInitializeLightConnection(DEV dvIP, CHAR IP4_ADDRESS[15], LONG IP_PORT)
{
    IF(![dvIP, 251])
    {
	IP_CLIENT_OPEN (dvIP.PORT, IP4_ADDRESS, IP_PORT, IP_TCP)
    }
    //IP_CLIENT_OPEN(4,IPAddress,IPPort,nProtocol);
    //IP_CLIENT_OPEN(4,10.0.0.26,24,1);

    IF	(dvLIGHTS == LocalPort) //IP_ADDRESSING must match dvLights
    {
	
	
    }
}*)

define_function	fnInitializeLightArray()
{
    instancedScenes[1].sceneName = 'Scene 1'
    instancedScenes[1].instancedLights[1].lightIntensity	=	10
    instancedScenes[1].instancedLights[1].fadeTime		=	0
    instancedScenes[1].instancedLights[2].lightIntensity	=	20
    instancedScenes[1].instancedLights[2].fadeTime		=	0
    instancedScenes[1].instancedLights[3].lightIntensity	=	30
    instancedScenes[1].instancedLights[3].fadeTime		=	0
    instancedScenes[1].instancedLights[4].lightIntensity	=	40
    instancedScenes[1].instancedLights[4].fadeTime		=	0
    instancedScenes[2].sceneName = 'Scene 2'			
    instancedScenes[2].instancedLights[1].lightIntensity	=	80
    instancedScenes[2].instancedLights[1].fadeTime		=	0
    instancedScenes[2].instancedLights[2].lightIntensity	=	90
    instancedScenes[2].instancedLights[2].fadeTime		=	0
    instancedScenes[2].instancedLights[3].lightIntensity	=	99
    instancedScenes[2].instancedLights[3].fadeTime		=	0
    instancedScenes[2].instancedLights[4].lightIntensity	=	60
    instancedScenes[2].instancedLights[4].fadeTime		=	0
    instancedScenes[3].sceneName = 'Scene 3'
    instancedScenes[3].instancedLights[1].lightIntensity	=	0
    instancedScenes[3].instancedLights[1].fadeTime		=	0
    instancedScenes[3].instancedLights[2].lightIntensity	=	0
    instancedScenes[3].instancedLights[2].fadeTime		=	0
    instancedScenes[3].instancedLights[3].lightIntensity	=	0
    instancedScenes[3].instancedLights[3].fadeTime		=	0
    instancedScenes[3].instancedLights[4].lightIntensity	=	0
    instancedScenes[3].instancedLights[4].fadeTime		=	0
}

//FADEDIM, INTENSITY, FADE TIME, DELAY TIME, ADDRESS





//IP_CLIENT_OPEN(LocalPort,IPAddress,IPPort,Protocol)

//Timelines
//
//

define_function fnStartPolling()
{
    timeline_create(tl_LAMPPOLL,lLAMPPOLLTIME,length_array(lLAMPPOLLTIME),timeline_absolute,timeline_repeat); 
}
define_function fnCountDown()
{
    timeline_create(tl_COUNTDOWN,lCOUNTDOWNTIME,length_array(lCOUNTDOWNTIME),timeline_absolute,timeline_repeat);
}
define_function fnStartPollingDVD()
{
    timeline_create(tl_DVDPOLL,lDVDPOLLTIME,length_array(lDVDPOLLTIME),timeline_absolute,timeline_repeat);
}

//define_function tlStart (LONG tl_COUNT, INTEGER nSec)
//stack_var
//    LONG lCountTime[1]
//{
//    if(timeline_active(tl_COUNT))
//	return;
//	
//    switch(tl_COUNT)
//    {
//    // countdown while projector warms
//	case TL_PROJ_WARM_COUNT:
//	{
//	    nCountWarm	 	= 	nSec
//	    lCountTime[1]	=	1000
//	    timeline_create(tl_COUNT,lCountTime,length_array(lCountTime),timeline_absolute,timeline_repeat);
//	    send_command dvTP_ROOM,"'^TXT-13,0,',ITOA(nCountWarm)";
//	}
//    // countdown while projector cools
//	case TL_PROJ_COOL_COUNT:
//	{
//	    nCountCool		=	nSec
//	    lCountTime[1]	=	1000
//	    timeline_create(tl_COUNT,lCountTime,length_array(lCountTime),timeline_absolute,timeline_repeat);
//	    send_command dvTP_ROOM,"'^TXT-12,0,',ITOA(nCountCool)";
//	}
//    // lamp hour polling
//	case TL_PROJ_LAMPHOURS:
//	{
//	    nCountLamp		=	nSec
//	    lCountTime[1]	=	1000
//	    timeline_create(tl_COUNT,lCountTime,length_array(lCountTime),timeline_absolute,timeline_repeat);
//	    send_command dvTP_ROOM,"'^TXT-14,0,',ITOA(nCountLamp)";
//	}
//    }
//}

DEFINE_FUNCTION fnParseVDVCAM(sToParse[13])	//This should work. It's not working, but it should.
{
    local_var integer nPresetIndex
    nPresetIndex = ATOI(REMOVE_STRING(sToParse,'CAMERAPRESET-',1));
    ON[dvTP_CAM,nPresetButtons[nPresetIndex]];
    //ON[dvTP_CAM,261];
}

// FILE OPERATIONS
//
//
DEFINE_FUNCTION fnQueryTP()
{	
    
    SEND_COMMAND dvTP,"'?MAC'"

}


//WRITE TO FILE

DEFINE_FUNCTION appendToFile (CHAR cFileName[],CHAR cLogString[])

{

   STACK_VAR SLONG slFileHandle1     // stores the tag that represents the file (or and error code)

   LOCAL_VAR SLONG slResult1         // stores the number of bytes written (or an error code)

   slFileHandle1 = FILE_OPEN(cFileName,FILE_RW_APPEND) // OPEN OLD FILE (OR CREATE NEW ONE)    

   IF(slFileHandle1>0)               // A POSITIVE NUMBER IS RETURNED IF SUCCESSFUL

         {

         slResult1 = FILE_WRITE_LINE(slFileHandle1,cLogString,LENGTH_STRING(cLogString)) // WRITE THE NEW INFO

          FILE_CLOSE(slFileHandle1)   // CLOSE THE LOG FILE

         }           

      ELSE

         {

         SEND_STRING 0,"'FILE OPEN ERROR:',ITOA(slFileHandle1)" // IF THE LOG FILE COULD NOT BE CREATED

         }

}




//READ FROM FILE

DEFINE_FUNCTION fnReadFromFile()
{
    STACK_VAR SLONG hFile
    LOCAL_VAR SLONG slBytesRead
    STACK_VAR CHAR Buffer[1024]	//Stack var only works within this function
    stack_var CHAR PrintBuffer
    stack_var CHAR ptBuff
    local_var INTEGER lBuff 
    local_var INTEGER lpos1
    
    //I guess this has to go up here
    local_var char cIPdevice
    CHAR StrExp[30]
    local_var integer POS     
    
    SLONG slReturn
    CHAR Decode 
    
    hFile = FILE_OPEN('IP_ADDRESSING.txt',FILE_READ_ONLY)
    IF(hFile>0)
    {
    lpos1 = 79				//Start reading file here
    FILE_SEEK (hFile, lpos1)
    slBytesRead = 1
	WHILE(slBytesRead>0)
	{
	send_command dvTP_LIGHT,"'^TXT-11,0,',ITOA(slBytesRead)";
	slBytesRead = FILE_READ(hFile,Buffer,1024)
	    (*WHILE(ITOA(slBytesRead)!='-9')
	    {
		lBuff++
		lpos1 = lBuff
	    }*)
	//send_command dvTP_LIGHT,"'^TXT-11,0,',ITOA(slBytesRead)";
	//normal string parsing here
	
	
	}
    FILE_CLOSE(hFile)
    }

    //send_command dvTP_LIGHT,"'^TXT-11,0,',ITOA(slBytesRead)";
    //PrintBuffer = get_buffer_string(Buffer[1024],10)
    //PrintBuffer = get_buffer_char(Buffer[1024])
    //ptBuff = find_string(Buffer,'IP Device',1)
    //Examples below
    //SINTEGER STRING_TO_VARIABLE (DECODE, CHAR BUFFER[ ], LONG POSITION
    //slReturn = STRING_TO_VARIABLE(MyAlbumStruct, sBinaryString, slPos)
    // slReturn = STRING_TO_VARIABLE(Decode, Buffer[1024],1)

    //slReturn = VARIABLE_TO_STRING(Buffer, sBinaryString, 1)
   (* WHILE(Buffer[lBuff]!=',')
    {
	lBuff++
	lpos1 = lBuff
	
    }*)
    
    
    //Buffer is just a char array. Strings are char arrays. Let's try some string keywords on the buffer.
    
    

    
    
    //Borrowing string parsing function for switcher
    //Don't forget to comment this out
    (*
    
     string: 				// String Handler -- handles feedback from switcher
    {
	local_var char sFromSWT1[9];
	local_var char cInput[2];
	local_var char cOutput[1];
	//local_var char cStatusByte[1];
	//local_var char cInputByte[1];
	sFromSWT1 = data.text;
	//cInput = REMOVE_STRING(sFromSWT1,'IN',1)
	cInput = type_cast(mid_string(sFromSWT1,7,LENGTH_STRING(sFromSWT1) - 7)); // mid_string(Input char string, starting location in the string, number of characters to extract)
	cOutput = type_cast(mid_string(sFromSWT1,4,1));
	send_command dvTP_SEC,"'^TXT-11,0,OUT',cOutput";
	send_command dvTP_SEC,"'^TXT-12,0,',sFromSWT1";
	send_command dvTP_SEC,"'^TXT-13,0,IN',cInput";
	//cInput = type_cast(LEFT_STRING(cButtonString,LENGTH_STRING(cButtonString) - 1)
	
	//fnParseSWT1(sFromSWT1); //sends string to parse function
	
	    //to[dvTP,button.input.channel]


    }
    *)
    //end
    
    
    
    
    
    
    
    
    //Fuck it let's try this
    //CHAR BufferString[2]
    //BufferString = "Buffer[1],Buffer[2]"
    //decode = Buffer[1].Buffer[2].Buffer[3];
    //send_command dvTP_LIGHT,"'^TXT-10,0,',Buffer[lBuff],Buffer[lbuff+1]";
    //send_command dvTP_LIGHT,"'^TXT-12,0,',Buffer[1],Buffer[2],Buffer[3],Buffer[4],Buffer[5],Buffer[6],Buffer[7],Buffer[8],Buffer[9],Buffer[10],Buffer[11]";//This is the only thing that works right now. Need to figure out how to search the array
    //send_command dvTP_LIGHT,"'^TXT-13,0,',PrintBuffer";
    //34 bytes
    StrExp = "Buffer[1],Buffer[2],Buffer[3],Buffer[4],Buffer[5],Buffer[6],Buffer[7],Buffer[8],Buffer[9],Buffer[10],Buffer[11],Buffer[12],Buffer[13],Buffer[14],Buffer[15],Buffer[16],Buffer[17],Buffer[18],Buffer[19],Buffer[20],Buffer[21],Buffer[22],Buffer[23],Buffer[24],Buffer[25],Buffer[26],Buffer[27],Buffer[28],Buffer[29],Buffer[30]" //Hey, if it works...
    cIPdevice = type_cast(mid_string(StrExp,5,5)); // mid_string(Input char string, starting location in the string, number of characters to extract)
    
    POS = FIND_STRING(StrExp,',',1)
    
    //send_command dvTP_LIGHT,"'^TXT-14,0,',ITOA(POS)";
   
    
    
        /// normal string parsing here...
    cPos1 = FIND_STRING(StrExp,',',1) //Find the first comma in aLine starting at beginning. 
    cPos2 = FIND_STRING(StrExp,',',cPos1+1) //Find the next comma in sequence starting at position 1.
    cPos3 = FIND_STRING(StrExp,',',cPos2+1) //Find the next comma in sequence starting at position 2. 
    
    LocalPort 	= type_cast(LEFT_STRING(StrExp,cPos1-1)); //Grabs everything left of cPos1
    //nLocalPort = ATOI(LocalPort)
    //LocalPort 	= type_cast(LEFT_STRING(StrExp,5)); //Might have to convert sPos1 to a long, but first let's test setting the count to 5
    IPAddress 	= mid_string(StrExp,cPos1+1,cPos2-cPos1); 
    //IPAddress	= '10.0.0.26' //This much works
    //IPPort = 24	//This much works
    IPPort 	= mid_string(StrExp,cPos2+1,cPos3-cPos2); //Should grab string x in length starting at cPos1. //Problem is here. You need to convert it !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    Protocol 	= type_cast(mid_string(StrExp,cPos3+1,3)); //grabs what's left over. 
    IF (Protocol == 'tcp')
    {
	nProtocol = 1;
    }
    ELSE IF (Protocol == 'udp')
    { 
	nProtocol = 2;
    }
    ELSE
    {
	nProtocol = 3;
    }
    
    send_command dvTP_LIGHT,"'^TXT-11,0,',LocalPort";
    
    send_command dvTP_LIGHT,"'^TXT-12,0,',IPAddress";
    //send_command dvTP_LIGHT,"'^TXT-12,0,IPAddress',IPAddress";
    send_command dvTP_LIGHT,"'^TXT-13,0,',ITOA(IPPort)";
    //send_command dvTP_LIGHT,"'^TXT-13,0,IPPort',IPPort";
    send_command dvTP_LIGHT,"'^TXT-14,0,',ITOA(nProtocol)";
    
    //TEST TO SEE IF FILE IS BEING READ AND PARSED CORRECTLY
    IF (localport == '0:4:0' && IPAddress == '10.0.0.26' && IPPort == '24' && Protocol == 'tcp')
	{
	    send_command dvTP_LIGHT,"'^TXT-10,0,SUCCESS'"
	}
    ELSE
	{
	    send_command dvTP_LIGHT,"'^TXT-10,0,FAIL'"
	}
    //send_command dvTP_LIGHT,"'^TXT-10,0,',cIPdevice,',',ITOA(cPos1),',',ITOA(cPos2),',',ITOA(cPos3),',',ITOA(POS),',',Protocol";
    
    
    
    //send_command dvTP_LIGHT,"'^TXT-12,0,',Buffer[]";
    
}

(*

DEFINE_FUNCTION readStuffFromFile(CHAR cFileName[])

{
   STACK_VAR SLONG slFileHandle     // stores the tag that represents the file (or and error code)
   LOCAL_VAR SLONG slResult         // stores the number of bytes read (or an error code)
   STACK_VAR CHAR  oneline[2000]    // a buffer for reading one line.  Must be as big or bigger than the biggest line
   STACK_VAR INTEGER INC

   slFileHandle = FILE_OPEN('IP_ADDRESSING.txt',FILE_READ_ONLY) // OPEN FILE FROM THE BEGINNING

   IF(slFileHandle>0)               // A POSITIVE NUMBER IS RETURNED IF SUCCESSFUL
    {

    slResult = 1               // seed with a good number so the loop runs at least once

	WHILE(slResult>0)
	{
            
	    
	    //
	    
	    slResult = FILE_READ_LINE(slFileHandle,oneline,MAX_LENGTH_STRING(oneline)) // grab one line from the file
            parseLineFromFile(oneline) //sends line to parse function
	    
	    
	    
	}
    FILE_CLOSE(slFileHandle)   // CLOSE THE LOG FILE
    }           

    ELSE
    {
    SEND_STRING 0,"'FILE OPEN ERROR:',ITOA(slFileHandle)"  // IF THE LOG FILE COULD NOT BE CREATED
    }

}

DEFINE_FUNCTION parseLineFromFile(CHAR aLine[2000]) //gets line here

{

    LOCAL_VAR CHAR Protocol // Need to compare... IF TCP = 1 UDP = 2 UDP with Receive = 3
    LOCAL_VAR CHAR cPos1 // Position of the first comma
    LOCAL_VAR CHAR cPos2 // Position of the second comma
    LOCAL_VAR CHAR cPos3 // Position of the third comma
    /// normal string parsing here...
    cPos1 = FIND_STRING(aLine,',',1) //Find the first comma in aLine starting at beginning. 
    cPos2 = FIND_STRING(aline,',',cPos1) //Find the next comma in sequence starting at position 1.
    cPos3 = FIND_STRING(aLine,',',cPos2) //Find the next comma in sequence starting at position 2. 
    
    LocalPort 	= type_cast(LEFT_STRING(aLine,cPos1-1)); //Grabs everything left of cPos1
    IPAddress 	= type_cast(mid_string(aLine,cPos1,cPos2-cPos1)); 
    IPPort 	= type_cast(mid_string(aLine,cPos2,cPos3-cPos2)); //Should grab string x in length starting at cPos1.
    Protocol 	= type_cast(right_string(aLine,3)); //grabs what's left over. 
    IF (Protocol == 'tcp')
    {
	nProtocol = 1;
    }
    ELSE IF (Protocol == 'udp')
    { 
	nProtocol = 2;
    }
    ELSE
    {
	nProtocol = 3;
    }
    send_command dvTP_LIGHT,"'^TXT-11,0,LocalPort',LocalPort";
    send_command dvTP_LIGHT,"'^TXT-12,0,IPAddress',LocalPort";
    //send_command dvTP_LIGHT,"'^TXT-12,0,IPAddress',IPAddress";
    send_command dvTP_LIGHT,"'^TXT-13,0,IPPort',LocalPort";
    //send_command dvTP_LIGHT,"'^TXT-13,0,IPPort',IPPort";
    send_command dvTP_LIGHT,"'^TXT-14,0,nProtocol',nProtocol";
}


*)




#include 'SNAPI.axi';
//#include 'IP_ADDRESSING.txt';

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START






//Array for Projector Input Select Commands

sInputSelect[1] = "$02,$03,$00,$00,$02,$01,$11,$19"; 	//Select Component
sInputSelect[2] = "$02,$03,$00,$00,$02,$01,$0B,$13"; 	//Select S-Video
sInputSelect[3] = "$02,$03,$00,$00,$02,$01,$01,$09"; 	//Select HDMI	//$09
sInputSelect[4] = "$02,$03,$00,$00,$02,$01,$06,$0E"; 	//Select Video

sProjCommands[1] = "$02,$00,$00,$00,$00,$02"; 		// Power On 
sProjCommands[2] = "$02,$01,$00,$00,$00,$03"; 		// Power Off
sProjCommands[3] = "$02,$10,$00,$00,$00,$12";		// Picture Mute On
sProjCommands[4] = "$02,$11,$00,$00,$00,$13";		// Picture Mute Off
sProjCommands[5] = "$03,$8C,$00,$00,$00,$8F";		// Lamp Information
sProjCommands[6] = "$00,$85,$00,$D0,$01,$01,$57";	// Running Status Request

//Make these match their buttons?
sDVDCommands[1]	= "$20,$21,$0D"; 	//Play
sDVDCommands[2]	= "$20,$20,$0D"; 	//Stop
sDVDCommands[3]	= "$20,$22,$0D";	//Pause
sDVDCommands[4]	= "$20,$34,$0D";	//Skip Fwd
sDVDCommands[5]	= "$20,$33,$0D";	//Skip Rev
sDVDCommands[6]	= "$20,$32,$0D";	//Search Fwd
sDVDCommands[7]	= "$20,$31,$0D";	//Search Rev

sDVDCommands[8] = "$21,$11,$0D";	//Disc Type Inquiry
sDVDCommands[9] = "$21,$12,$0D";	//Transport Status Inquiry
sDVDCommands[10] = "$22,$00,$0D";	//Power Toggle

sDVDCommands[44] = "$24,$2A,$0D";	//Menu DVD Only
sDVDCommands[45] = "$24,$2C,$0D";	//Arrow Up DVD Only
sDVDCommands[46] = "$24,$2D,$0D";	//Arrow Down DVD Only
sDVDCommands[47] = "$24,$2F,$0D";	//Arrow Left DVD Only
sDVDCommands[48] = "$24,$2E,$0D";	//Arrow Right DVD Only
sDVDCommands[49] = "$24,$2B,$0D";	//Select DVD Only





//Timelines
//
//
timeline_create(tl_FEEDBACK,lFeedbackTime,length_array(lFeedbackTime),timeline_absolute,timeline_repeat);
timeline_create(tl_COUNT,lCountTime,length_array(lCountTime),timeline_absolute,timeline_repeat);
timeline_create(tl_LAMPHOURS,lLampHoursTime,length_array(lLampHoursTime),timeline_absolute,timeline_repeat);

//create time line ( Time line constant, timeline array, array length, absolute, repeating )



//Modules go last
//define_module 'Sony_EVID100_Comm_dr1_0_0' COMM_CAM_1 (vdvCAM, dvCAM);
define_module 'Sony_EVID100_Comm_dr1_0_0' mCamDev1(vdvCAM, dvCAM)
define_module 'VirtualKeypad_dr1_0_0' VKP(VIRTUALKEYPAD,dvVIRTUALKEYPAD)

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

//Data Events
//
//
//
data_event[dvMaster]
{
    online:
    {
	
	
	fnInitializeLightArray()
	//Get IP info
	fnReadFromFile()
	//Initialize connection to lighting
	fnOpenTCPConnect(dvLIGHTS, IPAddress, ATOI(IPPort))
	//fnOpenTCPConnect(dvLIGHTS, LIGHTING_IP_ADDRESS, LIGHTING_PORT)
	//fnInitializeLightConnection()
	//Initialize Lighting Array
	
	fnQueryTP()
	

	(*
	SLONG IP_CLIENT_OPEN (INTEGER LocalPort, CHAR ServerAddress[ ], LONG ServerPort, INTEGER Protocol)
    *)

	
	
    }
    string:
    {

    
    }

}


data_event[dvVPJ1]
{
    online:
    {
	send_command dvVPJ1,"'SET BAUD 38400,N,8,1'";
	send_command dvVPJ1,"'HSOFF'";
    }
    string: 				// String Handler -- handles feedback from projector
    {
	local_var char sFromProj[9];
	//local_var char cStatusByte[1];
	//local_var char cInputByte[1];
	sFromProj = data.text;
	fnParseProj(sFromProj); //sends string to parse function
    }
}

data_event[dvDVD]
{
    online:
    {
	send_command dvDVD,"'SET BAUD 9600,N,8,1'";
	send_command dvDVD,"'HSOFF'";
    }
    string:
    {
	local_var char sFromDVD[2];
	sFromDVD = data.text;
	fnParseDVD(sFromDVD);
    }
}

data_event[vdvCAM]
{
    online:
    {
	//send_command vdvCAM,"'SET BAUD 9600,N,8,1'";
	//send_command vdvCAM,"'HSOFF'";
    }
  
    

    command:
    {
	local_var char sFromCAM[13]
	sFromCAM = data.text;
	fnParseVDVCAM(sFromCAM)
    }
    
}

data_event[dvIR1]
{
    online:
    {
	send_command dvIR1,"'SET MODE IR'";		// Set Mode to IR
	send_command dvIR1,"'CARON'";			// Set Carrier ON
	send_command dvIR1,"'CTON',3";			// Set queuing time to 3 tenths of a second on
	send_command dvIR1,"'CTOF',2";			// Set queuing time to 2 tenths of a second off
	send_command dvIR1,"'XCHM-1'";
	
    //Create an integer array and assign 6 TV station nymbers during the ONLINE event for this device.

	nTVStations[1] = 10;
	nTVStations[2] = 200;
	nTVStations[3] = 33;
	nTVStations[4] = 1;
	nTVStations[5] = 14;
	nTVStations[6] = 12;
	
    }
}

data_event[dvSWT1]
{
    online:
    {
	send_command dvSWT1,"'SET BAUD 9600,N,8,1'";
	send_command dvSWT1,"'HSOFF'";
    }
    string: 				// String Handler -- handles feedback from switcher
    {
	local_var char sFromSWT1[9];
	local_var char cInput[2];
	local_var char cOutput[1];
	//local_var char cStatusByte[1];
	//local_var char cInputByte[1];
	sFromSWT1 = data.text;
	//cInput = REMOVE_STRING(sFromSWT1,'IN',1)
	cInput = type_cast(mid_string(sFromSWT1,7,LENGTH_STRING(sFromSWT1) - 7));
	cOutput = type_cast(mid_string(sFromSWT1,4,1));
	send_command dvTP_SEC,"'^TXT-11,0,OUT',cOutput";
	send_command dvTP_SEC,"'^TXT-12,0,',sFromSWT1";
	send_command dvTP_SEC,"'^TXT-13,0,IN',cInput";
	//cInput = type_cast(LEFT_STRING(cButtonString,LENGTH_STRING(cButtonString) - 1)
	
	//fnParseSWT1(sFromSWT1); //sends string to parse function
	
	    //to[dvTP,button.input.channel]


    }
    
}

data_event[dvLIGHTS]
{
    online:
    {
	fnOpenTCPConnect(dvLIGHTS, IPAddress, ATOI(IPPort))
	//fnOpenTCPConnect(dvLIGHTS, LIGHTING_IP_ADDRESS, LIGHTING_PORT)
	ON[dvLIGHTS,DEVICE_COMMUNICATING]
    }
    offline:
    {
	OFF[dvLIGHTS,DEVICE_COMMUNICATING]
    }
    onerror:
    {	
	fnOpenTCPConnect(dvLIGHTS, IPAddress, ATOI(IPPort))
	//fnOpenTCPConnect(dvLIGHTS, LIGHTING_IP_ADDRESS, LIGHTING_PORT)
    }
    string:
    {
	local_var char sFromLightingControl[12]
	local_var integer nZone
	local_var integer nLevel
	
	//DL,[1:4],50
	sFromLightingControl = data.text;			//String from device
	fnParseLights(sFromLightingControl)
	//nZone = ATOI(mid_string(sFromLightingControl,7,1));	//Get Zone
	//nLevel = ATOI(mid_string(sFromLightingControl,10,3));	//Get Level
	//send_level dvTP_LIGHT, nLevelArray[nZone],(nLevel * 2.55);
	
    }

    
    
    
}

data_event[VIRTUALKEYPAD]
{
    online:
    {
	send_command VIRTUALKEYPAD, "'LINETEXT1-'"
	send_command VIRTUALKEYPAD, "'LINETEXT2-AMX'"
	send_command VIRTUALKEYPAD, "'LINETEXT3-'"
	send_command VIRTUALKEYPAD, "'LABEL1-TEST'"
	send_command VIRTUALKEYPAD, "'LABEL2-',BUTTON2"
	send_command VIRTUALKEYPAD, "'LABEL3-',BUTTON3"
	send_command VIRTUALKEYPAD, "'LABEL4-',BUTTON4"
	send_command VIRTUALKEYPAD, "'LABEL5-',BUTTON5"
	send_command VIRTUALKEYPAD, "'LABEL6-',BUTTON6"
	send_command VIRTUALKEYPAD, "'LABEL7-',BUTTON7"
	send_command VIRTUALKEYPAD, "'LABEL8-',BUTTON8"
	send_command VIRTUALKEYPAD, "'LABEL9-',BUTTON9"
	send_command VIRTUALKEYPAD, "'LABEL10-',BUTTON10"
	send_command VIRTUALKEYPAD, "'LABEL11-',BUTTON11"
	send_command VIRTUALKEYPAD, "'LABEL12-',BUTTON12"
    }
    
}

data_event[dvTP]
{
    STRING:
    {
	
	//sToSend = "'10001:1:0,',sFromTP,',',DATE,',',TIME"
	//sToSend = "'10001:1:0,',DATE,',',TIME"
	
	

    }
    ONLINE:
    {

    }
    
}
custom_event[dvTP,0,1315]//This was such a fucking pain in the ass to figure out
{
    sFromTP = custom.text
    cDATE = DATE
    cTIME = TIME
    sToSend = "'10001:1:0,',sFromTP,',',cDate,'&',cTime"
    appendToFile('MAC_ADDRESSING.TXT',sToSend)
}



BUTTON_EVENT [dvTP,50]
{
PUSH:
{
SEND_COMMAND dvTP,"'?MAC'" //1001-Read Text

}
}


//SWITCHER BUTTON EVENTS
//
//

button_event[dvTP_SEC,nVideoSwitcherButton]
{
    push:
    {
	switch(button.input.channel)
	{
	    case 11:
	    case 12:
	    case 13:
	    case 14:
	    
	    case 21:
	    case 22:
	    case 23:
	    case 24:
	    
	    case 31:
	    case 32:
	    case 33:
	    case 34:
	    
	    case 41:
	    case 42:
	    case 43:
	    case 44:
	    
	    case 51:
	    case 52:
	    case 53:
	    case 54:
	    
	    case 61:
	    case 62:
	    case 63:
	    case 64:
	    
	    case 71:
	    case 72:
	    case 73:
	    case 74:
	    
	    case 81:
	    case 82:
	    case 83:
	    case 84:
	    
	    case 91:
	    case 92:
	    case 93:
	    case 94:
	    
	    case 101:
	    case 102:
	    case 103:
	    case 104:
	    
	    case 111:
	    case 112:
	    case 113:
	    case 114:
	    
	    case 121:
	    case 122:
	    case 123:
	    case 124:
	    {	
		stack_var char cButtonString[3]
		stack_var char cInput[2]
		stack_var char cOutput[1]
		stack_var integer cOUT
		cButtonString = ITOA(button.input.channel)
		cOutput = RIGHT_STRING(cButtonString,1)
		cInput = LEFT_STRING(cButtonString,LENGTH_STRING(cButtonString) - 1)
		cOUT = ATOI(cOutput)
		send_string dvSWT1,"cInput,'*',cOutput,'S'";
		
		//off[dvTP_SEC,nVideoSwitcherButtons[cOUT]];
		on[dvTP_SEC,button.input.channel];
	    }
	}
    }
}




//Button Events
//
//
//
button_event[dvTP,0]
{
    push:
    {
	//nSource=button.input.channel; 	This defines the button press as local nSource. Not sure why I would use this instead...yet...
	//switch(nSource)
	switch(button.input.channel)
	{
	    //let's see if we can stack these
	    case 11:
	    {
		fnCheckPowerStatus()
		fnStartPollingDVD()
		nActiveSource = COMPONENT;
		fnSendToProj()

		
		
	    }
	    case 12:
	    {
		fnCheckPowerStatus()
		nActiveSource = SVIDEO;
		fnSendToProj()
	    }
	    case 13:
	    {
		fnCheckPowerStatus()
		nActiveSource = HDMI;
		fnSendToProj()
	    }
	    case 14:
	    {
		fnCheckPowerStatus()
		nActiveSource = VIDEO;
		fnSendToProj()
	    }
	    
	    
	    //{
//		fnCheckPowerStatus()
//		//nActiveSource = button.input.channel-10;
//		if(nActiveSource == 4)
//		{
//		    fnRouteActive()
//		    fnSendToProj()
//		}
//		else
//		{
//		    fnSendToProj()
//		}
//		
//		
//	    }
	    //SCREEN CONTROLS -- CHANNEL EVENT HANDLES FEEDBACK
	    case 101:
	    {
		fnScreenUp()
	    }
	    case 102:
	    {
		fnScreenDown()
	    }
	    CASE 103:
	    {
		fnScreenStop()
	    }
	    case 105:		// Power Button
	    {
		if (nSystemStatus==1)
		{
		fnShutdown()
		//send_command dvTP,'@PPN-Confirm'
		}
		else
		{
		
		fnCheckPowerStatus()
		}
	    }
	    case 106:
	    {
		to[dvTP,button.input.channel]
		fnShutdown1()
	    }
	     default:
	    {
		to[dvTP,button.input.channel]	//This handles momentary feedback for any buttons not explictly defined
		//nActiveSource=0;
	    }
	    
	    

	}
    }
}



//DVD BUTTON EVENTS
//
//
button_event[dvTP_DVD,0]
{
    push:
    {
	switch(button.input.channel)
	{
	    case 1:	//Play
	    case 2:	//Stop
	    case 3:	//Pause
	    case 6:	//Search FWD
	    case 7:	//Search REV
	    {
		fnSendToDVD()
		//nDVDButton=button.input.channel;		
	    }
	    //Disk Agnostic
	    case 4:	//Skip FWD
	    case 5:	//Skip REV
	    {
	       if(nActiveDisk!=0)
		    {
			fnSendToDVD()
			to[dvTP_DVD,button.input.channel]
		    }
	    }
	    //DVD Only Functions
	    case 44:	//Menu
	    case 45:	//Up
	    case 46:	//Down
	    case 47:	//Left
	    case 48:	//Right
	    case 49:	//Select
	    {
		
		if(nActiveDisk==1)
		{
		    fnSendToDVD()
		    to[dvTP_DVD,button.input.channel]
		}
		
	    }
	    default:
	    {
		//to[dvTP_DVD,button.input.channel]	//This handles momentary feedback for any buttons not explictly defined
	    }
	}
    }
}

//CAMERA CONTROL BUTTON EVENTS

button_event[dvTP_CAM,nCameraButtons]
{
    push:
    {
	ON[vdvCAM,button.input.channel]	//buttons map to SNAPI channels - no need to redefine the wheel
    }
    release:
    {
	OFF[vdvCAM,button.input.channel]	
    }
}

button_event[dvTP_CAM,3016]
{
    push:
    {
	nFlag = 1
    }
    release:
    {
	nFlag = 0
    }
}

button_event[dvTP_CAM,nPresetButtons]
{
    push:
    {
	SEND_COMMAND vdvCAM,"'CAMERAPRESET-',ITOA(GET_LAST(nPresetButtons))"; //This likely won't work without an actual camera
    }
    release:
    {
    }
}

level_event[dvTP_LIGHT,3016]
{
    IF(nFlag = 1)
    {
	send_level vdvCAM, 3016, level.value
    }
}
    
level_event[vdvCAM,3016]
{
    send_level dvTP_CAM, 3016, level.value
}

//ROOM CONTROL BUTTON EVENTS
//
//
button_event[dvTP_ROOM,0]
{
    push:
    {
	switch(button.input.channel)
	{
	    case 31:			//HDMI
	    {
		nActiveSource = HDMI;
		fnSendToProj()
	    }
	    case 32:			//S-Video
	    {
		nActiveSource = SVIDEO;
		fnSendToProj()
	    }
	    case 33:			//Video
	    {
		nActiveSource = VIDEO;
		fnSendToProj()
	    }
	    case 34:			//Component
	    {
		nActiveSource = COMPONENT;
		fnSendToProj()
	    }
	    
	    
	    
	    case 255:
	    {
		fnProjectorOn()
	    }
	}
    }
 
}

//Sat Receiver Button Events
//
//

button_event[dvTP_SAT,0]
{
    push:
    {
	switch(button.input.channel)
	{	
	    case 225:
	    {
		set_pulse_time(1);
		pulse[dvIR1,CHAN_UP];
		set_pulse_time(5);
	    }
	    case 226:
	    {
		set_pulse_time(1);
		pulse[dvIR1,CHAN_DN];
		set_pulse_time(5);
	    }
	}
    }
}

button_event[dvTP_SAT,nSatButtons]
{
    push:
    {
	send_command dvIR1,"'XCH-',ITOA(nTVStations[GET_LAST(nSatButtons)])"; // This doesn't work with the emulator -- Fixed with ITOA
	to[dvTP_SAT,button.input.channel]
    }
}

//Lighting Control Button Events
#WARN 'FILE READ FUNCTION IS STILL REFERENCING TEST DATA - FIX BEFORE DEPLOYING'

button_event[dvTP_LIGHT,nRaiseDimButtons]
{
    push:
    {
	to[dvTP_LIGHT,button.input.channel]
	send_string dvLIGHTS,"'RAISEDIM,[1:',ITOA(GET_LAST(nRaiseDimButtons)),']',$0d"; //Translates buttons to zones 1-4 via array index
    }
    release:
    {
	send_string dvLIGHTS,"'STOPDIM,[1:',ITOA(GET_LAST(nRaiseDimButtons)),']',$0d";
    }

}
button_event[dvTP_LIGHT,nLowerDimButtons]
{
    push:
    {
	to[dvTP_LIGHT,button.input.channel]
	send_string dvLIGHTS,"'LOWERDIM,[1:',ITOA(GET_LAST(nLowerDimButtons)),']',$0d"; //Translates buttons to zones 1-4 via array index
    }
    release:
    {
	send_string dvLIGHTS,"'STOPDIM,[1:',ITOA(GET_LAST(nLowerDimButtons)),']',$0d";
    }

}
button_event[dvTP_LIGHT,nSceneButtons]
{
    push:
    {
	local_var integer nZoneLoop
	local_var integer index
	local_var integer waitTime
	
	//waitTime = instancedScenes[index].instancedLights[nZoneLoop].fadeTime*100
	index = GET_LAST(nSceneButtons)
	//WHILE (nZoneLoop <=4)
	
	//WHILE (nZoneLoop <5)
	
//Loop it
(*
	FOR(nZoneLoop = 1; nZoneLoop <=4; nZoneLoop++)
	{
	    send_command dvTP_LIGHT,"'^TXT-10,0,',instancedScenes[index].sceneName"
	    wait  100
	    {
		
		send_string dvLIGHTS,"'FADEDIM,',ITOA(instancedScenes[index].instancedLights[nZoneLoop].lightIntensity),',',ITOA(instancedScenes[index].instancedLights[nZoneLoop].fadeTime),',0,[1:',ITOA(nZoneLoop),']',$0d";
		send_command dvTP_LIGHT,"'^TXT-10,0,CONFIRMED'"
	    }
	}
*)
//FOR loop sucks. Let's try a WHILE. This works, but only on a fast enough controller. Waits aren't working right. 

	nZoneLoop = 1
	//send_command dvTP_LIGHT,"'^TXT-10,0,',instancedScenes[index].sceneName"
	WHILE (nZoneLoop <= 4)
	{	
	    //send_command dvTP_LIGHT,"'^TXT-10,0,',instancedScenes[index].sceneName"

		send_string dvLIGHTS,"'FADEDIM,',ITOA(instancedScenes[index].instancedLights[nZoneLoop].lightIntensity),',',ITOA(instancedScenes[index].instancedLights[nZoneLoop].fadeTime),',0,[1:',ITOA(nZoneLoop),']',$0d";
		send_command dvTP_LIGHT,"'^TXT-10,0,CONFIRMED'"
		nZoneLoop++
	
	}

//Non Looping - This works for sure, but let's make it a little more elegant and time efficient.
(*
	send_command dvTP_LIGHT,"'^TXT-10,0,',instancedScenes[index].sceneName"
	
	//FADEDIM,intensity,fadetime,delaytime,[unit:zone]
	//This fucking string.
	    nZoneLoop = 1
	    send_string dvLIGHTS,"'FADEDIM,',ITOA(instancedScenes[index].instancedLights[nZoneLoop].lightIntensity),',',ITOA(instancedScenes[index].instancedLights[nZoneLoop].fadeTime),',0,[1:',ITOA(nZoneLoop),']',$0d";
	    wait 50
	    {
		nZoneLoop = 2
		send_string dvLIGHTS,"'FADEDIM,',ITOA(instancedScenes[index].instancedLights[nZoneLoop].lightIntensity),',',ITOA(instancedScenes[index].instancedLights[nZoneLoop].fadeTime),',0,[1:',ITOA(nZoneLoop),']',$0d";
		wait 50
		{
		    nZoneLoop = 3 
		    send_string dvLIGHTS,"'FADEDIM,',ITOA(instancedScenes[index].instancedLights[nZoneLoop].lightIntensity),',',ITOA(instancedScenes[index].instancedLights[nZoneLoop].fadeTime),',0,[1:',ITOA(nZoneLoop),']',$0d";
		    wait 50
		    {
			nZoneLoop = 4
			send_string dvLIGHTS,"'FADEDIM,',ITOA(instancedScenes[index].instancedLights[nZoneLoop].lightIntensity),',',ITOA(instancedScenes[index].instancedLights[nZoneLoop].fadeTime),',0,[1:',ITOA(nZoneLoop),']',$0d";
		    }
		}
	    }
	//send_command dvLights,"'FADEDIM,',ITOA(nTensity),',',,',0,[1:',ITOA(GET_LAST(nLowerDimButtons)),']',$0d"; //Use direct set for lights. Simplifies everything.
*)	
	
    }
    release:
    {
    }
}
(*
button_event[dvTP_LIGHT,0] 
{
    push:
    {
	switch(button.input.channel)
	{
	    case 30:
	    case 31:
	    case 32:
	    {	
		//nSceneButtons for scene
		
		//Get light intensity from structure here. 
		//set up arrays and use indexes to cycle through structure? 
		//Create loop to cycle through all zones.
		//Use GET_LAST(nSceneButtons) for instancedScenes. Uses array index to set scene 1-3.
		local_var integer nZoneLoop
		nZoneLoop = 1
		
		WHILE (nZoneLoop <=4)
		{
		    on[dvTP_LIGHT,nSceneButtons]
		    wait 10
		    //FADEDIM,intensity,fadetime,delaytime,[unit:zone]
		    //This fucking string.
		    send_string dvLIGHTS,"'FADEDIM,',ITOA(instancedScenes[GET_LAST(nSceneButtons)].instancedLights[nZoneLoop].lightIntensity),',',ITOA(instancedScenes[GET_LAST(nSceneButtons)].instancedLights[nZoneLoop].fadeTime),',0,[1:',ITOA(GET_LAST(nSceneButtons)),']',$0d";
		    //send_command dvLights,"'FADEDIM,',ITOA(nTensity),',',,',0,[1:',ITOA(GET_LAST(nLowerDimButtons)),']',$0d"; //Use direct set for lights. Simplifies everything.
		    
		    off[dvTP_LIGHT,nSceneButtons]
		    nZoneLoop++
		}
	    (*
		'FADEDIM,intensity(instancedScenes[GET_LAST(nSceneButtons)].instancedLights[nZoneLoop].lightIntensity),fadetime(instancedScenes[GET_LAST(nSceneButtons)].instancedLights[nZoneLoop].fadeTime),delaytime(always zero),[unit:scene(GET_LAST(nSceneButtons))]'
		send_command dvLights,"'FADEDIM,',ITOA(nTensity),',',,',0,[1:',ITOA(GET_LAST(nLowerDimButtons)),']',$0d"; //Use direct set for lights. Simplifies everything.
		
		    #WARN 'I DIDNT COMPILE THIS CODE. COMMENT BEFORE COMPILING' 
		    instancedScenes[1].sceneName = 'Scene 1'
		    instancedScenes[1].instancedLights[1].lightIntensity	=	0
		    instancedScenes[1].instancedLights[1].fadeTime		=	0
		    instancedScenes[1].instancedLights[2].lightIntensity	=	0
		    instancedScenes[1].instancedLights[2].fadeTime		=	0
		    instancedScenes[1].instancedLights[3].lightIntensity	=	0
		    instancedScenes[1].instancedLights[3].fadeTime		=	0
		    instancedScenes[1].instancedLights[4].lightIntensity	=	0
		    instancedScenes[1].instancedLights[4].fadeTime		=	0
	    *)
	    
	    
	    
		//send_command dvLights,"'FADEDIM,',ITOA(nTensity),',0,0,[1:',ITOA(GET_LAST(nLowerDimButtons)),']',$0d"; //Use direct set for lights. Simplifies everything.
		//SEND_STRING dvLIGHTS, "'FADEDIM,',ITOA(instancedScenes[GET_LAST(nSceneButtons)].zone[loop].lightIntensity),',',ITOA(lightingScenes[index].zone[loop].fadeTimer),',0,[1:',ITOA(loop),']',CR"
		//			  FADEDIM        INTENSITY                              FADETIME                         DELAY TIME                                                 ADDRESS
		
		//Handles Feedback
		send_string dvTP_LIGHT,"'^TXT-10,0,',instancedScenes[GET_LAST(nSceneButtons)].sceneName";
		SceneFeedback = GET_LAST(nSceneButtons)
		// instancedScenes[1].sceneName = 'Scene 1'
	    }
	    case 35:
	    case 37: 
	    case 39:
	    case 41:
	    case 36:
	    case 38:
	    case 40:
	    case 42:
	    {
		to[dvTP_LIGHT,button.input.channel]
		IF(button.input.channel = nLowerDimButtons) //This might not work. 
		{
		    send_command dvLIGHTS,"'LOWERDIM,[1:',ITOA(GET_LAST(nLowerDimButtons)),']',$0d"; //Translates buttons to zones 1-4 via array index
		}
		ELSE
		{
		    send_string dvLIGHTS,"'RAISEDIM,[1:',ITOA(GET_LAST(nRaiseDimButtons)),']',$0d"; //Translates buttons to zones 1-4 via array index
		   // send_command dvLights,"'FADEDIM,',ITOA(nTensity),',0,0,[1:',ITOA(GET_LAST(nLowerDimButtons)),']',$0d"; //Use direct set for lights. Simplifies everything.
		}
	    }
	}
    }
    release:
    {
	switch(button.input.channel)
	{
	    case 30:
	    case 31:
	    case 32:
	    {
	    }
	    case 35:
	    case 37: 
	    case 39:
	    case 41:
	    {
		send_string dvLIGHTS,"'STOPDIM,[1:',ITOA(GET_LAST(nRaiseDimButtons)),']',$0d";
	    }
	    case 36:
	    case 38:
	    case 40:
	    case 42:
	    {
		send_string dvLIGHTS,"'STOPDIM,[1:',ITOA(GET_LAST(nLowerDimButtons)),']',$0d";
	    }
	}
    }
}
*)
//VIRTUAL KEYPAD BUTTON EVENTS
button_event[VIRTUALKEYPAD,BTNS]	//really no reason to use the btns array here. Might want get rid of it.
{
    push:
    {
	switch(button.input.channel)
	{
	    case 5:
	    {
		//Let's put this in a function.
		(*
		cDATE = DATE
		cTIME = TIME
		sToSend = "'10001:1:0,',sFromTP,',',cDate,'&',cTime"
		appendToFile('MAC_ADDRESSING.TXT',sToSend)
		*)
	    }
	    case 6:
	    {
		appendToFile('IDK.txt','Change is everywhere')
	    }
	    case 7:
	    {
		do_push(dvTP,50)
	    }
	    case 8:
	    {
		do_push(dvTP,button.input.channel+6)
	    }
	    case 12:
	    {
		IF(nSystemStatus==1)
		{
		    //Turn off amp and device power
		    pulse[dvRelays,AMP_POWER];
		    wait 100
		    pulse[dvRelays,DEV_POWER];
		    nSystemStatus=0
		}
		ELSE
		{
		    //turn on amp and device power
		    pulse[dvRelays,AMP_POWER];
		    wait 100
		    pulse[dvRelays,DEV_POWER];
		    nSystemStatus=1
		}
	    }
	}
    }
}

//CHANNEL EVENT FOR SCREEN CONTROLS -- HANDLES FEEDBACK:
channel_event[dvRelays,SCREEN_UP]
{
    ON:
    {
	on[dvTP,101];
    }
    OFF:
    {
	off[dvTP,101];
    }

}
channel_event[dvRelays,SCREEN_DN]
{
    ON:
    {
	on[dvTP,102];
    }
    OFF:
    {
	off[dvTP,102];
    }

}
channel_event[dvRelays,SCREEN_ST]
{
    ON:
    {
	on[dvTP,103];
    }
    OFF:
    {
	off[dvTP,103];
    }

}
//CHANNEL EVENT FOR SAT REC
channel_event[dvIR1,CHAN_UP]
{
    ON:
    {
	on[dvTP_SAT,225];
    }
    OFF:
    {
	off[dvTP_SAT,225];
    }

}
channel_event[dvIR1,CHAN_DN]
{
    ON:
    {
	on[dvTP_SAT,226];
    }
    OFF:
    {
	off[dvTP_SAT,226];
    }

}

//CHANNEL EVENT FOR IP LIGHTING CONTROL
channel_event[dvLIGHTS,DEVICE_COMMUNICATING]
{
    ON:
    {
	
    }
    OFF:
    {
	//fnInitializeLightConnection()
	fnOpenTCPConnect(dvLIGHTS, IPAddress, ATOI(IPPort))
	//fnOpenTCPConnect(dvLIGHTS, LIGHTING_IP_ADDRESS, LIGHTING_PORT)
    }
}

//System Events
//
//




//Timeline Events
//
//


//COUNTDOWN TIMERS
//timeline_event[TL_PROJ_WARM_COUNT]
//{
//    IF(nCountWarm)
//    {
//	nCountWarm--
//	
//	IF(nCountWarm)
//	{
//	    send_command dvTP_ROOM,"'^TXT-13,0,',ITOA(nCountWarm)";
//	}
//	ELSE
//	{
//	   send_command dvTP_ROOM,"'^TXT-13,0,ON'"; 
//	}
//    }
//    ELSE
//    {
//    }
//}
//timeline_event[TL_PROJ_COOL_COUNT]
//{
//    IF(nCountCool)
//    {
//	nCountCool--
//	
//	IF(nCountCool)
//	{
//	    send_command dvTP_ROOM,"'^TXT-12,0,',ITOA(nCountCool)";
//	}
//	ELSE
//	{
//	   send_command dvTP_ROOM,"'^TXT-12,0,OFF'"; 
//	}
//    }
//    ELSE
//    {
//    }
//}
//timeline_event[TL_PROJ_LAMPHOURS]
//{
//    if(nProjStatus == 1) // if projector is on
//    {
//	send_string dvVPJ1,"sProjCommands[5]"; //ask projector for lamp hours every 30 seconds
//    }
//}

//timeline_event[tl_COUNT]
//{
//
//}
//
//timeline_event[tl_LAMPHOURS]
//{
//    if(nProjStatus == 1) // if projector is on
//    {
//	send_string dvVPJ1,"sProjCommands[5]"; //ask projector for lamp hours every 30 seconds
//    }
//}




timeline_event[tl_COUNTDOWN]
{
    if(nCountWarm)
    {
	nCountWarm--
	if(nCountWarm)
	{
	    send_command dvTP_ROOM,"'^TXT-13,0,',ITOA(nCountWarm)";
	    send_command dvTP_ROOM,"'^TXT-12,0,WARMING'";
	}
	else
	{
	    send_command dvTP_ROOM,"'^TXT-13,0,PROJECTOR ON'";
	    send_command dvTP_ROOM,"'^TXT-12,0,PROJECTOR ON'";
	    
	}
    }
    if(nCountCool)
    {
	nCountCool--
	if(nCountCool)
	{
	    send_command dvTP_ROOM,"'^TXT-12,0,',ITOA(nCountCool)";
	    send_command dvTP_ROOM,"'^TXT-13,0,COOLING'";
	}
	else
	{
	    send_command dvTP_ROOM,"'^TXT-12,0,PROJECTOR OFF'";
	    send_command dvTP_ROOM,"'^TXT-13,0,PROJECTOR OFF'";
	    
	}
    }
}


//FIX THIS FOR COOLDOWN

//timeline_event[tl_COUNTDOWN]
//{
//    if(nCountCool)
//    {
//	nCountCool--
//	if(nCountCool)
//	{
//	    send_command dvTP_ROOM,"'^TXT-13,0,',ITOA(nCountCool)";
//	}
//	else
//	{
//	    send_command dvTP_ROOM,"'^TXT-13,0,PROJECTOR OFF'";
//	}
//    }
//}



timeline_event[tl_LAMPPOLL] //cycles every 30 seconds
{
    if(nProjStatus == 1) // if projector is on
    {
	send_string dvVPJ1,"sProjCommands[5]"; //ask projector for lamp hours every 30 seconds
    }
    
}
timeline_event[tl_DVDPOLL]
{
    
    send_string dvDVD,"sDVDCommands[8]";//asks for disk status
    send_string dvDVD,"sDVDCommands[9]";//asks for transport status
}



timeline_event[tl_FEEDBACK]
{
    //Scence Feedback
    [dvTP_LIGHT,30]	=	(SceneFeedback==1);
    [dvTP_LIGHT,31]	=	(SceneFeedback==2);
    [dvTP_LIGHT,32]	=	(SceneFeedback==3);
    
    // DVD CD Feedback
    
    [dvTP_DVD,1]	=	(nDVDButton==1);
    [dvTP_DVD,2]	=	(nDVDButton==2);
    [dvTP_DVD,3]	=	(nDVDButton==3);
    [dvTP_DVD,6]	=	(nDVDButton==6);
    [dvTP_DVD,7]	=	(nDVDButton==7);
 
    //Camera Control Feedback
    [dvTP_CAM,132]	=	[vdvCAM,132];
    [dvTP_CAM,133]	=	[vdvCAM,133];
    [dvTP_CAM,134]	=	[vdvCAM,134];
    [dvTP_CAM,135]	=	[vdvCAM,135];
    [dvTP_CAM,158]	=	[vdvCAM,158];
    [dvTP_CAM,159]	=	[vdvCAM,159];
    
    
    
    // Main Page Feedback
    [dvTP,11]		=	(nActiveSource==COMPONENT);	//1
    [dvTP,12]		=	(nActiveSource==SVIDEO);	//2
    [dvTP,13]		=	(nActiveSource==HDMI);		//3
    [dvTP,14]		=	(nActiveSource==VIDEO);		//4
    [dvTP_ROOM,31]	=	(nActiveSource==HDMI);		//3
    [dvTP_ROOM,32]	=	(nActiveSource==SVIDEO);	//2
    [dvTP_ROOM,33]	=	(nActiveSource==VIDEO);		//4
    [dvTP_ROOM,34]	=	(nActiveSource==COMPONENT);	//1
    [dvTP_ROOM,255]	=	(nProjStatus==1);

    //Virtual Keypad Feedback
    [VIRTUALKEYPAD,5]	=	[dvTP,11]
    [VIRTUALKEYPAD,6]	=	[dvTP,12]
    [VIRTUALKEYPAD,7]	=	[dvTP,13]
    [VIRTUALKEYPAD,8]	=	[dvTP,14]
    [VIRTUALKEYPAD,12]	=	[dvTP,105]
    
    //Power Button Feedback
  
    [dvTP,105] 		=	(nSystemStatus==1);
    
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



(*****************************************************************)
(*                       END OF PROGRAM                          *)
(*                                                               *)
(*         !!!  DO NOT PUT ANY CODE BELOW THIS COMMENT  !!!      *)
(*                                                               *)
(*****************************************************************)


