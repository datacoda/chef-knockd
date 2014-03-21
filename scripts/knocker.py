#!/usr/bin/env python
# knocker.py

"""
Py-port knocking project (knocker).
Send TCP (SYN) packets on a set of specified ports.
"""

import socket
import sys
import os
import getopt
import time
from errno import EWOULDBLOCK

__pname__   = 'Py-port knock client'
__ver__     = 'v0.2'
__state__   = 'beta'
__date__    = '2006-11-25'
__author__  = 'billiejoex (ITA)'
__web__     = 'http://billiejoex.altervista.org'
__mail__    = 'billiejoex@gmail.com'
__license__ = 'see LICENSE.TXT'

helper = """\n\
NAME
  %s %s

DESCRIPTION
  Send TCP (SYN) packets on a set of specified ports.

SYNTAX
  %s [opt] <remote_host> <port|port,port>

OPTIONS
  -i, --interactive   Run in interactive mode.

EXAMPLES
  %s 10.0.0.1 2000
  %s 10.0.0.1 2000,2100,2200\
""" %(__pname__,
      __ver__,
      os.path.split(sys.argv[0])[1],
      os.path.split(sys.argv[0])[1],
      os.path.split(sys.argv[0])[1])

def knock(host, port):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.setblocking(0)
    try:
        sock.connect((host, port))
    except socket.error:
        print "Knocked on %s:%s" %(host,port)
        pass

def run():
    ports = []
    interactive = 0
    try:
        opts, args = getopt.getopt(sys.argv[1:], "i", ['interactive'])
        for o, a in opts:
            if o in ['-i', '--interactive']:
                interactive = 1
    except:
        print helper
        os._exit(0)


    # TO DO: use cmd.Cmd() for interactive command session
    # because command history works on Windows OSes only
    if interactive:
        print "Type host and sequence (example: 192.168.20.55 2000,2001,2002):"
        try:
            while 1:
                ports = []
                i = raw_input('>>> ')
                if len(i.strip().split(' ')) != 2:
                    print "syntax: <host> <seq1,seq2,...>"
                    continue
                host = i.split(' ')[0]
                seq = i.split(' ')[1]
                for port in seq.split(','):
                    ports.append(port)
                try:
                    host = socket.gethostbyname(host)
                except socket.error:
                    print "unknown address."
                    continue
                for i in ports:
                    try:
                        knock(host,int(i))
                    except ValueError:
                        print "integer required."
                    time.sleep(0.2)
        except KeyboardInterrupt:
            os._exit(0)
    else:
        if len(args) < 2:
            print helper
            os._exit(0)
        if len(args) > 2:
            print helper
            os._exit(0)
        for port in args[1].split(','):
            ports.append(port)
        try:
            host = socket.gethostbyname(args[0])
        except socket.error:
            print "unknown address."
            os._exit(0)
        for i in ports:
            knock(host,int(i))
            time.sleep(0.2)

if __name__ == '__main__':
    run()
