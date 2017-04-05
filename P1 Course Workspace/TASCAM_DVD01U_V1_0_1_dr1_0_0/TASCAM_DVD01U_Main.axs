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
PROGRAM_NAME = 'TASCAM_DVD01U_Main' 
(***********************************************************)
(* System Type : NetLinx                                   *)
(* Creation Date: 12/12/2007 11:19:14 AM                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
#WARN 'Verify that the PROPERTY-Poll_Time has been set to the desired setting.'

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

vdvDiscDevice = 41001:1:0  // The COMM module should use this as its duet device
dvDiscDevice = 5001:1:0 // This device should be used as the physical device by the COMM module
dvDiscDeviceTp = 10001:1:0 // This port should match the assigned touch panel device port

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT


(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

DEV vdvDev[] = {vdvDiscDevice}

// ----------------------------------------------------------
// CURRENT DEVICE NUMBER ON TP NAVIGATION BAR
INTEGER nDiscDevice = 1

// ----------------------------------------------------------
// DEFINE THE PAGES THAT YOUR COMPONENTS ARE USING IN THE 
// SUB NAVIGATION BAR HERE
INTEGER nDiscDevicePages[] = { 1,2,3,4 }
INTEGER nDiscTransportPages[] = { 5,6 }
INTEGER nMenuPages[] = { 7,8,9 }
INTEGER nPowerPages[] = { 10 }
INTEGER nModulePages[] = { 11 }


(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START


// ----------------------------------------------------------
// DEVICE MODULE GROUPS SHOULD ALL HAVE THE SAME DEVICE NUMBER
DEFINE_MODULE 'TASCAM_DVD01U_DiscDeviceComponent' discdevice(vdvDev, dvDiscDeviceTp, nDiscDevice, nDiscDevicePages)
DEFINE_MODULE 'TASCAM_DVD01U_DiscTransportComponent' disctransport(vdvDev, dvDiscDeviceTp, nDiscDevice, nDiscTransportPages)
DEFINE_MODULE 'TASCAM_DVD01U_MenuComponent' menu(vdvDev, dvDiscDeviceTp, nDiscDevice, nMenuPages)
DEFINE_MODULE 'TASCAM_DVD01U_ModuleComponent' module(vdvDev, dvDiscDeviceTp, nDiscDevice, nModulePages)
DEFINE_MODULE 'TASCAM_DVD01U_PowerComponent' power(vdvDev, dvDiscDeviceTp, nDiscDevice, nPowerPages)


// Define your communications module here like so:
DEFINE_MODULE 'TASCAM_DVD01U_Comm_dr1_0_0' comm(vdvDiscDevice, dvDiscDevice)

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

