# Set up and start the scheduler
cd faleiro
# We only run build on scheduler001 as the environment is shared
#  FIXME this will need to be changed if we deploy to Linode
#  as we won't be relying on synced_folders
if [[ `hostname` == "scheduler001"  ]]; then
    ./build.sh
fi
./install.sh
# TODO uncomment lines below when scheduler supports clustering
#  if we do this now; it will be chaos as three independent schedulers
#  will be attempting to use the "same" zookeeper (cluster in consensus)
# supervisord
# supervisorctl reload
cd ..
