# victoria

## Quick Setup

* Install Vagrant
* Install VirtualBox
* `vagrant up`

## Usage

### Machines

* master (10.144.144.10)
* agent001 (10.144.144.11)
* scheduler (10.144.144.12)

```bash
# Bring up all machines
vagrant up
# Bring up specific ones with
vagrant up <name>
# SSH into any of the machines with:
vagrant ssh <name>
# Re-provision any machine with (don't provide a name to re-provision all)
vagrant provision <name>
```

### Mesos

Find the master at [10.144.144.10:5050](http://10.144.144.10:5050)
