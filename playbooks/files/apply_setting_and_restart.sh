set -e

numberOfClients=3

echo "-- Setting verbsPorts=$1 --"
mmchconfig verbsPorts=$1
mmshutdown -a
mmstartup -a

# The output of the following command will be the status of each
# the nodes in gpfs.
# Once we get 3 lines of "active" that means the cluster has
# restarted and is ready.

echo "-- Waiting for Cluster to become Active --"
until mmgetstate -a | grep "gpfs-client" | awk -F " " '{print $3}' | grep "active" | wc -l | grep -q $numberOfClients;
do
    echo ".";
    sleep 5
done

echo "-- Mounting filesystem --"
mmmount gpfs -a

echo "-- Ready --"
mmdiag --config | grep !