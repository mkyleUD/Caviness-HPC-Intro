---
title: "Scheduling jobs"
teaching: 45
exercises: 30
questions:
- "What is a scheduler and why are they used?"
- "How do I launch a program to run on any one node in the cluster?"
- "How do I capture the output of a program that is run on a node in the cluster?"
objectives:
- "Run a simple Hello World style program on the cluster."
- "Submit a simple Hello World style script to the cluster."
- "Use the batch system command line tools to monitor the execution of your job."
- "Inspect the output and error files of your jobs."
keypoints:
- "The scheduler handles how compute resources are shared between users."
- "Everything you do should be run through the scheduler."
- "A job is just a shell script."
- "If in doubt, request more resources than you will need."
---

## Job scheduler
An HPC system might have thousands of nodes and thousands of users. How do we decide who gets what
and when? How do we ensure that a task is run with the resources it needs? This job is handled by a
special piece of software called the scheduler. On an HPC system, the scheduler manages which jobs
run where and when.

The following illustration compares these tasks of a job scheduler to a waiter in a restaurant.
If you can relate to an instance where you had to wait for a while in a queue to get in to a 
popular restaurant, then you may now understand why sometimes your jobs do not start instantly
like they do on your laptop.

{% include figure.html max-width="75%" file="/fig/restaurant_queue_manager.svg"
alt="Compare a job scheduler to a waiter in a restaurant" caption="" %}


The scheduler used in this lesson is {{ site.sched_name }}. Although {{ site.sched_name }} is not used everywhere,
running jobs is quite similar regardless of what software is being used. The exact syntax might change, but the
concepts remain the same.

## Running a batch job

The most basic use of the scheduler is to run a command non-interactively. Any command (or series 
of commands) that you want to run on the cluster is called a *job*, and the process of using a
scheduler to run the job is called *batch job submission*.

