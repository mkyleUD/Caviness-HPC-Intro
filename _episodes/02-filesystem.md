---
title: "Filesystems of Caviness"
teaching: 30
exercises: 15
questions:
- "What are the available filesystems on Caviness?"
- "What are the different filesystems used for?"
- "How do you monitor your storage usage?"
objectives:
- "Understand where you should store your files."
keypoints:
- "Each user has 20GB of space in their home directories.  "
- "Each workgroup has at least 1000GB of shared space in their work directory."
- "Lustre filesystem storage is a community share resource and has 210TB ofr usable space."
- "Source code and executables aren't permitted to be run or stored on the Lustre filesystem."
---

There are three diffeent filesystems on the {{ site.host_name }} cluster. They are the parmanent,
high performance and local filesytems. Each filesystem has different amounts of storage variable 
to users. There is also differences in how data is backed up on the different filesystems and with 
the types of data that can be stored on them. With this in mind we will go into the  details 
of how and when you should use each of these different filesystems.

## Permanent filesystem

The permanent filesystem uses 3TB enterprise class SATA drives in a triple-parity RAID 
configuration for high reliability and availability. The filesystem is accessible to the head 
node via 10 Gbit/s Ethernet and to the compute nodes via 1 Gbit/s Ethernet. 

### Home storage
Each user has 20 GB of disk storage reserved for personal use on the home file system. Users'
home directories are in `/home` (e.g., {{ site.host_homedir }}), and the directory name is put in the environment
variable '$HOME'  at login. The permanent file system is configured to allow nearly instantaneous,
consistent snapshots. The snapshot contains the original version of the file system, and the live 
file system contains any changes made since the snapshot was taken. In addition, all your files are 
regularly replicated at UD's off-campus disaster recovery site. You can use read-only snapshots to 
revert a previous version, or request to have your files restored from the disaster recovery site.

You can check to see the size and usage of your home directory with the command 
```
{{ site.host_prompt }} df -h $HOME
```
{: .language-bash}

```
Filesystem                          Size  Used Avail Use% Mounted on
r01nfs0-10Gb:/fs/r01nfs0/home/1200   20G  1.0M   20G   1% /home/1200
```
{: .output}


### Workgroup storage
Each research group has at least 1000 GB of shared group (workgroup) storage in the `/work` directory
identified by the `«investing_entity»` (e.g., /work/it_css) and is referred to as your workgroup 
directory. This is used for input files, supporting data files, work files, and output files, source code
and executables that need to be shared with your research group. Just as your home directory, read-only 
snapshots of workgroup's files are made several times for the past week. In addition, the filesystem is 
replicated on UD's off-campus disaster recovery site. Snapshots are user-accessible, and older files may be 
retrieved by special request.

You can check the size and usage of your workgroup directory by using the workgroup command to spawn a new 
workgroup shell, which sets the environment variable `$WORKDIR`
> ## Join Your Workgroup First
> The `$WORKDIR` variable is only added to your environment once you have joined your workgroup.
> If you do not join the below example will not work  correctly.
>
{: .callout}

```
{{ site.host_workgroup_prompt }} df -h $WORKDIR
```
{: .language-bash}

```
Filesystem                            Size  Used Avail Use% Mounted on
r01nfs0-10Gb:/fs/r01nfs0/work/it_css  1.0T  321G  704G  32% /work/it_css
```
{: .output}

## High-performance filesystem
User storage is available on a high-performance Lustre-based filesystem having 210 TB of usable space. 
This is used for temporary input files, supporting data files, work files, and output files associated 
with computational tasks run on the cluster. The filesystem is accessible to all of the processor cores 
via Omni-path Infiniband. 

### Lustre storage
The Lustre filesystem is not backed up nor are their snapshots to recover deleted files. However, it 
is a robust RAID-6 system. Thus, the filesystem can survive a concurrent disk failure of two 
independent hard drives and still rebuild its contents automatically. All users have access 
to the public scratch directory (lustre/scratch). They can also create their own directories under 
the `/lustre/scratch` directory. It should be noted that IT-RCI staff may run cleanup procedures 
as needed to purge aged files or directories in `/lustre/scratch` if old files are degrading 
system performance.  

> ## Warning About Executables
> Source code and executables must be stored in and executed from Home ('$HOME') or Workgroup 
> ('$WORKDIR') storage. No executables are permitted to run from the Lustre filesystem. 
>
{: .callout}

Remember the Lustre filesystem is temporary disk storage. Your workflow should start by copying 
needed data files to the high performance Lustre filesystem, `/lustre/scratch`, and finish 
by copying results back to your private `$HOME` or shared `$WORKDIR` directory. 
Please clean up (delete) all of the remaining files in `/lustre/scratch` that no longer needed. 
If you do not clean up properly, then IT staff will request all users to clean up /lustre/scratch, 
but may need to enable an automatic cleanup procedure to avoid critical situations in the future. 

