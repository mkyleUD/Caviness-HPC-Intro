---
title: "Using shared resources responsibly"
teaching: 15
exercises: 5
questions:
- "How can I be a responsible user?"
- "How can I protect my data?"
- "How can I best get large amounts of data off an HPC system?"
objectives:
- "Learn how to be a considerate shared system citizen."
- "Understand how to protect your critical data."
- "Appreciate the challenges with transferring large amounts of data off HPC systems."
- "Understand how to convert many files to a single archive file using tar."
keypoints:
- "Be careful how you use the login node."
- "Your data on the system is your responsibility."
- "Plan and test large data transfers."
- "It is often best to convert many files to a single archive file before transferring."
- "Again, don't run stuff on the login node."
- "Don't be a bad person and run stuff on the login node."
---

One of the major differences between using remote HPC resources and your own system 
(e.g. your laptop) is that they are a shared resource. How many users the resource is
shared between at any one time varies from system to system but it is unlikely you
will ever be the only user logged into or using such a system.

We have already mentioned one of the consequences of this shared nature of the resources:
the scheduling system where you submit your jobs, but there are other things you need 
to consider in order to be a considerate HPC citizen, to protect your critical data
and to transfer data 

## Be kind to the login nodes

The login node is often very busy managing lots of users logged in, creating and editing files
and compiling software! It doesn’t have any extra space to run computational work.

Don’t run jobs on the login node (though quick tests are generally fine). A “quick test” is
generally anything that uses less than 5 minutes of time and does not use much memory. If you
use too much resource then other users on the login node will start to be affected - their
login sessions will start to run slowly and may even freeze or hang. 

> ## Login nodes are a shared resource
>
> Remember, the login node is shared with all other users and your actions could cause
> issues for other people. Think carefully about the potential implications of issuing
> commands that may use large amounts of resource.
>
{: .callout}

You can always use the commands `top` and `ps ux` to list the processes you are running on a login
node and the amount of CPU and memory they are using. The `kill` command can be used along
with the *PID* to terminate any processes that are using large amounts of resource.

> ## Login Node Etiquette
> 
> Which of these commands would probably be okay to run on the login node?
> - python physics_sim.py
> - make
> - create_directories.sh
> - molecular_dynamics_2
> - tar -xzf R-3.3.0.tar.gz
> 
{: .challenge}

If you experience performance issues with a login node you should report it to the system
staff (usually via the helpdesk) for them to investigate. You can use the `top` command
to see which users are using which resources.

## Test before scaling

All {{ site.host_name }} users are members of a workgroup whose owner bought into the cluster.
This means that users are not billed for the resources they use by their submitted jobs.
However, this does not mean that users should not use the same care and caution when submitting
large jobs. A simple mistake in a job script can tie up a large amount of resource. Imagine a 
job script with a mistake that makes it sit doing nothing for 24 hours on 1000 cores or one where
you have requested 2000 cores by mistake and only use 100 of them! This problem can be compounded
when people write scripts that automate job submission (for example, when running the same 
calculation or analysis over lots of different input). These mistakes could cause the job to 
be preempted on the standard node, or tie up your workgroup’s resources. This could limit or even block other members of your workgroup from submitting a job.

To help users test jobs {{ site.host_name }} has `devel` nodes. These nodes have limited 
resources which are intended for testing jobs with short queues times. This will help prevent
the wasting of shared workgroup and community resources.

> ## Test job submission scripts that use large amounts of resource
> Before submitting a large run of jobs, submit one as a test first to make sure everything works
> as expected.
>
> Before submitting a very large or very long job submit a short truncated test to ensure that
> the job starts as expected
{: .callout}

## Have a backup plan

Although many {{ site.host_name }} keep backups of some directories, it does not cover all the file systems available. and may only be for disaster recovery purposes (*i.e.* for restoring the whole 
file system if lost rather than an individual file or directory you have deleted by mistake). 
Your data on the system is primarily your responsibility and you should ensure you have secure 
copies of data that are critical to your work.

Version control systems (such as Git) often have free, cloud-based offerings (e.g. Github, Gitlab)
that are generally used for storing source code. Even if you are not writing your own 
programs, these can be very useful for storing job scripts, analysis scripts and small
input files. 

For larger amounts of data, you should make sure you have a robust system in place for taking
copies of critical data off {{ site.host_name }} wherever possible to backed-up storage. Tools such
as `rsync` can be very useful for this.


> ## Your data is your responsibility
> Make sure you understand what the backup policies are on {{ site.host_name }}'s file systems and 
> what implications they have for your work if you lose your data on the system. Plan your backups of
> critical data and how you will transfer data on and off the system throughout the project.
{: .callout}

## Transferring data

As mentioned above, many users run into the challenge of transferring large amounts of data 
off {{ site.host_name }} at some point (this is more often in transferring data off than onto systems
but the advice below applies in either case). Data transfer speed may be limited by many
different factors so the best data transfer mechanism to use depends on the type of data being
transferred and where the data is going. Some of the key issues to be aware of are:

- **Disk speed** - File systems on HPC systems are often highly parallel, consisting of a very
  large number of high performance disk drives. This allows them to support a very high data
  bandwidth. Unless the remote system has a similar parallel file system you may find your
  transfer speed limited by disk performance at that end.
- **Meta-data performance** - *Meta-data operations* such as opening and closing files or
  listing the owner or size of a file are much less parallel than read/write operations. If
  your data consists of a very large number of small files you may find your transfer speed is
  limited by meta-data operations. Meta-data operations performed by other users of the system
  can also interact strongly with those you perform so reducing the number of such operations
  you use (by combining multiple files into a single file) may reduce variability in your transfer
  rates and increase transfer speeds.
- **Network speed** - Data transfer performance can be limited by network speed. More importantly
  it is limited by the slowest section of the network between source and destination. If you are
  transferring to your laptop/workstation, this is likely to be its connection (either via LAN or 
  wifi).
- **Firewall speed** - Most modern networks are protected by some form of firewall that filters
  out malicious traffic. This filtering has some overhead and can result in a reduction in data
  transfer performance. The needs of a general purpose network that hosts email/web-servers and
  desktop machines are quite different from a research network that needs to support high volume
  data transfers. If you are trying to transfer data to or from a host on a general purpose
  network you may find the firewall for that network will limit the transfer rate you can achieve.

As mentioned above, if you have related data that consists of a large number of small files it
is strongly recommended to pack the files into a larger *archive* file for long term storage and
transfer. A single large file makes more efficient use of the file system and is easier to move,
copy and transfer because significantly fewer meta-data operations are required. Archive files can
be created using tools like `tar` and `zip`. We have already met `tar` when we talked about data
transfer earlier. 

> ## Consider the best way to transfer data
> If you are transferring large amounts of data you will need to think about what may affect your transfer
> performance. It is always useful to run some tests that you can use to extrapolate how long it will
> take to transfer your data.
>
> If you have many files, it is best to combine them into an archive file before you transfer them using a
> tool such as `tar`.
{: .callout}


{% include links.md %}