In this case, the job we want to run is just a shell script. Let's create a demo shell script to 
run as a test (Let's name the script example-job.sh)

> ## Creating our test job
> 
> Using your favorite text editor, create the following script and run it. Does it run on the
> cluster or just our login node?
>
>```
>#!/bin/bash
>
> echo "This script is running on: ${HOSTNAME}"
> sleep 120
> ```
> {: .source}
{: .challenge}

If you completed the previous challenge than you see the submitted job was ran on the login node and 
not a compute node. To run a job on a compute node you need to make sure that you first join your
investing-entity's workgroup and use the ``{{ site.sched_submit }}`` command to submit your job.

A workgroup is {{ site.sched_name }}'s way knowing which compute nodes you have access to. Below is an
example of how to join a workgroup. Notice after you join your workgroup the workgroup's name is prepended
to your username. 
```
{{ site.host_prompt }} workgroup -g it_css
{{site.host_workgroup_prompt}}
```
{: .language-bash}

Now that we made sure that we are in our respective workgroups we can submit our example script.
```
{{ site.host_workgroup_prompt }} {{ site.sched_submit }} {{ site.sched_submit_options }} example-job.sh
```
{: .language-bash}
```
Submitted batch job 10587451
```
{: .output}

And that's all we need to do to submit a job. Our work is done -- now the scheduler takes over and
tries to run the job for us. While the job is waiting to run, it goes into a list of jobs called 
the *queue*. To check on our job's status, we check the queue using the command
`{{ site.sched_status }} {{ site.sched_flag_user }}`.

```
{{ site.host_workgroup_prompt }} {{ site.sched_status }} {{ site.sched_flag_user }}
```
{: .language-bash}
```
    JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
10587451  standard example-    tra0ine R       0:04      1 r04n03
```
{: .output}

We can see all the details of our job, most importantly that it is in the "R" or "RUNNING" state.
Sometimes our jobs might need to wait in a queue ("PENDING") or have an error. The best way to check
our job's status is with `{{ site.sched_status }}`. Of course, running `{{ site.sched_status }}` repeatedly to check on things can be
a little tiresome. To see a real-time view of our jobs, we can use the `watch` command. `watch`
reruns a given command at 2-second intervals. This is too frequent, and will likely upset your system
administrator. You can change the interval to a more reasonable value, for example 60 seconds, with the
`-n 60` parameter. Let's try using it to monitor another job.

```
{{ site.host_workgroup_prompt }} {{ site.sched_submit }} {{ site.sched_submit_options }} example-job.sh
{{ site.host_workgroup_prompt }} watch -n 60 {{ site.sched_status }} {{ site.sched_flag_user }}
```
{: .language-bash}

You should see an auto-updating display of your job's status. When it finishes, it will disappear
from the queue. Press `Ctrl-C` when you want to stop the `watch` command.

## Customising a job

The job we just ran used all the scheduler's default options. In a real-world scenario, that's
probably not what we want. The default options represent a reasonable minimum. Chances are, we will
need more cores, more memory, more time, among other special considerations. To get access to these
resources we must customize our job script.

Comments in UNIX (denoted by `#`) are typically ignored. But there are exceptions. For instance, the
special `#!` comment at the beginning of scripts specifies what program should be used to run it
(typically `/bin/bash`). Schedulers like {{ site.sched_name }} also have a special comment
used to denote special scheduler-specific options. Though these comments differ from scheduler to
scheduler, {{ site.sched_name }}'s special comment is `{{ site.sched_comment }}`.
Anything following the `{{ site.sched_comment }}` comment is interpreted as an
instruction to the scheduler.

Let's illustrate this by example. By default, a job's name is the name of the script, but the
`{{ site.sched_flag_name }}` option can be used to change the name of a job.

Submit the following job (`{{ site.sched_submit }} {{ site.sched_submit_options }} example-job.sh`):

```
#!/bin/bash
{{ site.sched_comment }} {{ site.sched_flag_name }} example_script

echo "This script is running on:${HOSTNAME}"
sleep 120
```
{: .source}
```
{{ site.host_workgroup_prompt }} {{ site.sched_status }} {{ site.sched_flag_user }}
```
{: .language-bash}
```
    JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
10587799  standard new_name    traine R       0:38      1 r00n15
```
{: .output}

Fantastic, we've successfully changed the name of our job!

> ## Setting up email notifications
> 
> Jobs on an HPC system might run for days or even weeks. We probably have better things to do than
> constantly check on the status of our job with `{{ site.sched_status }}`. Looking at the
> `man` page for `{{ site.sched_submit }}`, can you set up our test job to send you an email
> when it finishes?
>
> > ## Solution
> > 
> > ```
> > {{site.sched_comment}} --mail-user='{{site.host_id}}@udel.edu'
> > {{site.sched_comment}} --mail-type=END
> > ```
> > {: .source} 
>  {: .solution}
{: .challenge}


### Resource requests

But what about more important changes, such as the number of cores and memory for our jobs? One 
thing that is absolutely critical when working on an HPC system is specifying the resources 
required to run a job. This allows the scheduler to find the right time and place to schedule our 
job. If you do not specify requirements (such as the amount of time you need), you will likely be
stuck with your site's default resources, which is probably not what we want.

The following are several key resource requests:

* `-n <nnodes>` - how many nodes does your job need? 

* `-c <ncpus>` - How many CPUs does your job need?

* `--mem=<megabytes>` - How much memory on a node does your job need in megabytes? You can also
  specify gigabytes using by adding a little "g" afterwards (example: `--mem=5g`)

* `--time <days-hours:minutes:seconds>` - How much real-world time (walltime) will your job take to
  run? The `<days>` part can be omitted.

Note that just *requesting* these resources does not make your job run faster! We'll talk more 
about how to make sure that you're using resources effectively in a later episode of this lesson.

> ## Submitting resource requests
>
> Submit a job that will use 1 full node and 5 minutes of walltime.
> 
> > ## Solution
> > 
> > ```
> > #Requesting all 40 cores for the 1 task
> > {{site.sched_comment}} --cpus-per-task=40
> > #Blocking the sharing of the node with other users unless they are declared
> > {{site.sched_comment}} --exclusive
> > #Requesting 1 task per node
> > {{site.sched_comment}} -ntask=1
> > #Setting the max wall clock at 5 minutes
> > {{site.sched_comment}} --time=0-00:05:00
> > 
> > ```
> > {: .source} 
>  {: .solution}
{: .challenge}

> ## Job environment variables
>
> When SLURM runs a job, it sets a number of environment variables for the job. One of these will
> let us check our work from the last problem. The `SLURM_CPUS_PER_TASK` variable is set to the
> number of CPUs we requested with `-c`. Using the `SLURM_CPUS_PER_TASK` variable, modify your job
> so that it prints how many CPUs have been allocated.
> > ## Solution
> > 
> > ```
> > #!/bin/bash
> > #SBATCH --cpus-per-task=4
> > #SBATCH -ntask=1
> > 
> > echo "This script is running on ${HOSTNAME}"
> > echo "It is using ${SLURM_CPUS_PER_TASK} cpus"
> > sleep 120 
> > ```
> > {: .source} 
>  {: .solution}
{: .challenge}


Resource requests are typically binding. If you exceed them, your job will be killed. Let's use
walltime as an example. We will request 1 minute of walltime, and attempt to run a job for two
minutes.

```
#!/bin/bash
#SBATCH -t 01:00

echo "This script is running on: ${HOSTNAME}"

sleep 500

echo "This line should not be seen"
```
{: .language-bash}

Submit the job and wait for it to finish. Once it is has finished, check the log file.

```
{{ site.host_prompt }} {{ site.sched_submit }} {{ site.sched_submit_options }} example-job.sh
{{ site.host_prompt }} watch -n 60 {{ site.sched_status }} {{ site.sched_flag_user }}
{% include /snippets/13/long_job_cat.snip %}
```
{: .language-bash}
```
This script is running on: r04n06
slurmstepd: error: *** JOB 10699863 ON r04n06 CANCELLED AT 2020-12-07T13:30:10 DUE TO TIME LIMIT ***
```
{: .output}

Our job was killed for exceeding the amount of resources it requested. Although this appears harsh,
this is actually a feature. Strict adherence to resource requests allows the scheduler to find the
best possible place for your jobs. Even more importantly, it ensures that another user cannot use
more resources than they've been given. If another user messes up and accidentally attempts to use
all of the cores or memory on a node, {{ site.sched_name }} will either restrain their job
to the requested resources or kill the job outright. Other jobs on the node will be unaffected.
This means that one user cannot  mess up the experience of others, the only jobs affected by a
mistake in scheduling will be their
own.

## Cancelling a job

Sometimes we'll make a mistake and need to cancel a job. This can be done with the `{{ site.sched_del }}`
command. Let's submit a job and then cancel it using its job number (remember to change the 
walltime so that it runs long enough for you to cancel it before it is killed!).

