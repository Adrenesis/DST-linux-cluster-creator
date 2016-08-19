# DST-linux-cluster-creator
Allow you to create a cluster for dont starve together very fast and very easily!

# Glossary
- ***Server***: Don't starve server is a binary that is running.
- ***Cluster***: A cluster is a save of Don't starve together with all its settings. A server can run several clusters.
- ***Shard***: A Shard is a part of a save of Don't Starve together. It is usualy used to start a server for the overworld AND the caves.
- ***`/.klei/DoNotStarveTogether/` directory***: A directory that you can find usualy in `/home/yourusername/`. You can find in it `Cluster_` folders, where clusters are stored. This project uses it as its **working directory**.
- ***Screen package***: A package that you can easily install on any linux distrib that support the management of multiple terminals. We use it here to start multiple Don't Starve Together shards or clusters. It allows users to use the console of Don't Starve Together servers by using `screen -r nameofyourscreen`.

# How to use it:
1. Open this script with your favorite text editor and find this line (around line 370): `cd ~/.klei/DoNotStarveTogether/ # << line you have to edit to be in the right folder`

2. Edit it to find your `/.klei/DoNotStarveTogether/` directory.

3. Then launch it and you will be prompted to create a cluster. 

# Miscelaneous:
On the first screen you will be prompted to ***create*** or ***edit*** a cluster. ***Edition*** is still a work in progress and will be available with the "screen" package, in 1.0 version.

This script still ***does not*** support ***iptables*** but it's a feature that will come later.

# Changelog:
Version | Availability | Content
------------ | ------------- | -------------
0.0.0 | Stable | The very first version, permitting to create a cluster

# Dev environment
## Versionning
Please, use the branch for the version of your code.

e.G. You have an issue fixed to the milestone "Version 0.1": you have to code on the branch "0.1".

It will be easier to stabilize versions and put into production.
