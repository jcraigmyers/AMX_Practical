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
MODULE_NAME = 'TASCAM_DVD01U_DiscTransportComponent' (dev vdvDev[], dev dvTP, INTEGER nDevice, INTEGER nPages[])
(***********************************************************)
(* System Type : NetLinx                                   *)
(* Creation Date: 12/12/2007 11:14:25 AM                    *)
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
BTN_QUERY_TRACK_INFO            = 1325  // Button: getTrackInfo
BTN_QUERY_TRACK_PROPS           = 1326  // Button: queryTrackProperties
BTN_SET_PLAY_POS                = 1327  // Button: setPlayPosition
BTN_SET_TRACK_COUNTER_NOTIFY    = 1328  // Button: setTrackCounterNotificationOn
BTN_SET_PLAY_POS_SIGN           = 3325  // Button: setPlayPosition Sign (+/-)
BTN_SET_PLAY_POS_HR_POP         = 3326  // Button: setPlayPosition Counter Hr (numpad popup)
BTN_SET_PLAY_POS_MIN_POP        = 3327  // Button: setPlayPosition Counter Min (numpad popup)
BTN_SET_PLAY_POS_SEC_POP        = 3328  // Button: setPlayPosition Counter Sec (numpad popup)
BTN_SET_PLAY_POS_FF_POP         = 3329  // Button: setPlayPosition Counter Frame (numpad popup)

// Levels

// Variable Text Addresses
TXT_TRACK_INFO_DISCNUM          = 1325  // Text: Track Info

#IF_NOT_DEFINED TXT_SET_PLAY_POS_COUNTER
INTEGER TXT_SET_PLAY_POS_COUNTER[]=     // Text: setPlayPosition Counter
{
 3349, 3350, 3351, 3352
}
#END_IF // TXT_SET_PLAY_POS_COUNTER


// G4 CHANNELS
BTN_SCAN_SPEED                  = 192   // Button: Scan Speed
BTN_STOP                        = 2     // Button: Stop
BTN_SREV                        = 7     // Button: Search Reverse
BTN_FRAME_FWD                   = 185   // Button: Frame Forward
BTN_FRAME_REV                   = 186   // Button: Frame Reverse
BTN_FFWD                        = 4     // Button: Skip Next
BTN_PAUSE                       = 3     // Button: Pause
BTN_PLAY                        = 1     // Button: Play
BTN_REW                         = 5     // Button: Skip Previous
BTN_SFWD                        = 6     // Button: Search Forward
BTN_SLOW_FWD                    = 188   // Button: Slow Forward
BTN_SLOW_REV                    = 189   // Button: Slow Reverse
BTN_RECORD                      = 8     // Button: Record


// G4 VARIABLE TEXT ADDRESSES
TXT_DISC_TRACK_COUNTER          = 10    // Text: Track Counter

#IF_NOT_DEFINED TXT_TRACK_INFO
INTEGER TXT_TRACK_INFO[]        =       // Text: Track Info
{
   28,   29
}
#END_IF // TXT_TRACK_INFO


#IF_NOT_DEFINED TXT_TRACK_VALUES
INTEGER TXT_TRACK_VALUES[]      =       // Text: Track Values
{
  141,  142,  143,  144,  145,
  146,  147,  148,  149,  150
}
#END_IF // TXT_TRACK_VALUES


#IF_NOT_DEFINED TXT_TRACK_PROPERTIES
INTEGER TXT_TRACK_PROPERTIES[]  =       // Text: Track Properties
{
  131,  132,  133,  134,  135,
  136,  137,  138,  139,  140
}
#END_IF // TXT_TRACK_PROPERTIES



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

