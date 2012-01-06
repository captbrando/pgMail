create function pgmail(text, text, text, text) returns int4 as '
set mailfrom $1
set mailto $2
set mailsubject $3
set mailmessage $4
set myHost "<ENTER YOUR MAILSERVER HERE>"
set myPort 25
set mySock [socket $myHost $myPort]
set toemailaddress_start [string first "<" $mailto]
if {$toemailaddress_start != -1} {
	set toemailaddress_finish [string first ">" $mailto]
	set toemailaddress_start [expr $toemailaddress_start + 1]
	set toemailaddress_finish [expr $toemailaddress_finish - 1]
	set toemailaddress [string range $mailto $toemailaddress_start $toemailaddress_finish]
} else {
	set toemailaddress $mailto
}
set fromemailaddress_start [string first "<" $mailfrom]
if {$fromemailaddress_start != -1} {
	set fromemailaddress_finish [string first ">" $mailfrom]
	set fromemailaddress_start [expr $fromemailaddress_start + 1]
	set fromemailaddress_finish [expr $fromemailaddress_finish - 1]
	set fromemailaddress [string range $mailfrom $fromemailaddress_start $fromemailaddress_finish]
} else {
	set fromemailaddress $mailfrom
}
fileevent $mySock writable [list svcHandler $mySock]
fconfigure $mySock -buffering none
puts $mySock "helo <ENTER YOUR DATABASESERVER HERE>"
gets $mySock name
puts $mySock "mail from: $fromemailaddress"
gets $mySock name
puts $mySock "rcpt to: $toemailaddress"
gets $mySock name
puts $mySock "data"
gets $mySock name
puts $mySock "To: $mailto"
puts $mySock "From: $mailfrom"
puts $mySock "Subject: $mailsubject"
puts $mySock ""
puts $mySock "$mailmessage"
puts $mySock "."
gets $mySock name
close $mySock
return 1'
language 'pltclu';
