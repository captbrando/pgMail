create function pgmail(text, text, text, text, text default '') returns int4 as '
set mailfrom $1
set mailto $2
set mailsubject $3
set mailmessage $4
set mailmessage_html $5
if {$mailmessage ne "" && $mailmessage_html ne ""} {
	set multipart true
} else {
	set multipart false
}
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
fconfigure $mySock -buffering line
puts $mySock "HELO <ENTER YOUR DATABASESERVER HERE>"
gets $mySock name
puts $mySock "MAIL FROM: $fromemailaddress"
gets $mySock name
puts $mySock "RCPT TO: $toemailaddress"
gets $mySock name
puts $mySock "DATA"
gets $mySock name
puts $mySock "Date: [clock format [clock seconds] -format {%a, %d %b %Y %H:%M:%S +0000} -gmt true]"
puts $mySock "From: $mailfrom"
puts $mySock "To: $mailto"
puts $mySock "Subject: $mailsubject"
puts $mySock "MIME-Version: 1.0"
if {$multipart} {
	puts $mySock {Content-type: multipart/mixed; boundary="just_a_simple_boundary"}
}
if {$mailmessage ne ""} {
	if {$multipart} {puts $mySock "--just_a_simple_boundary"}
	puts $mySock "Content-type: text/plain; charset=UTF-8"
	puts $mySock "Content-Transfer-Encoding: 8bit"
	puts $mySock ""
	puts $mySock "$mailmessage"
}
if {$mailmessage_html ne ""} {
	if {$multipart} {puts $mySock "--just_a_simple_boundary"}
	puts $mySock "Content-type: text/html; charset=UTF-8"
	puts $mySock "Content-Transfer-Encoding: 8bit"
	puts $mySock ""
	puts $mySock "$mailmessage_html"
}
if {$multipart} {puts $mySock "--just_a_simple_boundary--"}
puts $mySock ""
puts $mySock "."
gets $mySock name
puts $mySock "QUIT"
gets $mySock name
close $mySock
return 1'
language 'pltclu';