char sTRACKCOUNTER[MAX_ZONE][20] = { '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '' }

VOLATILE INTEGER bBTN_SET_TRACK_COUNTER_NOTIFY = FALSE	// Tells if we should be receiving counter messages from the module
volatile integer nAdjusting = 0					// Flag to tell if we are adjusting a value and what value is being adjusted
volatile integer nPropertyCount = 0				// Which disc property we're trying to display. Can't display more than the # of buttons we have (nDiscPropCount)
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

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

strCompName = 'DiscTransportComponent'
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
//                   DiscTransportComponent: data event 
//
// PURPOSE:          This data event is used to listen for SNAPI component
//                   commands and track feedback for the DiscTransportComponent.
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
            // SNAPI::TRACKCOUNTER-<counter>
            CASE 'TRACKCOUNTER' :
            {
                sTRACKCOUNTER[nZone] = DuetParseCmdParam(cCmd)
                SEND_COMMAND dvTP,"'^TXT-',ITOA(TXT_DISC_TRACK_COUNTER),',0,', sTRACKCOUNTER[nZone]"

            }
            
            //----------------------------------------------------------
            // CODE-BLOCK For DiscTransportComponent
            //
            // The following case statements are used in conjunction
            // with the DiscTransportComponent code-block.
            //----------------------------------------------------------
            

			case 'TRACKINFO' :
			{
				stack_var char sTemp[20]
				
				// Get the track number
				sTemp = DuetParseCmdParam(cCmd)
				send_command dvTP, "'^TXT-',itoa(TXT_TRACK_INFO[1]),',0,',sTemp"
				
				// Get the duration
				sTemp = DuetParseCmdParam(cCmd)
				send_command dvTP, "'^TXT-',itoa(TXT_TRACK_INFO[2]),',0,',sTemp"
				
				// Get the disc number
				sTemp = DuetParseCmdParam(cCmd)
				send_command dvTP, "'^TXT-',itoa(TXT_TRACK_INFO_DISCNUM),',0,',sTemp"
			}
			case 'TRACKPROP' :
			{
				nPropertyCount++
				
				if (nPropertyCount <= length_array(TXT_TRACK_PROPERTIES))
				{
					stack_var char sTemp[20]
					
					// Get the property key
					sTemp = DuetParseCmdParam(cCmd)
					send_command dvTP, "'^TXT-',itoa(TXT_TRACK_PROPERTIES[nPropertyCount]),',0,',sTemp"
					
					// Get the property value
					sTemp = DuetParseCmdParam(cCmd)
					send_command dvTP, "'^TXT-',itoa(TXT_TRACK_VALUES[nPropertyCount]),',0,',sTemp"
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
// CHANNEL_EVENTs For DiscTransportComponent
//
// The following channel events are used in conjunction
// with the DiscTransportComponent code-block.
//----------------------------------------------------------


//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscTransportComponent: momentary button - momentary channel
//                   on BTN_PAUSE
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscTransportComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_PAUSE]
{
    push:
    {
        if (bActiveComponent)
        {
            pulse[vdvDev[nCurrentZone], PAUSE]
            println (" 'pulse[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(PAUSE),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscTransportComponent: momentary button - momentary channel
//                   on BTN_SCAN_SPEED
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscTransportComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_SCAN_SPEED]
{
    push:
    {
        if (bActiveComponent)
        {
            pulse[vdvDev[nCurrentZone], SCAN_SPEED]
            println (" 'pulse[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(SCAN_SPEED),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscTransportComponent: momentary button - momentary channel
//                   on BTN_RECORD
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscTransportComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_RECORD]
{
    push:
    {
        if (bActiveComponent)
        {
            pulse[vdvDev[nCurrentZone], RECORD]
            println (" 'pulse[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(RECORD),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscTransportComponent: momentary button - momentary channel
//                   on BTN_SLOW_REV
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscTransportComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_SLOW_REV]
{
    push:
    {
        if (bActiveComponent)
        {
            pulse[vdvDev[nCurrentZone], SLOW_REV]
            println (" 'pulse[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(SLOW_REV),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscTransportComponent: momentary button - momentary channel
//                   on BTN_SLOW_FWD
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscTransportComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_SLOW_FWD]
{
    push:
    {
        if (bActiveComponent)
        {
            pulse[vdvDev[nCurrentZone], SLOW_FWD]
            println (" 'pulse[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(SLOW_FWD),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscTransportComponent: momentary button - momentary channel
//                   on BTN_SFWD
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscTransportComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_SFWD]
{
    push:
    {
        if (bActiveComponent)
        {
            pulse[vdvDev[nCurrentZone], SFWD]
            println (" 'pulse[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(SFWD),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscTransportComponent: momentary button - momentary channel
//                   on BTN_PLAY
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscTransportComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_PLAY]
{
    push:
    {
        if (bActiveComponent)
        {
            pulse[vdvDev[nCurrentZone], PLAY]
            println (" 'pulse[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(PLAY),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscTransportComponent: momentary button - momentary channel
//                   on BTN_FFWD
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscTransportComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_FFWD]
{
    push:
    {
        if (bActiveComponent)
        {
            pulse[vdvDev[nCurrentZone], FFWD]
            println (" 'pulse[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(FFWD),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscTransportComponent: momentary button - momentary channel
//                   on BTN_FRAME_REV
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscTransportComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_FRAME_REV]
{
    push:
    {
        if (bActiveComponent)
        {
            pulse[vdvDev[nCurrentZone], FRAME_REV]
            println (" 'pulse[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(FRAME_REV),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscTransportComponent: momentary button - momentary channel
//                   on BTN_FRAME_FWD
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscTransportComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_FRAME_FWD]
{
    push:
    {
        if (bActiveComponent)
        {
            pulse[vdvDev[nCurrentZone], FRAME_FWD]
            println (" 'pulse[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(FRAME_FWD),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscTransportComponent: momentary button - momentary channel
//                   on BTN_SREV
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscTransportComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_SREV]
{
    push:
    {
        if (bActiveComponent)
        {
            pulse[vdvDev[nCurrentZone], SREV]
            println (" 'pulse[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(SREV),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscTransportComponent: momentary button - momentary channel
//                   on BTN_STOP
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscTransportComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_STOP]
{
    push:
    {
        if (bActiveComponent)
        {
            pulse[vdvDev[nCurrentZone], STOP]
            println (" 'pulse[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(STOP),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscTransportComponent: channel button - command
//                   on BTN_QUERY_TRACK_INFO
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscTransportComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_QUERY_TRACK_INFO]
{
    push:
    {
        if (bActiveComponent)
        {
            send_command vdvDev[nCurrentZone], '?TRACKINFO'
            println ("'send_command ',dpstoa(vdvDev[nCurrentZone]),', ',39,'?TRACKINFO',39")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscTransportComponent: momentary button - momentary channel
//                   on BTN_REW
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscTransportComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_REW]
{
    push:
    {
        if (bActiveComponent)
        {
            pulse[vdvDev[nCurrentZone], REW]
            println (" 'pulse[',dpstoa(vdvDev[nCurrentZone]),', ',itoa(REW),']'")
        }
    }
}


//----------------------------------------------------------
// EXTENDED EVENTS For DiscTransportComponent
//
// The following events are used in conjunction
// with the DiscTransportComponent code-block.
//----------------------------------------------------------


//---------------------------------------------------------------------------------
//
// EVENT TYPE:       DATA_EVENT for dvTP
//                   DiscTransportComponent: Keypad
//                   on SETUP CHANNEL
//
// PURPOSE:          This button event is used to listen for input from the keypad
//                   on the touch panel and update the DiscTransportComponent Text Fields.
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
//                   DiscTransportComponent: channel button - command
//                   on BTN_SET_PLAY_POS
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscTransportComponent.
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
			
			send_command vdvDev[nCurrentZone], "'PLAYPOSITION-',sPlayFromCounter"
			println("'send_command ',dpstoa(vdvDev[nCurrentZone]),', ',39,'PLAYPOSITION-',sPlayFromCounter,39")
			
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
//                   DiscTransportComponent: channel button - command
//                   on BTN_SET_TRACK_COUNTER_NOTIFY
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscTransportComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
button_event[dvTP, BTN_SET_TRACK_COUNTER_NOTIFY]
{
    push:
    {
        if (bActiveComponent)
        {
			bBTN_SET_TRACK_COUNTER_NOTIFY = !bBTN_SET_TRACK_COUNTER_NOTIFY
			send_command vdvDev[nCurrentZone], "'TRACKCOUNTERNOTIFY-',itoa(bBTN_SET_TRACK_COUNTER_NOTIFY)"
			println("'send_command ',dpstoa(vdvDev[nCurrentZone]),', ',39,'TRACKCOUNTERNOTIFY-',itoa(bBTN_SET_TRACK_COUNTER_NOTIFY),39")
		}
    }
}
//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscTransportComponent: channel button - command
//                   on BTN_QUERY_TRACK_PROPS
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscTransportComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_QUERY_TRACK_PROPS]
{
    push:
    {
        if (bActiveComponent)
        {
			nPropertyCount = 0
            send_command vdvDev[nCurrentZone], '?TRACKPROPS'
            println ("'send_command ',dpstoa(vdvDev[nCurrentZone]),', ',39,'?TRACKPROPS',39")
        }
    }
}
//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   DiscTransportComponent: channel button - command
//                   on BTN_SET_PLAY_POS_HR_POP,
//                   BTN_SET_PLAY_POS_MIN_POP,
//                   BTN_SET_PLAY_POS_SEC_POP,
//                   BTN_SET_PLAY_POS_FF_POP
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscTransportComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
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
//                   DiscTransportComponent: channel button - command
//                   on BTN_SET_PLAY_POS_SIGN
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the DiscTransportComponent.
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

[dvTP,BTN_SLOW_FWD] = [vdvDev[nCurrentZone],SLOW_FWD_FB]
[dvTP,BTN_RECORD] = [vdvDev[nCurrentZone],RECORD_FB]
[dvTP,BTN_PLAY] = [vdvDev[nCurrentZone],PLAY_FB]
[dvTP,BTN_SREV] = [vdvDev[nCurrentZone],SREV_FB]
[dvTP,BTN_SLOW_REV] = [vdvDev[nCurrentZone],SLOW_REV_FB]
[dvTP,BTN_STOP] = [vdvDev[nCurrentZone],STOP_FB]
[dvTP,BTN_PAUSE] = [vdvDev[nCurrentZone],PAUSE_FB]
[dvTP,BTN_SFWD] = [vdvDev[nCurrentZone],SFWD_FB]

[dvTP, BTN_SET_PLAY_POS_SIGN] = (sPosNeg == '-')
[dvTP, BTN_SET_TRACK_COUNTER_NOTIFY] = bBTN_SET_TRACK_COUNTER_NOTIFY

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

