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
PROGRAM_NAME = 'Epson PowerLite905 Main' 
(***********************************************************)
(* System Type : NetLinx                                   *)
(* Creation Date: 7/29/2008 3:24:54 PM                    *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

vdvEpsonPowerLite905 = 41001:1:0  // The COMM module should use this as its duet device
//Serial
dvEpsonPowerLite905 = 5001:1:0 // This device should be used as the physical device by the COMM module
// IP
//dvEpsonPowerLite905 = 0:3:0 //This device should be used as the physical device by the COMM module via IP
dvEpsonPowerLite905Tp = 10001:1:0 // This port should match the assigned touch panel device port

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT


(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

DEV vdvDev[] = {vdvEpsonPowerLite905}

// ----------------------------------------------------------
// CURRENT DEVICE NUMBER ON TP NAVIGATION BAR
INTEGER nEpsonPowerLite905 = 1

// ----------------------------------------------------------
// DEFINE THE PAGES THAT YOUR COMPONENTS ARE USING IN THE 
// SUB NAVIGATION BAR HERE
INTEGER nLampPages[] = { 2 }
INTEGER nDisplayPages[] = { 3,4,5 }
INTEGER nSourceSelectPages[] = { 6 }
INTEGER nVolumePages[] = { 7 }
INTEGER nMenuPages[] = { 8,9,10 }
INTEGER nModulePages[] = { 11 }


(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

// ----------------------------------------------------------
// DEVICE MODULE GROUPS SHOULD ALL HAVE THE SAME DEVICE NUMBER
DEFINE_MODULE 'Epson_PowerLite905DisplayComponent' display(vdvDev, dvEpsonPowerLite905Tp, nEpsonPowerLite905, nDisplayPages)
DEFINE_MODULE 'Epson_PowerLite905LampComponent' lamp(vdvDev, dvEpsonPowerLite905Tp, nEpsonPowerLite905, nLampPages)
DEFINE_MODULE 'Epson_PowerLite905MenuComponent' menu(vdvDev, dvEpsonPowerLite905Tp, nEpsonPowerLite905, nMenuPages)
DEFINE_MODULE 'Epson_PowerLite905ModuleComponent' module(vdvDev, dvEpsonPowerLite905Tp, nEpsonPowerLite905, nModulePages)
DEFINE_MODULE 'Epson_PowerLite905SourceSelectComponent' sourceselect(vdvDev, dvEpsonPowerLite905Tp, nEpsonPowerLite905, nSourceSelectPages)
DEFINE_MODULE 'Epson_PowerLite905VolumeComponent' volume(vdvDev, dvEpsonPowerLite905Tp, nEpsonPowerLite905, nVolumePages)


// Define your communications module here like so:
DEFINE_MODULE 'Epson_PowerLite905_Comm_dr1_0_0' comm(vdvEpsonPowerLite905, dvEpsonPowerLite905)

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
DATA_EVENT [vdvEpsonPowerLite905]
{
    ONLINE:
    {
	#WARN 'Verify that PROPERTY-Poll_Time has been set to the desired setting - Defualt 10000.'
	#WARN'**********************************************************'
	#WARN'Verify the IP address for the device by accesing the Network menu item.'
	#WARN'Modify IP address for PROPERTY-IP_Address to match the one on the projector'
	#WARN'The password for IP control on the device is set to admin '
	#WARN'**********************************************************' 
	
		//send_command vdvEpsonPowerLite905,"'PROPERTY-IP_Address,192.168.206.48'"
               //send_command vdvEpsonPowerLite905,"'PROPERTY-Poll_Time,10000'"
	     //send_command vdvEpsonPowerLite905,"'REINIT'"
   }

}


(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

