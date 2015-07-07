== start_server.sh ==

export PYTHONPATH=.
export DJANGO_SETTINGS_MODULE=my_project.settings
daemonize  -c /django_projects/my_project  /django_projects/my_project/server/my_server.py

#
# Note here there is a need to setup PYTHONPATH and django project setting, since we have
# customized modules to use in the server.
# After setting up the path, when use daemonize then you need to specify
# the working directory with -c.
#

== stop_server.sh ==

output=`ps ax|grep my_server.py | grep -v grep`
echo killing process my_server.py
if [[ -z $output ]]; then
    echo 'this process doe not exist'
    exit 0
fi

set -- $output
pid=$1

echo killing proces $pid
kill -9 $pid
#sleep 2
#kill -9 $pid >/dev/null 2>&1


#
# Reference:
# [1]
# http://stackoverflow.com/questions/6437602/shell-script-to-get-the-process-id-on-linux
# The backticks allow you to capture the output of a comand in a shell variable.
# The set -- parses the ps output into words, and $2 is the second word on the
# line which happens to be the pid. Then you send a TERM signal, wait a couple
# of seconds for ruby to to shut itself down, then kill it mercilessly if it
# still exists, but throw away any output because most of the time kill -9 will
# complain that the process is already dead.
#
# [2]
# http://www.cyberciti.biz/tips/grepping-ps-output-without-getting-grep.html
# when ps aux | grep something, to avoid getting the line of grep, do either of
# 1) ps aux | grep something | grep -v grep
# 2) ps aux | grep [s]omething
# 3) ps aux | grep '[s]omething'
# for 2) and 3), it's actually a regular expression, [s] matches to s.
#