```
{{ site.host_prompt }} {{ site.sched_submit }} {{ site.sched_submit_options }} example-job.sh
{{ site.host_prompt }} {{ site.sched_status }} {{ site.sched_flag_user }}
```
{: .language-bash}
```
Submitted batch job 10699878

   JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
10699878  standard example-    mkyle  R       0:10      1 r00n54
 
```
{: .output}

Now cancel the job with it's job number. Absence of any job info indicates that the job has been
successfully cancelled.

```
{% include /snippets/13/del_job.snip %}
... Note that it might take a minute for the job to disappear from the queue ...
{{ site.host_prompt }} {{ site.sched_status }} {{ site.sched_flag_user }}
```
{: .language-bash}
```
JOBID  USER  ACCOUNT  NAME  ST  REASON  START_TIME  TIME  TIME_LEFT  NODES  CPUS

```
{: .output}

> ## Cancelling multiple jobs
>
> We can also cancel all of our jobs at once using the `-u` option. This will delete all jobs for a
> specific user (in this case us). Note that you can only delete your own jobs.
>
> Try submitting multiple jobs and then cancelling them all with `scancel -u yourUsername`.
{: .challenge}


## Other types of jobs

Up to this point, we've focused on running jobs in batch mode. {{ site.sched_name }}
also provides the ability to start an interactive session.

Occasionally there are tasks that need to be done interactively. Creating an entire job
script might be overkill, but the amount of resources required is too much for a login node to
handle. A good example of this might be a trial run of a matlab script. Fortunately, we can run these types of
tasks as a one-off with `{{ site.sched_interactive }}`.

`srun` runs a single command on the cluster and then exits. Let's demonstrate this by running the
`hostname` command with `srun`. (We can cancel an `srun` job with `Ctrl-c`.)

```
{{ site.host_workgroup_prompt }} srun hostname
```
{: .bash}
```
srun: job 10699891 queued and waiting for resources
srun: job 10699891 has been allocated resources
r00n54.localdomain.hpc.udel.edu
```
{: .output}

`srun` accepts all of the same options as `sbatch`. However, instead of specifying these in a
script, these options are specified on the command-line when starting a job. To submit a job that
uses 2 CPUs for instance, we could use the following command:

```
{{ site.host_workgroup_prompt }} srun -c 2 echo "This job will use 2 CPUs."
```
{: .bash}
```
This job will use 2 CPUs.
```
{: .output}

Typically, the resulting shell environment will be the same as that for `sbatch`.

### Interactive jobs

