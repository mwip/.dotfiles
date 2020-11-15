#!/bin/sh

# TODO make every variable a flag
LOCK_CMD="betterlockscreen -l blur"
LOCKFILE=/tmp/$(whoami)/.lockctl.lock
PIPEFILE=/tmp/$(whoami)/.lockctl.pipe
LOCKICON=$HOME/.local/share/lockctl/lock.svg
UNLOCKICON=$HOME/.local/share/lockctl/unlock.svg

activate_lock() {
    if [ ! -f $LOCKFILE ]; then
	[ $VERBOSE ] && echo "Activating lock"
	
	# kill remaining yad instance
	[ -n "$YADPID" ] && kill $YADPID
	touch $LOCKFILE
	# launch yad and save PID to $YADPIDFILE
	yad --notification --command="lockctl.sh -t" --image=$LOCKICON --no-middle --title="lockctl" & 
	export YADPID=$!
    else
	[ $VERBOSE ] && echo "Already locked."
    fi
}

deactivate_lock () {
    if [ -f $LOCKFILE ]; then
	[ $VERBOSE ] && echo "Deactivating lock"
	
	# kill remaining yad instance
	[ -n "$YADPID" ] && kill $YADPID  
	rm -f $LOCKFILE
	# launch yad and save PID to $YADPIDFILE
	yad --notification --command="lockctl.sh -t" --image=$UNLOCKICON --no-middle --title="lockctl" &
	export YADPID=$!
    else
	[ $VERBOSE ] && echo "Already deactivated."
    fi
}

get_status() {
    [ -f $LOCKFILE ] && echo "locked" || echo "unlocked"
}

handle_temp_files() {
    if [ $1 == "-clean" ]; then
	rm -f $LOCKFILE
	rm -f $PIPEFILE
    fi

    if [ $1 == "-init" ]; then
	mkdir -p $(dirname $PIPEFILE $YADPIDFILE $LOCKFILE)
	mkfifo $PIPEFILE
    fi
    
}

help() {
    # TODO complete help message
    echo "lockctl.sh -- a way to control your screenlocker"
    echo ""
    echo "USAGE:"
    echo "  lockctl.sh [options]"
    echo ""
    echo "OPTIONS:"
    echo "  -a   --activate      Activate the lock."
    echo "  -c   --command       Send a command to the daemon."
    echo "  -d   --deactivate    Deactivate the lock."
    echo "  -D   --daemon        Start the lockctl.sh daemon."
    echo "  -f   --lockfile      Set the location of the lockfile. Default is /tmp/$(whoami)/.lockctl.lock"
    echo "  -h   --help          Display this help message."
    echo "  -l   --lock          Lock the screen if the daemon is set to lock."
    echo "  -L   --lock-command  Change the lock-command. By default it is 'betterlockscreen -l blur.'"
    echo "  -s   --status        Show the current status of lockctl.sh."
    echo "  -t   --toggle        Toggle the status of lockctl between locked and unlocked."
    echo "  -v   --verbose       Show more text output. Only useful in combination with -D."
    echo ""
    # echo "DETAILS:"
    # TODO Commands; see parse_pipe()
}

parse_pipe() {
    [ $VERBOSE ] && echo $1
    [ "$1" == "activate" ] && activate_lock
    [ "$1" == "deactivate" ] && deactivate_lock
    [ "$1" == "status" ] && get_status
    [ "$1" == "toggle" ] && toggle_activated
}

run_daemon() {
    # send quit signal to exiting daemon
    send_to_pipe "quit" 

    # set up trap in case of exit
    [ $VERBOSE ] && echo "Setting traps."
    trap "handle_tmp_files -clean" EXIT TERM KILL INT
    trap "[ -n \"$YADPID\" ] && kill $YADPID" EXIT TERM KILL INT

    [ $VERBOSE ] && echo "Starting lockctl.sh daemon"
    # remove the pipe if it exists
    handle_temp_files -clean
    # set up TMP-Files
    [ $VERBOSE ] && echo "Initializing tmpfiles"
    handle_temp_files -init

    activate_lock
    
    # enter endless loop for daemon
    while true
    do
	if read LINE <$PIPEFILE; then
            if [ "$LINE" == 'quit' ]; then
		break
            fi
            parse_pipe $LINE
	fi
    done
    # clean up temp files
    [ $VERBOSE ] && echo "Cleaning temporary files"
    handle_temp_files -clean
    kill $YADPID

    [ $VERBOSE ] && echo "Shutting down lockctl daemon. Bye..."
    exit 0
}

send_to_pipe() {
    ls $PIPEFILE 2>/dev/null &>1 && 
	echo $1 > $PIPEFILE
}

toggle_activated() {
    if [ -f $LOCKFILE ]; then
	deactivate_lock
    else
	activate_lock
    fi
    exit 0
}

trigger_lock() {
    [ "$(get_status)" == "locked" ] && exec $LOCK_CMD
}

# parse input flags
# adapted from https://stackoverflow.com/a/33826763
# TODO May fail with duplicate arguments etc., perhaps move to getops?

while [[ "$#" -gt 0 ]]; do
    key="$1"
    case $key in
	# FIXME
	-a|--activate)
	    ACTIVATE=true; shift;;
	-c|--command)
	    COMMAND=$2; shift; shift;;
	-d|--deactivate)
	    DEACTIVATE=true; shift;;
	-D|--daemon)
	    START_DAEMON=true; shift;;
	-f|--lockfile)
	    LOCKFILE=$2; shift; shift;;
	-h|--help)
	    help
	    exit 0;;
	-l|--lock)
	    LOCK=true; shift;;
	-L|--lock-command)
	    LOCK_CMD=$2; shift; shift;;
	-q|--quit)
	    QUIT=true; shift;;
	-s|--status)
	    GET_STATUS=true; shift;;
	-t|--toggle)
	    TOGGLE=true; shift;;
	-v|--verbose)
	    VERBOSE=true; shift;;
	*)
	    echo "Unknown option $key. See $0 -h for help."
	    exit 1
	    ;;
    esac
done

[ $QUIT ] && send_to_pipe "quit" && exit 0
[ $LOCK ] && trigger_lock && exit 0
[ $TOGGLE ] && send_to_pipe "toggle" && exit 0
[ $ACTIVATE ] && send_to_pipe "activate" && exit 0
[ $DEACTIVATE ] && send_to_pipe "deactivate" && exit 0
[ $GET_STATUS ] && get_status && exit 0
[ -n "$COMMAND" ] && send_to_pipe $COMMAND && exit 0
[ $START_DAEMON ] && run_daemon