To check Lustre's usage user the following example.
```
{{ site.host_workgroup_prompt }} df -f /lustre/scratch
```
{: .language-bash}
```
Filesystem                                  Size  Used Avail Use% Mounted on
10.65.32.18@o2ib:10.65.32.19@o2ib:/scratch  191T  142T   50T  75% /lustre/scratch
```
{: .output}
## Local filesystem
### Node scratch
Each compute node has its own 900GB local hard drive, which is needed for time-critical tasks 
such as managing virtual memory. The system usage of the local disk is kept as small as possible 
to allow some local disk for your applications, running on the node

It is possible to monitor the amount of space used on a node. To you do this by combining the `ssh`
and `df =h` commands. The example below shows you the steps need to do that.

```
{{ site.host_workgroup_prompt }} ssh r01n39 df -h /tmp
```
{: .language-bash}
```
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda3       889G   33M  889G   1% /tmp
```
{: .output}

> ## How check a node's usage for a node in your workgroup
> How can you find a compute node if your workgroup and check it's usage?
>
> > ## Solution 
> > ```
> > {{ site.host_prompt }} workgroup it_css
> > {{ site.host_workgroup_prompt }} sinfo -p it_css
> > {{ site.host_workgroup_prompt }} ssh r01n39 df -h /tmp
> > ```
> > {: .language-bash}
> > ```
> > PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
> > it_css       up 7-00:00:00      1 drain* r04n24
> > it_css       up 7-00:00:00      1  down* r00n45
> > it_css       up 7-00:00:00      1  drain r01n39
> > it_css       up 7-00:00:00     83    mix r00g[01-03],r00n[07,11,14,18,23,27-28,38,
> > 41,43-44,47,50-51],r01g[00-01],r01n[01-02,08-09,14-15,21-22,24-26,44,50,53],r03g03,
> > r03n[04,09-10,27-28,32,37-42,44,47-48,55],> > r04n[12,14-20,22-23,26,30-39,44,47,49-50,52-53,
> > 55-56,58-59,62,64] it_css       up 7-00:00:00    109  alloc r00n[01-06,08-10,21-22,24-26,29-
> > 37,39-40,42,46,48-49,52-55],r01n[03-07,10-13,27-38,40-43,45-48,51-52,54-55],
> > r03g06,r03n[02-03,06-08,11,26,29-31,33-36,43,45-46,49-54,56-57],r04n[00-11,13,21,25,51,54]
> > it_css       up 7-00:00:00     70   idle r00g04,r00n[12-13,15-17,19-20],r01g[02-04],
> > r01n[16-20,23],r02s00,r03g[00-02,04-05,07-08],r03n[00-01,05,12-25],
> > r04n[27-29,40-43,45-46,48,57,60-61,63,65-76],r04s[00-01]
> > it_css       up 7-00:00:00      1   down r01n49
> > 
> > Filesystem      Size  Used Avail Use% Mounted on
> > /dev/sda3       889G   33M  889G   1% /tmp
> > ```
> > {: .output}
> {: .solution}
{: .challenge}

## User Quotas 
To help users maintain awareness of quotas and their usage on their home  and the workgroup(s) directories. , the command `my_quotas` is available to display a list of the quota-controlled filesystems on which the user has storage space. 
```
{{ site.host_workgroup_prompt}} my_quotas
```
{: .language-bash}

```
Type  Path            In-use / kiB Available / kiB  Pct
----- --------------- ------------ --------------- ----
user  /home/1200           2540544        20971520  12%
group /work/it_css       336004096      1073741824  31%
```
{: .output}

## Recovering Files
Using the CLI and Unix can be unforgiving when deleting files. To help protect user from losing files that were accidentally deleted from their home and workgroup directories, system administrators take snapshots of the before mentions directories. The snapshots are stored in  `$HOME/.zfs/snapshot/` and 
`$WORKGROUP/.zfs/snapshot/`. The `.zfs` directory does not show up in a directory listing using ` ls -a` as it is hidden, but you can view the directory's contents with the `cd` command. If there you will find a series of directories in a yyyymmdd-HHMM naming format. The table below breaks down the what the values are that make up the directory.  Each day three snapshots are taken, and daily snapshots are kept going back for a months, after that there are weekly, and finally monthly snapshots. 

| Snapshot Directory Naming format |
| Abbreviation | Defination |
| yyyy | For digit year value |
| mm | Two digit month value |
| dd | Two digit day value |
| HH | Two digit 24-hour style hour value |
| MM | Two digit minute value |



{% include links.md %}
