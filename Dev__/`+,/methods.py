import os
import re
import nmap
#checks if the IP is valid or not
def isValid(targ):
    return re.compile("^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$").match(targ)

#check if a host is Alive
def isAlive(targ):
    return True if os.system("ping -c 1 " + targ) is 0 else False

def nmapPortScan(targ):
    nm = nmap.PortScanner()
    return nm.scan(targ, arguments='-n -sP -PE')