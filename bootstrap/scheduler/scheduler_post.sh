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

if [[ $(ps aux | grep frontail | grep -v grep) ]]; then
  echo "frontail already seems to be running."
else
  ## Start frontail daemon to view logs on 0.0.0.0:9050
  sudo frontail -p 9050 -n 500 -d /var/log/faleiro/stderr.log
fi