Sometimes, you will need a lot of resource for interactive use. Perhaps it's our first time running
an analysis or we are attempting to debug something that went wrong with a previous job.
Fortunately, SLURM makes it easy to start an interactive job with `salloc`:

```
{{ site.host_workgroup_prompt }} salloc
```
{: .language-bash}

```
salloc: Pending job allocation 10699898
salloc: job 10699898 queued and waiting for resources
salloc: job 10699898 has been allocated resources
salloc: Granted job allocation 10699898
salloc: Waiting for resource configuration
salloc: Nodes r00n56 are ready for job

```
{: .output}
You should be presented with a bash prompt. Note that the prompt will likely change to reflect your
new location, in this case the compute node we are logged on. You can also verify this with
`hostname`.
```
{{site.sched_prompt}} hostname
```
{: .language-bash}
```
r00n56.localdomain.hpc.udel.edu
```
{: .output}

You should be presented with a bash prompt. Note that the prompt will likely change to reflect your
new location, in this case the compute node we are logged on. You can also verify this with
`hostname`.

> ## Creating remote graphics
> 
> To see graphical output inside your jobs, you need to use X11 forwarding. To connect
> with this feature enabled, use the `-Y` option when you login with `ssh` with the command
> `ssh -Y username@host`. Windows users will need to follow the directions in the 
> [setup page]({{site.url}}{{site.baseurl}}/setup).
> 
> To demonstrate what happens when you create a graphics  window on the remote node we will download
> a University of Delaware logo image on the {{site.host_name}} cluster and view it locally with a program called 
> imagemagick. Then we will request an interactive compute node and test to make sure we have setup X11
> forwarding correctly.  
>
> If you are using a Mac, you must have installed XQuartz (and restarted
> your computer) for this to work.
> If you are using a Windows Machine you will need to install x-ming (and restart your computer)
> for this to work PuTTY.
>
> ```
> {{site.host_prompt}} wget https://cas.nss.udel.edu/themes/secureheader/headerbluetext.png?v=2 -O ud_image.png
> {{site.host_prompt}} display ud_image.png
> ```
> {: .language-bash}
> 
> ```
> --2020-12-07 15:04:45--  https://cas.nss.udel.edu/themes/secureheader/headerbluetext.png?v=2
> Resolving cas.nss.udel.edu (cas.nss.udel.edu)... 128.175.176.8
> Connecting to cas.nss.udel.edu (cas.nss.udel.edu)|128.175.176.8|:443... connected.
> HTTP request sent, awaiting response... 200 OK
> Length: 26604 (26K) [image/png]
> Saving to: ‘ud_image.png’
> 
> 100%[==================================================>] 26,604      --.-K/s   in 0.005s
> 
> 2020-12-07 15:04:45 (4.74 MB/s) - ‘ud_image.png’ saved [26604/26604]
>
> ```
> {: .output}
> 
> The downloaded image will open on your desktop. To close you can with hit <kbd>Ctrl</kbd> + <kbd>C</kbd>
> or by clicking the "X" button on the images window.
> 
> To check if you have X11 forwarding working correctly from a computer node run the following steps. 
> ```
> {{site.host_workgroup_prompt}} salloc --x11 --partition=_workgroup_
> {{site.sched_prompt}} xdpyinfo
> ```
> {: .language-bash}
> ```
> salloc: Granted job allocation 10714363
> salloc: Waiting for resource configuration
> salloc: Nodes r00n56 are ready for job
> slurmstepd: error: Unable to create TMPDIR [/tmp/job_10714353/step_0.0]: No such file or directory
> slurmstepd: error: Setting TMPDIR to /tmp
> 
> ... Skipped Lines (Lots and Lots of Skipped Lines) ...
> 
>   visual:
>     visual id:    0xcd
>     class:    TrueColor
>     depth:    24 planes
>     available colormap entries:    256 per subfield
>     red, green, blue masks:    0xff0000, 0xff00, 0xff
>     significant bits in color specification:    8 bits
>   visual:
>     visual id:    0x45
>     class:    TrueColor
>     depth:    32 planes
>     available colormap entries:    256 per subfield
>     red, green, blue masks:    0xff0000, 0xff00, 0xff
>     significant bits in color specification:    8 bits
>
> ```
> {: .output}
>
> That shows that X11 forwarding is set up correctly. You can now open an software like Gaussian
> in a GUI from the remote compute node on your local machine.
>
> When you are done with the interactive job, type `exit` to quit your session. 
{: .challenge}




{% include links.md %}
