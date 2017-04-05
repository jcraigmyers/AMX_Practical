PROGRAM_NAME='Apple TV Control'
(***********************************************************)
(*  FILE CREATED ON: 07/22/2016  AT: 13:25:27              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 07/22/2016  AT: 13:50:29        *)
(***********************************************************)

DEFINE_EVENT

data_event[dvAppleTV]
{
    online:
    {
	send_command dvAppleTV,'SET MODE IR';
	send_command dvAppleTV,'CARON';
    }
}

button_event[dvTP_AppleTV,0]
{
    push:
    {
	to[dvAppleTV,button.input.channel];
    }
}


