Cloud Infrastructure Engineer was asked...
14 March 2021

Round 1: General questions about your backgRound 
Round 2: Role based interview. - what is the difference between virtualization and containerization - how would you design infrastructure for not a global company Three Virtual On-site in 45 mins 
Round 3: Client-facing - your experience on how you resolved conflict with someone in your work place. - an example of how the team was working on something and you improved the process - how will you handle conflict with the team - an example of how you took ownership of something 
Round 4: Role based interview - how would you design infrastructure of the shopping cart of an e-commerce website - there is tv channel show which airs at prime time and there are 4million people who watch. how would you design architecture of the mobile app 
Round 5: coding interview - find duplicate values in an array - calculate complexity of code - improve code complexity






Google Interview Questions: —> 24th Jan 2022 9.30 AM

https://www.edureka.co/blog/interview-questions/google-interview-questions/#HowtoprepareforTechnicalQuestions


HTTP/HTTPS/Web Service
https://www.youtube.com/watch?v=JjkIUN_vUvI

* http https ports —> 80 443
* What Are RESTful Web Services? How do they work
* Most common http methods
    * GET PUT POST PATCH DELETE
* Email Protocol & Port
    * SMTP —> 25 (or 26)
    * IMAP 
        * TLS —> 993
        * Unencrypted —> 143
    * POP3
        * Unencrypted —> 110
        * TLS —> 995
* Most common HTTP status code
    * 503 Service Unavailable
    * HTTP 404 Not Found response status code
    * HTTP 200 OK success status response code



Database:
* https://www.geeksforgeeks.org/difference-between-ddl-and-dml-in-dbms/
* DDL & DML



System Admin
https://www.youtube.com/watch?v=YAZ6MlOYO1E
https://www.youtube.com/watch?v=mSO37hFadvE



OS 
https://www.youtube.com/watch?v=b18X4uOKjHs

* what signal does kill send —> SIGTERM
* Where are the bootstrap logs present
  - /var/log/boot. log:
* how to check inode usage in linux —> df -i
    * ls -li
    * stat ./html
* how to check disk io status in linux
    * iotop
    * iostat
* what is signal sent to interrupt process
    * SIGINT
* How To Check CPU Usage
    * top
* What is th eDNS Port —> 53
* Which layer does switch and router operate
    * Layer 3, the network layer,
* DNS & DHCP (port) how they work
    * https://community.fs.com/blog/dhcp-and-dns-difference.html
* Command to check open connections
    * Netstat -ntulp 
    * tail -10 /etc/services




What is Time complexity of n:
https://www.hackerearth.com/practice/basic-programming/complexity-analysis/time-and-space-complexity/tutorial/
https://www.youtube.com/watch?v=KXAbAa1mieU
https://google.github.io/eng-practices/review/reviewer/

temp=n
sum=0
While (n > 0){
r = n%10
sum = (sum * 10) + r
n = r/10
}


