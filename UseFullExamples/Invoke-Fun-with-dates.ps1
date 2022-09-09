############# Fun with Dates ##################

[datetime]$d = "12/31/2022 5:00PM"
#Saturday, 31 December 2022 5:00:00 PM

"{0:d}" -f $d
#31/12/2022

"{0:D}" -f $d 
#Saturday, 31 December 2022

"{0:g}" -f $d
#31/12/2022 5:00 PM

"{0:f}" -f $d 
#Saturday, 31 December 2022 5:00 PM

"{0:u}" -f $d 
#2022-12-31 17:00:00Z

"{0:yyyy-dd-MM}" -f $d 
#2022-31-12

"{0:dd/MM/yy}" -f $d 
#31/12/22

"{0:dd/MM/yyyy}" -f $d 
#31/12/2022

"{}" -f $d 


"{0:d} {1:dd/MM/yyyy}" -f $d, $d
#31/12/2022 31/12/2022



