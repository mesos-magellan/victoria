# Set up and start the scheduler
cd faleiro
./install.sh
# TODO uncomment lines below when scheduler supports clustering
#  if we do this now; it will be chaos as three independent schedulers
#  will be attempting to use the "same" zookeeper (cluster in consensus)
# supervisord
# supervisorctl reload
cd ..
