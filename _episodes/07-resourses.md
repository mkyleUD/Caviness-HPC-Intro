---
title: "Using resources effectively"
teaching: 15
exercises: 10
questions:
- "How do we monitor our jobs?"
- "How can I get my jobs scheduled more easily?" 
objectives:
- "Understand how to look up job statistics and profile code."
- "Understand job size implications."
keypoints:
- "The smaller your job, the faster it will schedule."
---

We now know virtually everything we need to know about getting stuff on a cluster. We can log on,
submit different types of jobs, use preinstalled software, and install and use software of our own.
What we need to do now is use the systems effectively.

## Estimating required resources using the scheduler

Although we covered requesting resources from the scheduler earlier, how do we know how much and
what type of resources we will need in the first place?

Answer: we don't. Not until we've tried it ourselves at least once. We'll need to benchmark our job
and experiment with it before we know how much it needs in the way of resources.

The most effective way of figuring out how much resources a job needs is to submit a test job, and
then ask the scheduler how many resources it used.

A good rule of thumb is to ask the scheduler for more time and memory than you expect your job to
need. This ensures that minor fluctuations in run time or memory use will not result in your job
being canceled by the scheduler. Recommendations for how much extra to ask for vary but 10% is 
probably the minimum, with 20-30% being more typical. Keep in mind that if you ask for too much,
your job may not run even though enough resources are available, because the scheduler will be
waiting to match what you asked for.

## Benchmarking `pi-serial.py`
Let's to a look at the three serial-jobs that we submitted in the last lesson. 

```
{{site.host_workgroup_prompt}} cd /lesson-files/serial
{{site.host_short_prompt}}serial]$ ls *.out
```
{: .language-bash}

```
serial-11788448.out  serial-11788449.out  serial-11788450.out
```
{: .output}


Once the job completes (note that it takes much less time than expected), we can query the 
scheduler to see how long our job took and what resources were used. We will use `{{ site.sched_hist }}` to
get statistics about our job.

```
{{site.host_short_prompt}}serial]$ {{ site.sched_hist }} -j 11788448,11788449,11788450
```
{: .language-bash}
```
       JobID    JobName  Partition    Account  AllocCPUS      State ExitCode
------------ ---------- ---------- ---------- ---------- ---------- --------
11788448         serial     it_css     it_css          1  COMPLETED      0:0
11788448.ba+      batch                it_css          1  COMPLETED      0:0
11788448.ex+     extern                it_css          1  COMPLETED      0:0
11788449         serial     it_css     it_css          1  COMPLETED      0:0
11788449.ba+      batch                it_css          1  COMPLETED      0:0
11788449.ex+     extern                it_css          1  COMPLETED      0:0
11788450         serial     it_css     it_css          1  COMPLETED      0:0
11788450.ba+      batch                it_css          1  COMPLETED      0:0
11788450.ex+     extern                it_css          1  COMPLETED      0:0

```
{: .output}

This shows the 3 different pi-serial.py jobs we ran recently (note that there are multiple entries 
per job). To get detailed info about a job, we change commands slightly.

```
{{site.host_short_prompt}}serial]$ {{ site.sched_hist }} -l -j 11788448,11788449,11788450
```
{: .language-bash}

It will show a lot of info, in fact, every single piece of info collected on your job by the
scheduler. It may be useful to redirect this information to `less` to make it easier to view (use
the left and right arrow keys to scroll through fields).

```
{{site.host_short_prompt}}serial]$ {{ site.sched_hist }} -l -j 11788448,11788449,11788450 | less
```
{: .language-bash}

Some interesting fields include the following:

* **Hostname** - Where did your job run?
* **MaxRSS** - What was the maximum amount of memory used?
* **Elapsed** - How long did the job take?
* **State** - What is the job currently doing/what happened to it?
* **MaxDiskRead** - Amount of data read from disk.
* **MaxDiskWrite** - Amount of data written to disk.

Even with outputting this information to `less` this is still pretty difficult to read. To make it 
easier we can format out the output. To do this will first use the `--helpformat` option to see the 
fields we can format the output to. Then we will use the `--format` option with a comma separated
list of the fields we would like to see.

```
{{site.host_short_prompt}}serial]$ {{ site.sched_hist }} -l -j 11788448,11788449,11788450 --format 
```
{: .language-bash}

```
user,jobname,jobid,node,maxrss,elapsed,state,maxdiskread,maxdiskwrite,avecpufreq
     User    JobName        JobID        NodeList     MaxRSS    Elapsed      State  MaxDiskRead MaxDiskWrite AveCPUFreq
--------- ---------- ------------ --------------- ---------- ---------- ---------- ------------ ------------ ----------
    traine     serial 11788448              r01n15              00:00:01  COMPLETED
               batch 11788448.ba+          r01n15        12K   00:00:01  COMPLETED            0            0      1.21G
              extern 11788448.ex+          r01n15          0   00:00:01  COMPLETED        0.00M            0      1.20G
    traine     serial 11788449              r01n15              00:00:04  COMPLETED
               batch 11788449.ba+          r01n15          0   00:00:04  COMPLETED            0            0      1.22G
              extern 11788449.ex+          r01n15        92K   00:00:04  COMPLETED            0            0      1.20G
    traine     serial 11788450              r01n15              00:01:12  COMPLETED
               batch 11788450.ba+          r01n15  38145480K   00:01:12  COMPLETED        2.91M        0.12M      2.79G
              extern 11788450.ex+          r01n15        92K   00:01:12  COMPLETED        0.00M            0      2.70G
```
{: .output}

 >## Check how many nodes and CPUs were used
 > How can you use sacct to tell you how many nodes and and CPUs were used for the jobs you just looked at?
 >>## Solution
 >> ```
 >> {{site.host_short_prompt}}serial]$ {{ site.sched_hist }} -l -j 11788448,11788449,11788450 --format 
 user,jobname,jobid,node,maxrss,elapsed,state,maxdiskread,maxdiskwrite,avecpufreq,nnode,ncpu
 >> ```
 >> {: .language-bash}
