# victoria

## Quick Setup

* Clone this repository
```bash
git clone git@github.com:mesos-magellan/victoria
cd victoria
```
* Ensure that miguel, faleiro, and enrique repositories have been cloned
at the same directory level as victoria, i.e., the following should be true
```bash
$ pwd
/somepath/victoria
$ ls ../
miguel   faleiro   victoria   enrique
```
* Install [Vagrant](https://www.vagrantup.com/downloads.html)
* Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* Install the vagrant-vbguest plugin: `vagrant plugin install vagrant-vbguest`

* Start bringing up victoria: `vagrant up`

## Usage

### Machines

* master (10.144.144.10)
   * Has the mesos-master service 
* scheduler (10.144.144.11)
   * Runs faleiro
   * Has zookeepercli installed for convenience when debugging faleiro
   * Has miguel installed for faleiro usage (usable with `miguel --help`)
* agent{i} (10.144.144.{100+i})
   * Number of agents is configurable in Vagrantfile
   * There are 2 agents by default (agent001 and agent002 at 10.144.144.101 and 10.144.144.102 respectively)
   * Runs mesos-slave; configured to connect the mesos-master running on the master machine


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

Find the web UI master at [10.144.144.10:5050](http://10.144.144.10:5050)
