(*********************************************************************)
(*  AMX Corporation                                                  *)
(*  Copyright (c) 2004-2006 AMX Corporation. All rights reserved.    *)
(*********************************************************************)
(* Copyright Notice :                                                *)
(* Copyright, AMX, Inc., 2004-2007                                   *)
(*    Private, proprietary information, the sole property of AMX.    *)
(*    The contents, ideas, and concepts expressed herein are not to  *)
(*    be disclosed except within the confines of a confidential      *)
(*    relationship and only then on a need to know basis.            *)
(*********************************************************************)
MODULE_NAME = 'TASCAM_DVD01U_DiscDeviceComponent' (dev vdvDev[], dev dvTP, INTEGER nDevice, INTEGER nPages[])
(***********************************************************)
(* System Type : NetLinx                                   *)
(* Creation Date: 12/12/2007 11:14:23 AM                    *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

#include 'TASCAM_DVD01U_ComponentInclude.axi'

#include 'SNAPI.axi'

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

// Channels
BTN_TXT_GET_CAPACITY            = 1301  // Button: getDiscCapacity
BTN_GET_DISC_INFO               = 1302  // Button: getDiscInfo
BTN_GET_TITLE_INFO              = 1305  // Button: getTitleInfo
BTN_QUERY_DISC_PROPS            = 1303  // Button: queryDiscProperties
BTN_QUERY_TITLE_PROPS           = 1304  // Button: queryTitleProperties
BTN_SET_PLAY_POS                = 1306  // Button: setPlayPosition
BTN_DISC_COUNTER                = 1300  // Button: setTitleCounterNotificationOn
BTN_SET_PLAY_POS_SIGN           = 3300  // Button: setPlayPosition Sign (+/-)
BTN_SET_PLAY_POS_TITLE_POP      = 3301  // Button: setPlayPosition Title # (numpad popup)
BTN_SET_PLAY_POS_TRACK_POP      = 3302  // Button: setPlayPosition Track # (numpad popup)
BTN_SET_PLAY_POS_HR_POP         = 3303  // Button: setPlayPosition Counter hr (numpad popup)
BTN_SET_PLAY_POS_MIN_POP        = 3304  // Button: setPlayPosition Counter Min (numpad popup)
BTN_SET_PLAY_POS_SEC_POP        = 3305  // Button: setPlayPosition Counter Sec (numpad popup)
BTN_SET_PLAY_POS_FF_POP         = 3306  // Button: setPlayPosition Counter Frame (numpad popup)

// Levels

// Variable Text Addresses
TXT_SET_PLAY_POS_TRACK          = 3325  // Text: setPlayPosition

#IF_NOT_DEFINED TXT_SET_PLAY_POS_COUNTER
INTEGER TXT_SET_PLAY_POS_COUNTER[]=     // Text: setPlayPosition
{
 3326, 3327, 3328, 3329
}
#END_IF // TXT_SET_PLAY_POS_COUNTER

TXT_SET_PLAY_POS_TITLE          = 3324  // Text: setPlayPosition
TXT_DISC_INFO_ID                = 1302  // Text: Disc Info
TXT_TITLE_INFO_DISCNUM          = 1300  // Text: Title Info
TXT_GET_CAPACITY                = 1301  // Text: getDiscCapacity

// G4 CHANNELS
BTN_DISC_TRAY                   = 120   // Button: Disc Tray
BTN_DISC_RANDOM                 = 124   // Button: Random
BTN_DISC_REPEAT                 = 125   // Button: Repeat
BTN_DISC_NEXT                   = 55    // Button: Next Disc
BTN_DISC_PREV                   = 56    // Button: Previous Disc

#IF_NOT_DEFINED BTN_DISC_LIST
INTEGER BTN_DISC_LIST[]         =       // Button: Disc
{
  341,  342,  343,  344,  345,
  346,  347,  348,  349,  350,
  351,  352,  353,  354,  355,
  356,  357,  358,  359,  360
}
#END_IF // BTN_DISC_LIST



// G4 VARIABLE TEXT ADDRESSES

#IF_NOT_DEFINED TXT_DISC_INFO
INTEGER TXT_DISC_INFO[]         =       // Text: Disc Info
{
    1,    2,    3,    4,    5
}
#END_IF // TXT_DISC_INFO


#IF_NOT_DEFINED TXT_DISC_VALUES
INTEGER TXT_DISC_VALUES[]       =       // Text: Disc Value
{
  211,  212,  213,  214,  215,
  216,  217,  218,  219,  220
}
#END_IF // TXT_DISC_VALUES


#IF_NOT_DEFINED TXT_DISC_PROPERTIES
INTEGER TXT_DISC_PROPERTIES[]   =       // Text: Disc Property
{
  201,  202,  203,  204,  205,
  206,  207,  208,  209,  210
}
#END_IF // TXT_DISC_PROPERTIES

TXT_DISC_COUNTER                = 9     // Text: Title Counter

#IF_NOT_DEFINED TXT_TITLE_INFO
INTEGER TXT_TITLE_INFO[]        =       // Text: Title Info
{
    6,    7,    8
}
#END_IF // TXT_TITLE_INFO


#IF_NOT_DEFINED TXT_DISC_TITLE_PROPERTIES
INTEGER TXT_DISC_TITLE_PROPERTIES[]=    // Text: Title Property
{
  221,  222,  223,  224,  225,
  226,  227,  228,  229,  230
}
#END_IF // TXT_DISC_TITLE_PROPERTIES


#IF_NOT_DEFINED TXT_DISC_TITLE_VALUES
INTEGER TXT_DISC_TITLE_VALUES[] =       // Text: Title Value
{
  231,  232,  233,  234,  235,
  236,  237,  238,  239,  240
}
#END_IF // TXT_DISC_TITLE_VALUES



// SNAPI CHANNELS
SNAPI_BTN_DISC_RANDOM_OFF_ON              = 180 // Button: setRandomState
SNAPI_BTN_DISC_RANDOM_ALL_ON              = 179 // Button: setRandomState
SNAPI_BTN_DISC_RANDOM_DISC_ON             = 178 // Button: setRandomState
SNAPI_BTN_DISC_REPEAT_DISC_ON             = 181 // Button: setRepeatState
SNAPI_BTN_DISC_REPEAT_ALL_ON              = 183 // Button: setRepeatState
SNAPI_BTN_DISC_REPEAT_OFF_ON              = 184 // Button: setRepeatState
SNAPI_BTN_DISC_REPEAT_TRACK_ON            = 182 // Button: setRepeatState
SNAPI_BTN_DISC_RANDOM_DISC_FB             = 178 // Button: processRandomStateEvent
SNAPI_BTN_DISC_RANDOM_ALL_FB              = 179 // Button: processRandomStateEvent
SNAPI_BTN_DISC_RANDOM_OFF_FB              = 180 // Button: processRandomStateEvent
SNAPI_BTN_DISC_REPEAT_DISC_FB             = 181 // Button: processRepeatStateEvent
SNAPI_BTN_DISC_REPEAT_OFF_FB              = 184 // Button: processRepeatStateEvent
SNAPI_BTN_DISC_REPEAT_ALL_FB              = 183 // Button: processRepeatStateEvent
SNAPI_BTN_DISC_REPEAT_TRACK_FB            = 182 // Button: processRepeatStateEvent


(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT


(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE


(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE


(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

char sDISCCAPACITY[MAX_ZONE][20] = { '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '' }
char sTITLECOUNTER[MAX_ZONE][20] = { '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '' }

VOLATILE INTEGER nBTN_DISC_LIST = 0		// The currently selected disc
VOLATILE INTEGER bBTN_DISC_COUNTER = FALSE	// Tells if we should be receiving counter messages from the module
volatile integer nAdjusting = 0					// Flag to tell if we are adjusting a value and what value is being adjusted
volatile integer nTitlePropCounter = 0			// Which title property we're trying to display. Can't display more than the # of buttons we have (nTitlePropCount)
volatile integer nDiscPropCounter = 0			// Which disc property we're trying to display. Can't display more than the # of buttons we have (nDiscPropCount)
volatile integer nNumberOfDiscs = 0				// total number of discs
volatile integer nDiscLoop = 0
volatile char sPlayFromTitle[5] = '00000'		// The title to play from when issuing PLAYPOSITION
volatile char sPlayFromTrack[5] = '00000'		// The track to play from when issuing PLAYPOSITION
volatile char sPlayFromHour[2] = '00'			// The hour to play from when issuing PLAYPOSITION
volatile char sPlayFromMin[2] = '00'			// The minute to play from when issuing PLAYPOSITION
volatile char sPlayFromSec[2] = '00'			// The seconds to play from when issuing PLAYPOSITION
volatile char sPlayFromFrame[2] = '00'			// The frame to play from when issuing PLAYPOSITION
volatile char sPosNeg[1] = ''					// The +/- to play from when issuing PLAYPOSITION


//---------------------------------------------------------------------------------
//
// FUNCTION NAME:    OnDeviceChanged
//
// PURPOSE:          This function is used by the device selection BUTTON_EVENT
//                   to notify the module that a device change has occurred
//                   allowing updates to the touch panel user interface.
//
//---------------------------------------------------------------------------------
DEFINE_FUNCTION OnDeviceChanged()
{

    println ("'OnDeviceChanged'")
}

//---------------------------------------------------------------------------------
//
// FUNCTION NAME:    OnPageChanged
//
// PURPOSE:          This function is used by the page selection BUTTON_EVENT
//                   to notify the module that a component change may have occurred
//                   allowing updates to the touch panel user interface.
//
//---------------------------------------------------------------------------------
DEFINE_FUNCTION OnPageChanged()
{

    println ("'OnPageChanged'")
}

//---------------------------------------------------------------------------------
//
// FUNCTION NAME:    OnZoneChange
//
// PURPOSE:          This function is used by the zone selection BUTTON_EVENT
//                   to notify the module that a zone change has occurred
//                   allowing updates to the touch panel user interface.
//
//---------------------------------------------------------------------------------
DEFINE_FUNCTION OnZoneChange()
{


    println ("'OnZoneChange'")
}


//*********************************************************************
// Function : initialize
// Purpose  : initialize any variables to default values
// Params   : none
// Return   : none
//*********************************************************************
DEFINE_FUNCTION Initialize()
{
	nNumberOfDiscs = length_array(BTN_DISC_LIST)
}


DEFINE_MUTUALLY_EXCLUSIVE
([dvTp,BTN_DISC_LIST[1]]..[dvTp,BTN_DISC_LIST[LENGTH_ARRAY(BTN_DISC_LIST)]])


(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

strCompName = 'DiscDeviceComponent'

// Initialize all place holder variables here
Initialize()


(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT


(***********************************************************)
(*             TOUCHPANEL EVENTS GO BELOW                  *)
(***********************************************************)
DATA_EVENT [dvTP]
{

    ONLINE:
    {
        bActiveComponent = FALSE
        nActiveDevice = 1
        nActivePage = 0
        nActiveDeviceID = nNavigationBtns[1]
        nActivePageID = 0
        nCurrentZone = 1
        bNoLevelReset = 0

    }
    OFFLINE:
    {
        bNoLevelReset = 1
    }

}


//---------------------------------------------------------------------------------
//
// EVENT TYPE:       DATA_EVENT for vdvDev
//                   DiscDeviceComponent: data event 
//
// PURPOSE:          This data event is used to listen for SNAPI component
//                   commands and track feedback for the DiscDeviceComponent.
//
// LOCAL VARIABLES:  cHeader     :  SNAPI command header
//                   cParameter  :  SNAPI command parameter
//                   nParameter  :  SNAPI command parameter value
//                   cCmd        :  received SNAPI command
//
//---------------------------------------------------------------------------------
DATA_EVENT[vdvDev]
{
    COMMAND :
    {
        // local variables
        STACK_VAR CHAR    cCmd[DUET_MAX_CMD_LEN]
        STACK_VAR CHAR    cHeader[DUET_MAX_HDR_LEN]
        STACK_VAR CHAR    cParameter[DUET_MAX_PARAM_LEN]
        STACK_VAR INTEGER nParameter
        STACK_VAR CHAR    cTrash[20]
        STACK_VAR INTEGER nZone
        
        nZone = getFeedbackZone(data.device)
        
        // get received SNAPI command
        cCmd = DATA.TEXT
        
        // parse command header
        cHeader = DuetParseCmdHeader(cCmd)
        SWITCH (cHeader)
        {
            // SNAPI::?DISCCAPACITY
            CASE 'DISCCAPACITY' :
            {
                sDISCCAPACITY[nZone] = DuetParseCmdParam(cCmd)
                SEND_COMMAND dvTP,"'^TXT-',ITOA(TXT_GET_CAPACITY),',0,', sDISCCAPACITY[nZone]"

            }
            // SNAPI::TITLECOUNTER-<counter>
            CASE 'TITLECOUNTER' :
            {
                sTITLECOUNTER[nZone] = DuetParseCmdParam(cCmd)
                SEND_COMMAND dvTP,"'^TXT-',ITOA(TXT_DISC_COUNTER),',0,', sTITLECOUNTER[nZone]"

            }
            
            //----------------------------------------------------------
            // CODE-BLOCK For DiscDeviceComponent
            //
            // The following case statements are used in conjunction
            // with the DiscDeviceComponent code-block.
            //----------------------------------------------------------
            

			case 'TITLEINFO' :
			{
				stack_var char sTemp[20]
				
				// Get the title number
				sTemp = DuetParseCmdParam(cCmd)
				send_command dvTP, "'^TXT-',itoa(TXT_TITLE_INFO[1]),',0,',sTemp"
				
				// Get the duration
				sTemp = DuetParseCmdParam(cCmd)
				send_command dvTP, "'^TXT-',itoa(TXT_TITLE_INFO[2]),',0,',sTemp"
				
				// Get the number of tracks
				sTemp = DuetParseCmdParam(cCmd)
				send_command dvTP, "'^TXT-',itoa(TXT_TITLE_INFO[3]),',0,',sTemp"
				
				// Get the disc number
				sTemp = DuetParseCmdParam(cCmd)
				send_command dvTP, "'^TXT-',itoa(TXT_TITLE_INFO_DISCNUM),',0,',sTemp"
			}
			case 'TITLEPROP' :
			{
				nTitlePropCounter++
				
				if (nTitlePropCounter <= length_array(TXT_DISC_TITLE_PROPERTIES))
				{
					stack_var char sTemp[20]
					
					// Get the property key
					sTemp = DuetParseCmdParam(cCmd)
					send_command dvTP, "'^TXT-',itoa(TXT_DISC_TITLE_PROPERTIES[nTitlePropCounter]),',0,',sTemp"
					
					// Get the property value
					sTemp = DuetParseCmdParam(cCmd)
					send_command dvTP, "'^TXT-',itoa(TXT_DISC_TITLE_VALUES[nTitlePropCounter]),',0,',sTemp"
				}
				else
				{
					println('There are more Title properties than the number of vt windows. Not displaying remaining properties.')
				}
			}
			case 'DISCINFO' :
			{
				stack_var char sTemp[20]
				
				// Get the disc number
				sTemp = DuetParseCmdParam(cCmd)
				send_command dvTP, "'^TXT-',itoa(TXT_DISC_INFO[1]),',0,',sTemp"
				nBTN_DISC_LIST = atoi(sTemp)
				
				// Get the duration
				sTemp = DuetParseCmdParam(cCmd)
				send_command dvTP, "'^TXT-',itoa(TXT_DISC_INFO[2]),',0,',sTemp"
				
				// Get the number of titles
				sTemp = DuetParseCmdParam(cCmd)
				send_command dvTP, "'^TXT-',itoa(TXT_DISC_INFO[3]),',0,',sTemp"
				
				// Get the number of tracks
				sTemp = DuetParseCmdParam(cCmd)
				send_command dvTP, "'^TXT-',itoa(TXT_DISC_INFO[4]),',0,',sTemp"
				
				// Get the disc type
				sTemp = DuetParseCmdParam(cCmd)
				send_command dvTP, "'^TXT-',itoa(TXT_DISC_INFO[5]),',0,',sTemp"
				
				// Get the DBID
				sTemp = DuetParseCmdParam(cCmd)
				send_command dvTP, "'^TXT-',itoa(TXT_DISC_INFO_ID),',0,',sTemp"
			}
			case 'DISCPROP' :
			{
				nDiscPropCounter++
				
				if (nDiscPropCounter <= length_array(TXT_DISC_PROPERTIES))
				{
					stack_var char sTemp[20]
					
					// Get the property key
					sTemp = DuetParseCmdParam(cCmd)
					send_command dvTP, "'^TXT-',itoa(TXT_DISC_PROPERTIES[nDiscPropCounter]),',0,',sTemp"
					
					// Get the property value
					sTemp = DuetParseCmdParam(cCmd)
					send_command dvTP, "'^TXT-',itoa(TXT_DISC_VALUES[nDiscPropCounter]),',0,',sTemp"
				}
				else
				{
					println('There are more Disc properties than the number of vt windows. Not displaying remaining properties.')
				}
			}
            // SNAPI::DEBUG-<state>
            CASE 'DEBUG' :
            {
                // This will toggle debug printing
                nDbg = ATOI(DuetParseCmdParam(cCmd))
            }

        }
    }
}


//----------------------------------------------------------
// CHANNEL_EVENTs For DiscDeviceComponent
//
// The following channel events are used in conjunction
// with the DiscDeviceComponent code-block.
//----------------------------------------------------------


//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscDeviceComponent: channel button - momentary channel
//                   on DISC_REPEAT_TRACK_ON
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscDeviceComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, DISC_REPEAT_TRACK_ON]
{
    push:
    {
        if (bActiveComponent)
        {
            on[vdvDev[nCurrentZone], DISC_REPEAT_TRACK_ON]
            println (" 'on[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(DISC_REPEAT_TRACK_ON),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscDeviceComponent: channel button - momentary channel
//                   on DISC_REPEAT_OFF_ON
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscDeviceComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, DISC_REPEAT_OFF_ON]
{
    push:
    {
        if (bActiveComponent)
        {
            on[vdvDev[nCurrentZone], DISC_REPEAT_OFF_ON]
            println (" 'on[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(DISC_REPEAT_OFF_ON),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscDeviceComponent: channel button - momentary channel
//                   on DISC_REPEAT_ALL_ON
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscDeviceComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, DISC_REPEAT_ALL_ON]
{
    push:
    {
        if (bActiveComponent)
        {
            on[vdvDev[nCurrentZone], DISC_REPEAT_ALL_ON]
            println (" 'on[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(DISC_REPEAT_ALL_ON),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscDeviceComponent: channel button - momentary channel
//                   on DISC_REPEAT_DISC_ON
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscDeviceComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, DISC_REPEAT_DISC_ON]
{
    push:
    {
        if (bActiveComponent)
        {
            on[vdvDev[nCurrentZone], DISC_REPEAT_DISC_ON]
            println (" 'on[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(DISC_REPEAT_DISC_ON),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscDeviceComponent: channel button - momentary channel
//                   on DISC_RANDOM_DISC_ON
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscDeviceComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, DISC_RANDOM_DISC_ON]
{
    push:
    {
        if (bActiveComponent)
        {
            on[vdvDev[nCurrentZone], DISC_RANDOM_DISC_ON]
            println (" 'on[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(DISC_RANDOM_DISC_ON),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscDeviceComponent: channel button - momentary channel
//                   on DISC_RANDOM_ALL_ON
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscDeviceComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, DISC_RANDOM_ALL_ON]
{
    push:
    {
        if (bActiveComponent)
        {
            on[vdvDev[nCurrentZone], DISC_RANDOM_ALL_ON]
            println (" 'on[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(DISC_RANDOM_ALL_ON),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscDeviceComponent: channel button - momentary channel
//                   on DISC_RANDOM_OFF_ON
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscDeviceComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, DISC_RANDOM_OFF_ON]
{
    push:
    {
        if (bActiveComponent)
        {
            on[vdvDev[nCurrentZone], DISC_RANDOM_OFF_ON]
            println (" 'on[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(DISC_RANDOM_OFF_ON),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscDeviceComponent: momentary button - momentary channel
//                   on BTN_DISC_TRAY
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscDeviceComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_DISC_TRAY]
{
    push:
    {
        if (bActiveComponent)
        {
            pulse[vdvDev[nCurrentZone], DISC_TRAY]
            println (" 'pulse[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(DISC_TRAY),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscDeviceComponent: momentary button - momentary channel
//                   on BTN_DISC_PREV
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscDeviceComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_DISC_PREV]
{
    push:
    {
        if (bActiveComponent)
        {
            pulse[vdvDev[nCurrentZone], DISC_PREV]
            println (" 'pulse[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(DISC_PREV),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscDeviceComponent: momentary button - momentary channel
//                   on BTN_DISC_NEXT
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscDeviceComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_DISC_NEXT]
{
    push:
    {
        if (bActiveComponent)
        {
            pulse[vdvDev[nCurrentZone], DISC_NEXT]
            println (" 'pulse[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(DISC_NEXT),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscDeviceComponent: channel button - command
//                   on BTN_GET_TITLE_INFO
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscDeviceComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_GET_TITLE_INFO]
{
    push:
    {
        if (bActiveComponent)
        {
            send_command vdvDev[nCurrentZone], '?TITLEINFO'
            println ("'send_command ',dpstoa(vdvDev[nCurrentZone]),', ',39,'?TITLEINFO',39")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscDeviceComponent: channel button - command
//                   on BTN_GET_DISC_INFO
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscDeviceComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_GET_DISC_INFO]
{
    push:
    {
        if (bActiveComponent)
        {
            send_command vdvDev[nCurrentZone], '?DISCINFO'
            println ("'send_command ',dpstoa(vdvDev[nCurrentZone]),', ',39,'?DISCINFO',39")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscDeviceComponent: channel button - command
//                   on BTN_TXT_GET_CAPACITY
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscDeviceComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_TXT_GET_CAPACITY]
{
    push:
    {
        if (bActiveComponent)
        {
            send_command vdvDev[nCurrentZone], '?DISCCAPACITY'
            println ("'send_command ',dpstoa(vdvDev[nCurrentZone]),', ',39,'?DISCCAPACITY',39")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscDeviceComponent: momentary button - momentary channel
//                   on BTN_DISC_REPEAT
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscDeviceComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_DISC_REPEAT]
{
    push:
    {
        if (bActiveComponent)
        {
            pulse[vdvDev[nCurrentZone], DISC_REPEAT]
            println (" 'pulse[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(DISC_REPEAT),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscDeviceComponent: momentary button - momentary channel
//                   on BTN_DISC_RANDOM
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscDeviceComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_DISC_RANDOM]
{
    push:
    {
        if (bActiveComponent)
        {
            pulse[vdvDev[nCurrentZone], DISC_RANDOM]
            println (" 'pulse[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(DISC_RANDOM),']'")
        }
    }
}


//----------------------------------------------------------
// EXTENDED EVENTS For DiscDeviceComponent
//
// The following events are used in conjunction
// with the DiscDeviceComponent code-block.
//----------------------------------------------------------


//---------------------------------------------------------------------------------
//
// EVENT TYPE:       DATA_EVENT for dvTP
//                   DiscDeviceComponent: Keypad
//                   on SETUP CHANNEL
//
// PURPOSE:          This button event is used to listen for input from the keypad
//                   on the touch panel and update the DiscDeviceComponent Text Fields.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
data_event[dvTP.number:1:0]
{
    string:
    {
        if (bActiveComponent)
        {
			if (nAdjusting)
			{
				println("'Data from TP: ',data.text")
				if (find_string(data.text, 'ABORT', 1))
				{
					nAdjusting = 0
				}
				else
				{
					remove_string(data.text, 'KEYP-', 1)
					switch (nAdjusting)
					{
						case BTN_SET_PLAY_POS_TRACK_POP :
						{
							if (length_string(data.text) > 5)
							{
								send_command dvTP, "'@AKP-',data.text,';Track limited to 5 digits'"
							}
							else
							{
								sPlayFromTrack = data.text
								send_command dvTP, "'^TXT-',itoa(TXT_SET_PLAY_POS_TRACK),',0,',sPlayFromTrack"
								nAdjusting = 0
							}
						}
						case BTN_SET_PLAY_POS_TITLE_POP :
						{
							if (length_string(data.text) > 5)
							{
								send_command dvTP, "'@AKP-',data.text,';Title limited to 5 digits'"
							}
							else
							{
								sPlayFromTitle = data.text
								send_command dvTP, "'^TXT-',itoa(TXT_SET_PLAY_POS_TITLE),',0,',sPlayFromTitle"
								nAdjusting = 0
							}
						}
						case BTN_SET_PLAY_POS_HR_POP :
						{
							if (length_string(data.text) > 2)
							{
								send_command dvTP, "'@AKP-',data.text,';Hour limited to 2 digits'"
							}
							else
							{
								sPlayFromHour = data.text
								send_command dvTP, "'^TXT-',itoa(TXT_SET_PLAY_POS_COUNTER[1]),',0,',sPlayFromHour"
								nAdjusting = 0
							}
						}
						case BTN_SET_PLAY_POS_MIN_POP :
						{
							if (length_string(data.text) > 2)
							{
								send_command dvTP, "'@AKP-',data.text,';Minute limited to 2 digits'"
							}
							else
							{
								sPlayFromMin = data.text
								send_command dvTP, "'^TXT-',itoa(TXT_SET_PLAY_POS_COUNTER[2]),',0,',sPlayFromMin"
								nAdjusting = 0
							}
						}
						case BTN_SET_PLAY_POS_SEC_POP :
						{
							if (length_string(data.text) > 2)
							{
								send_command dvTP, "'@AKP-',data.text,';Second limited to 2 digits'"
							}
							else
							{
								sPlayFromSec = data.text
								send_command dvTP, "'^TXT-',itoa(TXT_SET_PLAY_POS_COUNTER[3]),',0,',sPlayFromSec"
								nAdjusting = 0
							}
						}
						case BTN_SET_PLAY_POS_FF_POP :
						{
							if (length_string(data.text) > 2)
							{
								send_command dvTP, "'@AKP-',data.text,';Frame limited to 2 digits'"
							}
							else
							{
								sPlayFromFrame = data.text
								send_command dvTP, "'^TXT-',itoa(TXT_SET_PLAY_POS_COUNTER[4]),',0,',sPlayFromFrame"
								nAdjusting = 0
							}
						}
					}
				}
			}
		}
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscDeviceComponent: channel range button - command
//                   on BTN_DISC_LIST
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the .
//
// LOCAL VARIABLES:  nLoop : number of buttons counter
//                   btn: current button pressed
//
//---------------------------------------------------------------------------------
button_event[dvTP, BTN_DISC_LIST]
{
    push:
    {
        if (bActiveComponent)
        {
			nBTN_DISC_LIST = get_last(BTN_DISC_LIST)
			
			send_command vdvDev[nCurrentZone], "'SETDISC-',itoa(nBTN_DISC_LIST)"
			println("'send_command ',dpstoa(vdvDev[nCurrentZone]),', ',39,'SETDISC-',itoa(nBTN_DISC_LIST),39")
		}
    }
}
//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscDeviceComponent: channel button - command
//                   on BTN_SET_PLAY_POS
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscDeviceComponent.
//
// LOCAL VARIABLES:  sPlayFromCounter : full counter string
//
//---------------------------------------------------------------------------------
button_event[dvTP, BTN_SET_PLAY_POS]
{
    push:
    {
        if (bActiveComponent)
        {
			stack_var char sPlayFromCounter[11]
			sPlayFromCounter = "sPosNeg, sPlayFromHour, ':', sPlayFromMin, ':', sPlayFromSec, '.', sPlayFromFrame"
			
			if (sPlayFromTrack != '00000')
			{
				if (sPlayfromTitle != '00000')
				{
					if (sPlayFromCounter != '00:00:00.00')
					{
						send_command vdvDev[nCurrentZone], "'PLAYPOSITION-',sPlayFromTitle,',',sPlayFromTrack,',',sPlayFromCounter"
						println("'send_command ',dpstoa(vdvDev[nCurrentZone]),', ',39,'PLAYPOSITION-',sPlayFromTitle,',',sPlayFromTrack,',',sPlayFromCounter,39")
					}
					else
					{
						send_command vdvDev[nCurrentZone], "'PLAYPOSITION-',sPlayFromTitle,',',sPlayFromTrack"
						println("'send_command ',dpstoa(vdvDev[nCurrentZone]),', ',39,'PLAYPOSITION-',sPlayFromTitle,',',sPlayFromTrack,39")
					}
				}
				else if (sPlayFromCounter != '00:00:00.00')
				{
					send_command vdvDev[nCurrentZone], "'PLAYPOSITION-',sPlayFromTrack,',',sPlayFromCounter"
					println("'send_command ',dpstoa(vdvDev[nCurrentZone]),', ',39,'PLAYPOSITION-',sPlayFromTrack,',',sPlayFromCounter,39")
				}
				else
				{
					send_command vdvDev[nCurrentZone], "'PLAYPOSITION-',sPlayFromTrack"
					println("'send_command ',dpstoa(vdvDev[nCurrentZone]),', ',39,'PLAYPOSITION-',sPlayFromTrack,39")
				}
			}
			else
			{
				println('Invalid track to play from')
			}
			
			sPlayFromTrack = '00000'
			sPlayFromTitle = '00000'
			sPlayFromHour = '00'
			sPlayFromMin = '00'
			sPlayFromSec = '00'
			sPlayFromFrame = '00'
			set_length_string(sPosNeg, 0)
		}
    }
}
//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscDeviceComponent: channel button - command
//                   on BTN_DISC_COUNTER
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscDeviceComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
button_event[dvTP, BTN_DISC_COUNTER]
{
    push:
    {
        if (bActiveComponent)
        {
			bBTN_DISC_COUNTER = !bBTN_DISC_COUNTER
			send_command vdvDev[nCurrentZone], "'TITLECOUNTERNOTIFY-',itoa(bBTN_DISC_COUNTER)"
			println("'send_command ',dpstoa(vdvDev[nCurrentZone]),', ',39,'TITLECOUNTERNOTIFY-',itoa(bBTN_DISC_COUNTER),39")
		}
    }
}
//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscDeviceComponent: channel button - command
//                   on BTN_QUERY_TITLE_PROPS
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscDeviceComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_QUERY_TITLE_PROPS]
{
    push:
    {
        if (bActiveComponent)
        {
			nTitlePropCounter = 0
            send_command vdvDev[nCurrentZone], '?TITLEPROPS'
            println ("'send_command ',dpstoa(vdvDev[nCurrentZone]),', ',39,'?TITLEPROPS',39")
        }
    }
}
//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscDeviceComponent: channel button - command
//                   on BTN_QUERY_DISC_PROPS
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscDeviceComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_QUERY_DISC_PROPS]
{
    push:
    {
        if (bActiveComponent)
        {
			nDiscPropCounter = 0
            send_command vdvDev[nCurrentZone], '?DISCPROPS'
            println ("'send_command ',dpstoa(vdvDev[nCurrentZone]),', ',39,'?DISCPROPS',39")
        }
    }
}
//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscDeviceComponent: channel button - command
//                   on BTN_SET_PLAY_POS_TRACK_POP,
//                   BTN_SET_PLAY_POS_TITLE_POP,
//                   BTN_SET_PLAY_POS_HR_POP,
//                   BTN_SET_PLAY_POS_MIN_POP,
//                   BTN_SET_PLAY_POS_SEC_POP,
//                   BTN_SET_PLAY_POS_FF_POP
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscDeviceComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
button_event[dvTP, BTN_SET_PLAY_POS_TRACK_POP]
button_event[dvTP, BTN_SET_PLAY_POS_TITLE_POP]
button_event[dvTP, BTN_SET_PLAY_POS_HR_POP]
button_event[dvTP, BTN_SET_PLAY_POS_MIN_POP]
button_event[dvTP, BTN_SET_PLAY_POS_SEC_POP]
button_event[dvTP, BTN_SET_PLAY_POS_FF_POP]
{
    push:
    {
        if (bActiveComponent)
        {
			nAdjusting = button.input.channel
			switch(nAdjusting)
			{
				case BTN_SET_PLAY_POS_TRACK_POP :
				{
					send_command dvTP, "'@AKP-;Enter Track (#####)'"
				}
				case BTN_SET_PLAY_POS_TITLE_POP :
				{
					send_command dvTP, "'@AKP-;Enter Title (#####)'"
				}
				case BTN_SET_PLAY_POS_HR_POP :
				{
					send_command dvTP, "'@AKP-;Enter Hour (##)'"
				}
				case BTN_SET_PLAY_POS_MIN_POP :
				{
					send_command dvTP, "'@AKP-;Enter Minute (##)'"
				}
				case BTN_SET_PLAY_POS_SEC_POP :
				{
					send_command dvTP, "'@AKP-;Enter Second (##)'"
				}
				case BTN_SET_PLAY_POS_FF_POP :
				{
					send_command dvTP, "'@AKP-;Enter Frame (##)'"
				}
			}
		}
    }
}
//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscDeviceComponent: channel button - command
//                   on BTN_SET_PLAY_POS_SIGN
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscDeviceComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
button_event[dvTP, BTN_SET_PLAY_POS_SIGN]
{
    push:
    {
		if (bActiveComponent)
		{
			if (length_string(sPosNeg))
				set_length_string(sPosNeg, 0)
			else
				sPosNeg = '-'
		}
    }
}


(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

[dvTP,DISC_REPEAT_TRACK_FB] = [vdvDev[nCurrentZone],DISC_REPEAT_TRACK_FB]
[dvTP,DISC_REPEAT_ALL_FB] = [vdvDev[nCurrentZone],DISC_REPEAT_ALL_FB]
[dvTP,DISC_RANDOM_DISC_FB] = [vdvDev[nCurrentZone],DISC_RANDOM_DISC_FB]
[dvTP,DISC_REPEAT_OFF_FB] = [vdvDev[nCurrentZone],DISC_REPEAT_OFF_FB]
[dvTP,DISC_REPEAT_DISC_FB] = [vdvDev[nCurrentZone],DISC_REPEAT_DISC_FB]
[dvTP,DISC_RANDOM_ALL_FB] = [vdvDev[nCurrentZone],DISC_RANDOM_ALL_FB]
[dvTP,DISC_RANDOM_OFF_FB] = [vdvDev[nCurrentZone],DISC_RANDOM_OFF_FB]

[dvTP, BTN_DISC_COUNTER] = bBTN_DISC_COUNTER
[dvTP, BTN_SET_PLAY_POS_SIGN] = (sPosNeg == '-')
for (nDiscLoop = 1; nDiscLoop <= nNumberOfDiscs; nDiscLoop++)
{
	if (nDiscLoop == nBTN_DISC_LIST)
		ON[dvTP, BTN_DISC_LIST[nBTN_DISC_LIST]]
}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