>{: .solution}
{: .challenge}

## Measuring the statistics of currently running tasks

> ## Connecting to Nodes
> The {{ site.host_name}} cluster allows users to connect directly to compute nodes that they are
> currently running jobs on. This is done from the head node and allow user to better inspect on 
> a running job and see how it's doing, but is not  a recommended practice in general, 
> because it bypasses the resource manager. If you need to do this, check where a job is 
> running with `{{ site.sched_status }}`, then run `ssh nodename`. 
{: .callout}
  
We can also check on stuff running on the login node right now the same way (so it's 
not necessary to `ssh` to a node for this example).

### top

The best way to check current system stats is with `top` (`htop` is a prettier version of `top` but
may not be available on your system).

Some sample output might look like the following (`Ctrl + c` to exit):

```
{{ site.host_prompt }} top
```
{: .language-bash}
```
top - 14:27:00 up 29 days, 21:07, 27 users,  load average: 0.00, 0.03, 0.13
Tasks: 745 total,   1 running, 744 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.0 us,  0.1 sy,  0.0 ni, 99.9 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem : 26385332+total, 14865897+free,  2769012 used, 11242532+buff/cache
KiB Swap:  4194300 total,  4184400 free,     9900 used. 25777350+avail Mem

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
 3946 traine     20   0  168676   3140   1732 R   0.7  0.0   0:01.57 top
   53 root      rt   0       0      0      0 S   0.3  0.0   0:37.79 migration/9
 4225 root      20   0       0      0      0 S   0.3  0.0   0:00.02 kworker/u72:1
 7297 jkalsch   20   0  113264   1868   1440 S   0.3  0.0   2:57.02 bash
12654 root       0 -20       0      0      0 S   0.3  0.0   0:05.96 kworker/33:2H
    1 root      20   0  193580   6664   2528 S   0.0  0.0  15:15.16 systemd
    2 root      20   0       0      0      0 S   0.0  0.0   0:43.59 kthreadd
    3 root      20   0       0      0      0 S   0.0  0.0   0:04.86 ksoftirqd/0
    8 root      rt   0       0      0      0 S   0.0  0.0   0:01.42 migration/0
    9 root      20   0       0      0      0 S   0.0  0.0   0:00.00 rcu_bh
   10 root      20   0       0      0      0 S   0.0  0.0  25:31.63 rcu_sched

```
{: .output}

Overview of the most important fields:

* `PID` - What is the numerical id of each process?
* `USER` - Who started the process?
* `RES` - What is the amount of memory currently being used by a process (in bytes)?
* `%CPU` - How much of a CPU is each process using? Values higher than 100 percent indicate that a
  process is running in parallel.
* `%MEM` - What percent of system memory is a process using?
* `TIME+` - How much CPU time has a process used so far? Processes using 2 CPUs accumulate time at
  twice the normal rate.
* `COMMAND` - What command was used to launch a process?

> ## Additional CPU Information
> To see additional information about each `CPU` on the node press the <kbd>1</kbd> key.
> 
{: .callout}
### free

Another useful tool is the `free -h` command. This will show the currently used/free amount of
memory.

```
{{ site.host_prompt }} free -h
```
{: .language-bash}
```
{% include /snippets/16/free_output.snip %}
```
{: .output}

The key fields here are **total**, **used**, and **available** - which represent the amount of memory that the
machine has in total, how much is currently being used, and how much is still available. When a
computer runs out of memory it will attempt to use "swap" space on your hard drive instead. Swap
space is very slow to access - a computer may appear to "freeze" if it runs out of memory and 
begins using swap. However, compute nodes on HPC systems usually have swap space disabled so when
they run out of memory you usually get an "Out Of Memory (OOM)" error instead.

### ps 

To show all processes from your current session, type `ps`.

```
{{ site.host_prompt }} ps
```
{: .language-bash}
```
  PID TTY          TIME CMD
15113 pts/5    00:00:00 bash
15218 pts/5    00:00:00 ps
```
{: .output}

Note that this will only show processes from our current session. To show all processes you own
(regardless of whether they are part of your current session or not), you can use `ps ux`.

```
{{ site.host_prompt }} ps ux
```
{: .language-bash}
```
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
auser  67780  0.0  0.0 149140  1724 pts/81   R+   13:51   0:00 ps ux
auser  73083  0.0  0.0 142392  2136 ?        S    12:50   0:00 sshd: auser@pts/81
auser  73087  0.0  0.0 114636  3312 pts/81   Ss   12:50   0:00 -bash
```
{: .output}

This is useful for identifying which processes are doing what.

## Killing processes

To kill all of a certain type of process, you can run `killall commandName`. `killall rsession`
would kill all `rsession` processes created by RStudio, for instance. Note that you can only kill
your own processes.

You can also kill processes by their PIDs using `kill 1234` where `1234` is a `PID`. Sometimes
however, killing a process does not work instantly. To kill the process in the most hardcore manner
possible, use the `-9` flag. It's recommended to kill using without `-9` first. This gives a 
process the chance to clean up child processes, and exit cleanly. However, if a process just isn't
responding, use `-9` to kill it instantly.

{% include links.md %}
