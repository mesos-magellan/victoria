# Set up and start the scheduler
cd faleiro
# We only run build on scheduler001 as the environment is shared
#  FIXME this will need to be changed if we deploy to Linode
#  as we won't be relying on synced_folders
if [[ `hostname` == "scheduler001"  ]]; then
    ./build.sh
fi
./install.sh
supervisord
supervisorctl reload
cd ..
