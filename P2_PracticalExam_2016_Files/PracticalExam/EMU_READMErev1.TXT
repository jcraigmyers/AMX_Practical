


The testing emulator is meant to provide a means to test and troubleshoot the AMX Programmer Practical exam in the absence of controlled equipment.  The program connects to the NetLinx master and responds as if it were a device connected to the controller.

You will still need a NetLinx master and a G4 or G5 touchpanel.  The version of master is unimportant, although to fully test the practical you will need at least Duet-capable firmware.  Recommended NetLinx masters are therefore any NI- or NX-series integrated controller or an NXC-ME260/64.  DVX or DGX switchers meet this requirement.


Using the AMX Programmer Practical testing emulator:


You will need a relatively current JVM on the PC you intend to run the emulator.  Go to www.java.com if you do not have the Java Runtime Environment.  This program was written against J2SE v1.6.0_07.  Older versions may work, but nothing older than 1.5.  It is *not* required that Java run inside a browser session.  Only the Java Runtime Environment is necessary.

Double-click the jar file to get started.

When the application opens, you will be presented with a launcher for the individual connected devices specified in the test.

First, type the IP address of the NetLinx master you will load the program to.  This will populate a similar field in all the device emulators you launch.  This will make it convenient to connect.

Pressing Connect on the individual device emulators will cause the that emulator to attempt a connection with the NetLinx master specified by the IP address.


NOTE:  Due to a limitation of the process I used to connect, you will need to edit the DEFINE_DEVICE section of your Programmer Practical Exam.  The devices are configurable, but the defaults are as follows:

The SwitchBack 12x4 matrix switcher 	--- 8001:1:0

The LightThrower 3000 projector		--- 8002:1:0

The DiscoTech DVD player		--- 8003:1:0

The DirecTV satellite receiver		--- 8005:1:0


The lighting emulator does not attempt to connect as it is a server application and is waiting for the NetLinx master to connect on TCP port 24.
Note:  In your NetLinx code, you need to use the IP address of the PC running the emulator instead of 192.168.1.112 (as required by the test).


If the connection has been successful, the connect button will turn yellow.  The commands and strings to and from the NetLinx master will appear in the console window.  The device should visibly react to the correct strings.



Notes on the emulator's behavior:

Each of the devices will appear as two windows.  Selecting one brings the other to the front.  Closing one closes the other.

Closing the Emu Launcher closes all the device emulators.  Pressing 'Bring All to Front' on the Emu Launcher is a handy way to call the devices to attention without clicking on a dozen Start Menu items.

The device's behavior has been coded to Device Specification 2.1.  Certain elements of the protocols have been altered in a way that is not backwards compatible with previous specifications.  Emulators for the previous versions are available upon request.



Known issues:

***With NX-series masters, turn off Authentication On Server Ports***
Current NX-series firmware at the time of this writing has an uneasy relationship with the WDM port, which the emulator uses for device communication.  This port, intended to support G3WebControl panels, pre-dates many efforts to make the controllers more secure on the network.  This port does not support authentication.  As a result, when Authentication On Server Ports is checked the WDM port is closed.  It cannot comply with the authentication requirement without changing the protocol.  For the emulator to function, this option must be deselected.

The lighting section of the emulator attempts to open a TCP Server Socket on port 24 of the host PC.  It does not attempt to alter the network firewall settings of the host PC.  If a network firewall is on, either an exception must be made for TCP port 24, or the firewall needs to be turned off temporarily.  Windows Firewall may also block an application's access to the network even if the specific protocol and port are allowed.  Shutting off the firewall is the most expedient way to allow the lighting emulator to function. 

The lighting section will not display any characters received until a line ending is encountered.  This is natural behavior for the PrintStream upon which it is based.  Other solutions will be explored.

There are some bizarre resize/redraw behaviors.  These are cosmetic and will be dealt with in later releases.

Occasionally, the command window will be blank, even though commands have been received.  This is a threading/concurrency issue between the application thread and Swing.  Sending another command will cause the display to show the entire history.

If an invalid IP address is provided that does not immediately get denied, the device emulators may have trouble letting go and accepting the new address.  Closing the emulator and starting over is the workaround.

Only IPv4 addresses are recognized in the IP Address field.  Attempting to use a DNS name or IPv6 address will not result in a successful connection.



Please submit any questions/comments/concerns to nick.czapla@harman.com