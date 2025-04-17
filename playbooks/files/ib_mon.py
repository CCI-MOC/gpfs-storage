#!/usr/bin/env python3
#
# This script was shared by Matthew Kloss (IBM)
# I'm unsure of license and copyright.
# Do not share widely.
#
import os
import time
import curses
from curses import wrapper

def main(stdscr):
    # Clear out the screen and hide cursor
    stdscr.clear()
    curses.curs_set(0)

    # Print column headings
    stdscr.addstr(2, 2, "Adapter", curses.A_BOLD)
    stdscr.addstr(2, 12, "State", curses.A_BOLD)
    stdscr.addstr(2, 21, "Errors", curses.A_BOLD)
    stdscr.addstr(2, 41, "Send Rate", curses.A_BOLD)
    stdscr.addstr(2, 61, "Rcv Rate", curses.A_BOLD)


    # Create windows for the name, state, errors, send, and receive
    namewin = curses.newwin(curses.LINES - 4, 11, 3, 1)
    statewin = curses.newwin(curses.LINES - 4, 9, 3, 11)
    errorswin = curses.newwin(curses.LINES - 4, 20, 3, 20)
    sendwin = curses.newwin(curses.LINES - 4, 20, 3, 40)
    rcvwin = curses.newwin(curses.LINES - 4, 20, 3, 60)

    # Print out a nice border
    stdscr.border()
    stdscr.refresh()

    # Get the current IB adapters and initialize arrays for values
    # TODO: The rest of this code assumes 1 port (1) for all adapters, should clean that up
    ib_adapters = getadapters()
    ib_state = [None] * len(ib_adapters)
    ib_error = [0] * len(ib_adapters)
    ib_trans = [0] * len(ib_adapters)
    ib_rcv = [0] * len(ib_adapters)
    ib_time = [0] * len(ib_adapters)

    # Get the current adapter state and initial values for all active adapters
    for idx, adapter in enumerate(ib_adapters):
        namewin.addstr(idx, 2, adapter, curses.A_BOLD)
        ib_state[idx] = get_state(adapter)

        if ib_state[idx] == "ACTIVE":
            ib_time[idx] = time.time()
            ib_trans[idx] = get_transmit(adapter)
            ib_rcv[idx] = get_rcv(adapter)
            ib_error[idx] = get_error(adapter)


   # Refresh everything on screen
    namewin.refresh()
    statewin.refresh()
    errorswin.refresh()
    sendwin.refresh()
    rcvwin.refresh()

    while True:
        time.sleep(2)

        statewin.erase()
        errorswin.erase()
        sendwin.erase()
        rcvwin.erase()

        for idx, adapter in enumerate(ib_adapters):
            statewin.addstr(idx, 0, ib_state[idx])
            # We assume ports don't change state while the program is running

            if ib_state[idx] == "ACTIVE":
                # For all active adapters, get the current values
                cur_error = get_error(adapter)
                cur_time = time.time()
                cur_trans = get_transmit(adapter)
                cur_rcv = get_rcv(adapter)

                # Print out the current state of all adapters
                errorswin.addstr(idx, 2, str(cur_error - ib_error[idx]))
                sendwin.addstr(idx, 2, print_rate((cur_trans - ib_trans[idx]) / (cur_time - ib_time[idx])))
                rcvwin.addstr(idx, 2, print_rate((cur_rcv - ib_rcv[idx]) / (cur_time - ib_time[idx])))

                # Save the current values to previous for the next run
                ib_trans[idx] = cur_trans
                ib_rcv[idx] = cur_rcv
                ib_time[idx] = cur_time

        # Refresh everything to update the values on screen
        sendwin.refresh()
        rcvwin.refresh()
        statewin.refresh()
        errorswin.refresh()

def print_rate(rate):
    # We're assuming MB/sec.  Rates are output in 32 bit/4 byte increments
    return ("{} MB/s".format(round(rate / 262144, 3)))

# Functions to get values for the adapter -- can clean these up for error handling at some point
def get_transmit(adapter):
    with open("/sys/class/infiniband/{}/ports/1/counters/port_xmit_data".format(adapter)) as file:
        data = file.readline()

    return(int(data))

def get_rcv(adapter):
    with open("/sys/class/infiniband/{}/ports/1/counters/port_rcv_data".format(adapter)) as file:
        data = file.readline()

    return(int(data))

def get_error(adapter):
    with open("/sys/class/infiniband/{}/ports/1/counters/port_rcv_errors".format(adapter)) as file:
        errors = int(file.readline())
    with open("/sys/class/infiniband/{}/ports/1/counters/port_xmit_discards".format(adapter)) as file:
        errors = errors + int(file.readline())

    return(errors)

def get_state(adapter):
    with open("/sys/class/infiniband/{}/ports/1/state".format(adapter)) as file:
        data = file.readline()

    return data.split(":")[1].strip()

def getadapters():
    # list all the adapters - TODO: better error handling
    adapters = os.listdir("/sys/class/infiniband")
    adapters.sort()
    return adapters

if __name__ == "__main__":
    wrapper(main)
