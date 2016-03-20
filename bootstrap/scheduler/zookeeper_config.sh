#!/usr/bin/env bash

set -e
# set -x


ZOOKEEPER_CONF_DIR="/etc/zookeeper/conf"


#################
# Parse Options #
#################

# Find the right getopt
GETOPT=`which getopt`
if [[ $OSTYPE == *"darwin"* ]]; then
    if brew --prefix gnu-getopt;  then
        GETOPT="$(brew --prefix gnu-getopt)/bin/getopt"
    else
        echo '`brew install gnu-getopt` before trying again'
        exit 1
    fi
fi

# Read the options
OPTS=`${GETOPT} -o n:r:i: --long num_scheds:,ip_range_start:,num: -n 'py.sh' -- "$@"`

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

# Extract options and their arguments into variables.
while true ; do
    case "$1" in
        -n | --num_scheds) ARG_N="$2" ; shift 2 ;;
        -r | --ip_range_start) ARG_R="$2" ; shift 2 ;;
        -i | --num) ARG_I="$2" ; shift 2 ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

echo ARG_I=$ARG_I
echo ARG_R=$ARG_R
echo ARG_N=$ARG_N


#################
# Write zoo.cfg #
#################

echo '
import click


ZOO_CONF = """
# http://hadoop.apache.org/zookeeper/docs/current/zookeeperAdmin.html

# The number of milliseconds of each tick
tickTime=2000
# The number of ticks that the initial
# synchronization phase can take
initLimit=10
# The number of ticks that can pass between
# sending a request and getting an acknowledgement
syncLimit=5
# the directory where the snapshot is stored.
dataDir=/var/lib/zookeeper
# Place the dataLogDir to a separate physical disc for better performance
# dataLogDir=/disk2/zookeeper

# the port at which the clients will connect
clientPort=2181

# specify all zookeeper servers
# The fist port is used by followers to connect to the leader
# The second one is used for leader election
#server.1=zookeeper1:2888:3888
#server.2=zookeeper2:2888:3888
#server.3=zookeeper3:2888:3888
{}

# To avoid seeks ZooKeeper allocates space in the transaction log file in
# blocks of preAllocSize kilobytes. The default block size is 64M. One reason
# for changing the size of the blocks is to reduce the block size if snapshots
# are taken more often. (Also, see snapCount).
#preAllocSize=65536

# Clients can submit requests faster than ZooKeeper can process them,
# especially if there are a lot of clients. To prevent ZooKeeper from running
# out of memory due to queued requests, ZooKeeper will throttle clients so that
# there is no more than globalOutstandingLimit outstanding requests in the
# system. The default limit is 1,000.ZooKeeper logs transactions to a
# transaction log. After snapCount transactions are written to a log file a
# snapshot is started and a new transaction log file is started. The default
# snapCount is 10,000.
#snapCount=1000

# If this option is defined, requests will be will logged to a trace file named
# traceFile.year.month.day.
#traceFile=

# Leader accepts client connections. Default value is \"yes\". The leader machine
# coordinates updates. For higher update throughput at thes slight expense of
# read throughput the leader can be configured to not accept clients and focus
# on coordination.
#leaderServes=yes
"""


@click.command()
@click.option("-n", "--num-scheds", required=True, default=3, type=click.INT)
@click.option("-r", "--ip-range-start", required=True,
              default=20, type=click.INT)
def main(num_scheds, ip_range_start):
    line = "server.{num}=10.144.144.{ip_end}:2888:3888"
    print(ZOO_CONF.format(
        "\n".join(line.format(num=i, ip_end=i+ip_range_start)
                  for i in range(1, 1+num_scheds))
    ))


main()
' > get_zk_conf.py
python get_zk_conf.py -n $ARG_N -r $ARG_R | tee #"${ZOOKEEPER_CONF_DIR}/zoo.cfg"
rm get_zk_conf.py


##############
# Write myid #
##############

echo "$ARG_I" | tee #"${ZOOKEEPER_CONF_DIR}/myid"
