# Set up and start the scheduler
cd faleiro
./install.sh
supervisord
supervisorctl reload
cd ..
