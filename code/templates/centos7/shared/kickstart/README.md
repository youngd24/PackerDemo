# iManage SecOps Packer Build

## Kickstart Configuration

This directory contains the shared Kickstart configurations for all Packer builds.

## Contents

`base-template.cfg`: the base, common, shared, derived Kickstart configuration template that `kickflip` reads in from. Use this for all other builds and change this if you need the defauls all over changed.

`kickflip`: the Kickflip script

`ks.cfg`: the generated Kickstart configuration that `kickflip` spits out.

## Kickflip

The builds use a Kickstart file that's shared with the other builds, namely the vSphere one, the problem is the vSphere one requires a static IP to work (due to no DHCP in our clouds) but VirtualBox works fine DHCP.

In order to get around this a script named `kickflip`, located in the `shared/kickstart` directory, is used to read in a base Kickstart template and adjust as needed for each Packer build target.

The basic idea is this needs to be changed per build target:

```
# vSphere boot config
# network --onboot yes --device ens192 --noipv6 --hostname=secops-packer-01 --bootproto=static --ip=10.106.6.70 --netmask=255.255.255.0 --gateway=10.106.6.1 --nameserver=10.106.6.16 --nameserver=10.106.6.17

# VirtualBox boot config
# network --bootproto=dhcp --onboot yes --noipv6
```

The `kickflip` script is called by the Makefile and "flips" the config from one target to another. It reads in a base template, looks for the string `%%NETWORK%%` and replaces it with the one needed for the desired target.

The main point here is that if you want to modify the base Kickstart configuration, you'll need to modify the file `base-template.cfg` in `shared/kickstart`. If you need a new build target, you'll have to modify the `kickflip` script and account for what it needs to boot.



*Note: as with all documentation these are provided best effort and are immediately out of date so take things here with a bucket of grains of salt. The code itself is the defacto "source of truth" for all things.*