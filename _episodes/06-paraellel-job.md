---
title: "Running jobs on the cluster"
teaching: 30
exercises: 30
questions:
- "What are types of jobs are there?"
- "Which type of job is the correct one for my task?"
objectives:
- "Understand what the different job types are and when we should run them."
keypoints:
- "Serial jobs on a HPC are commonly all that is needed."
- "Thread jobs run on 1 nodes but can use multiple cores"
- "Parallel jobs can run on multiple nodes and multiple cores."
---
Now that we cover the the scheduler, software, and how to transfer files, the next
step is to create and submit a job.  In this lesson we are going to focus on 
submitting batch jobs to the develop partition. We are going to submit a
serial, and parallel job and briefly discuss what 
each of the different job types are. 
>## Are you in a workgroup? 
> Don't forget, that Caviness requires you to join your workgroup before you can 
> submit a job request to slurm
> ~~~~
> {{ site.host_prompt }}workgroup -g it_css
> {{ site.host_workgroup_prompt}}
> ~~~~
> {: .language-bash}
{: .prereq}


## What is a job 
In this context, a job consists of:
* a sequence of commands to be executed
* a list of resource requirements and other properties affecting scheduling of the job
* a set of environment variables

### Interactive job
For an interactive job, the user manually types the sequence of commands once the 
job is eligible for execution. If the necessary resources for the job are not immediately
available, then the user must wait; when resources are available, the user must be present 
at his/her computer in order to type the commands. Since the job scheduler does not care 
about the time of day, this could happen anytime, day or night. These will not be covered 
in this lesson.

### Batch job
By comparison, a batch job does not require the user be awake and at his or her computer: 
the sequence of commands is saved to a file, and that file is given to the job scheduler. 
A file containing a sequence of shell commands is also known as a script, so in order to 
run batch jobs a user must become familiar with shell scripting. The benefits of using batch 
jobs are significant:

* a job script can be reused (versus repeatedly having to type the same sequence of commands
for each job)
* when resources are granted to the job it will execute immediately (day or night), yielding 
increased job throughput

Batch jobs will be what we focus on for the rest of this lesson. 

### Our example code

We are going to be several different versions a python script. These example scripts
implements a stochastic algorithm for estimating the value of &#960;, the ratio 
of the circumference to the diameter of a circle. The program generates a large
number of random points on a 1&times;1 square centered on (&frac12;,&frac12;), and checks
how many of these points fall inside the unit circle. On average, &#960;/4 of the
randomly-selected points should fall in the circle, so &#960; can be estimated from 4*f*,
where *f* is the observed fraction of points that fall in the circle. Because each sample
is independent, this algorithm is easily  ran as a serial, thread and parallel job.

The example python script that we will be working with can be find in the lesson-files 
directory that we download early. Navigate to that directory. 

 ~~~~
 {{ site.host_workgroup_prompt}} cd lesson-files
 {{ site.host_short_prompt}} lesson-files]$ cd lesson-files
 ~~~~
 {: .language-bash}

## Serial job
Serial or single core jobs are the simplest case. Indeed, the batch system starts processing
your job script on a core of the first node assigned to your job, and in the single core case
this is the only core/node assigned to your job. So there is really nothing special that 
you need to do; just enter the command for your job and it should run. 

You still need to submit jobs to the scheduler to have them run on one of the compute nodes. 
So you will probably want to submit a batch job script via the `{{ site.sched_submit }}` command. Now since we are in the `lesson-files` directory we are going to create a new directory to work in. The new directory is going to be called `serial` and after we create we are going to copy the pi-serial.py script into there, and then `cd` into `serial`

 ~~~~
 {{ site.host_short_prompt}} lesson-files]$ mkdir serial
 {{ site.host_short_prompt}} lesson-files]$ cp pi-serial.py serial/
 {{ site.host_short_prompt}} lesson-files]$ cd serial
 {{ site.host_short_prompt}} serial]$ 
 ~~~~
 {: .language-bash}

Once we are in the `serial` directory we can copy the generic serial batch script `serial.qs` that the RCI maintains. After we copy it we are going to want to start `nano` to edit it to run `serial-pi.py`.

 ~~~~
 {{ site.host_short_prompt}} serial]$ cp /opt/templates/slurm/generic/serial.qs .
 {{ site.host_short_prompt}} serial]$ nano serial.qs
 ~~~~
 {: .language-bash}


## Read the comments in serial.qs
 It was mentioned above that serial.qs along with the other files found on 
 `/opt/templates/slurm/generic` are all maintained but the RCI staff. This means there is alot of important information in the comments through out the file. 
 
 >## One other important note on comments
 >For bash lines that start with `#` are ignore by bash because bash thinks they are
 >comments. This is general true, but Slurm does look at the lines that start with `#`
 >more accurately lines that start with `#SBATCH`. Slurm reads these lines as
 >arguments and using them in managing you job. 
{: .callout}

Once nano starts we are going to want to change the following lines.
 ~~~~
 ... Many lines later... 
 36 # [EDIT] It can be helpful to provide a descriptive (terse) name for
 37 #        the job (be sure to use quotes if there's whitespace in the
 38 #        name):
 39 #
 40 #SBATCH --job-name=serial
 ... Many lines later...
 51 #SBATCH --partition=_workgroup_
 52 # SBATCH --partition=devel
 ... Many lines later...
 62 #SBATCH --time=0-00:20:00
 63 #
 64 #        You can also provide a minimum acceptable runtime so the scheduler
 65 #        may be able to run your job sooner.  If you do not provide a
 66 #        value, it will be set to match the maximum runtime limit (discussed
 67 #        above).
 68 #
 69 # SBATCH --time-min=0-00:10:00
 ... Many lines later...
 77 #SBATCH --output=%x-%j.out
 78 #SBATCH --error=%x-%j.out
 ... Many lines later...
 148 ##Adding the latest version on python
 149 vpkg_require python/3.7.4
 150
 151 echo "The python script started at $(date)"
 152 ##Running the python script
 153 python3 pi-serial.py
 154 echo "The python script ended at $(date)"
 ~~~~
 {: .language-bash}

Once those changes have been made to `serial.qs` save them and submit this batch job 
with `{{ site.sched_submit }}`. A few monuments later we will run the `squeue` command to check the 
status of the batch job.

 ~~~~
 {{ site.host_short_prompt}} serial]$ {{ site.sched_submit }} serial.qs 
 Submitted batch job 11788449
 {{ site.host_short_prompt}} serial]$ squeue -j 11788449
             JOBID PARTITION     NAME      USER ST       TIME  NODES NODELIST(REASON)
          11788449    it_css   serial    traine  R       0:10      1 r01n15 
 ~~~~
 {: .language-bash}

After the jobs completes we will look at the output which will be found in the file 
`serial-11788449.out`.
 ~~~~
 {{ site.host_short_prompt}} serial]$ cat serial-1178848.out 
 Adding package `python/3.7.4` to your environment
 The python script started at Fri Feb 26 13:02:19 EST 2021
 1 core(s), 8738128 samples, 199.999878 MiB memory, 0.327389 seconds, 0.008111% error
 The python script ended at Fri Feb 26 13:02:19 EST 2021
 ~~~~
 {: .language-bash}

This script provides use with some information about what the script did and the resources that it required. We see that it used 1 core which is expected for serial jobs. We also set
that the job used less than 1GB of memory (RAM). That lastly  we see the job ran in about 
1/3 of a second, and the error was found to be ~0.0081%. 

We are going to run this jobs 2 more times with each run increasing the amount of points in
the program. As the amount of points increase we will see that the script will require more
RAM. To prevent errors we will have to make a couple updates to the `serial.qs` batch script. 


 ~~~~
 ... Many lines later... 
  22 # SBATCH --mem=8G
 ... Many lines later... 
 151 echo "The python script started at $(date)"
 152 ##Running the python script
 153 python3 pi-serial.py 81652028
 154 echo "The python script ended at $(date)"
 ~~~~
 {: .language-bash}

After making the above changes to the  `serial.qs` script we can submit the `{{ site.sched_submit }}` script
and run it. Like we did before we can use `squeue` to check the job status, otherwise we 
will wait about 30 seconds for the job to complete. Once the job completes we will view
the output.

 ~~~~
 {{ site.host_short_prompt}} serial]$ cat serial-1178849.out 
 Adding package `python/3.7.4` to your environment
 The python script started at Fri Feb 26 13:02:40 EST 2021
 1 core(s), 81652028 samples, 1868.866608 MiB memory, 3.029354 seconds, -0.007872% error
 The python script ended at Fri Feb 26 13:02:43 EST 2021
 ~~~~
 {: .language-bash}

This time we can see the jobs a few seconds to get through all the additional points, and the that it require ~2GB of RAM. 

Lets run this jobs this with over a __trillion__ points and see what happens. To do this we will have make a couple more edits to the `serial.qs` script.
 ~~~~
 ... Many lines later... 
  22 # SBATCH --mem=50G
 ... Many lines later... 
 151 echo "The python script started at $(date)"
 152 ##Running the python script
 153 python3 pi-serial.py 1431652028
 154 echo "The python script ended at $(date)"
 ~~~~
 {: .language-bash}

Again, after making the above changes to the  `serial.qs` script we can submit the 
`{{ site.sched_submit }}` script and run it. Like we did before we can use `squeue` to check the job 
status, otherwise we will wait about 60-90 seconds for the job to complete. Once the 
job completes we will view the output.

 ~~~~
 {{ site.host_short_prompt}} serial]$ cat serial-1178850.out 
 Adding package `python/3.7.4` to your environment
 The python script started at Fri Feb 26 13:02:57 EST 2021
 1 core(s), 1431652028 samples, 32767.914459 MiB memory, 71.194781 seconds, 0.001486% error
 The python script ended at Fri Feb 26 13:04:08 EST 2021
 ~~~~
 {: .language-bash}

This time we can see script took much longer, about 70 seconds, and took __A LOT__ more RAM, about 32GB. 

> ## Do you have enough RAM?
>
> What would happen if you don't request enough RAM? Give it a try. Edit the `serial.qs`
> to request less the 50GB requested in the last run. Submit the updated `serial.qs` 
> script and take a look at the jobs output.
{: .discussion}

Now that we are comfortable with the serial jobs, lets see if we can improve the speed of 
the job and the resources it uses.

## Multi-Processing Job
Multiprocessing or multithreaded jobs like serial jobs run on one compute node. They differ in the
fact the multiprocessing jobs can run on one more more cores. In this section we will look at a 
modified version of the piMulti.py which is set up to run on multiple cores. 

Before we start at the code lets set up a new work directory to work in. 
~~~~
 {{ site.host_short_prompt}} lesson-files]$ mkdir multiprocessing
 {{ site.host_short_prompt}} lesson-files]$ cp pi-serial.py multiprocessing/piMulti.py
 {{ site.host_short_prompt}} lesson-files]$ cd multiprocessing
 {{ site.host_short_prompt}} multiprocessing]$ 
 ~~~~
 {: .language-bash}

Now we will copy the `thread.qs` from the templates directory. After you copy it, open
it with nano so we can make some edits. 
~~~~
 {{ site.host_short_prompt}} multiprocessing]$ cp /opt/templates/slurm/generic/threads.qs
 {{ site.host_short_prompt}} multiprocessing]$ nano thread.qs
 ~~~~
 {: .language-bash}

 After nano starts we are going to change the following lines.
 ~~~~
 ... Many lines later...
 18 # [EDIT] Indicate the number of processor cores/threads to be used
 19 #        by the job:
 20 #
 21 #SBATCH --cpus-per-task=10
 ... Many lines later...
 31 #SBATCH --mem-per-cpu=2G
 ... Many lines later...
 44 # [EDIT] It can be helpful to provide a descriptive (terse) name for
 45 #        the job (be sure to use quotes if there's whitespace in the
 46 #        name):
 47 #
 48 #SBATCH --job-name=pi_multi
 #
 50 # [EDIT] The partition determines which nodes can be used and with what
 51 #        maximum runtime limits, etc.  Partition limits can be displayed
 52 #        with the "sinfo --summarize" command.
 53 #
 54 #SBATCH --partition=standard
 ... Many lines later...
 69 #SBATCH --time=0-00:10:00
 70 #
 71 #        You can also provide a minimum acceptable runtime so the scheduler
 72 #        may be able to run your job sooner.  If you do not provide a
 73 #        value, it will be set to match the maximum runtime limit (discussed
 74 #        above).
 75 #
 76 #SBATCH --time-min=0-00:01:00
 ... Many lines later...
 84 #SBATCH --output=%x-%j.out
 85 #SBATCH --error=%x-%j.out
 ... Many lines later...
 157 #
 158 # [EDIT] Execute your OpenMP/threaded program using the srun command:
 159 #
 160 srun /opt/shared/slurm/templates/share/threads.sh
 161 echo "The python script started at $(date)"
 162 vpkg_require python/3
 163 python3 piMulti.py             #This will use 8,738,128 points. This is the default value
 164 #python3 piMulti.py 81652028   #This will use 81,652,028 points.
 165 #python3 piMulti.py 1431652028 #This will user 1,431,652,028 points.
 166 echo "The python script ended at $(date)"
 ~~~~
 {: .language-bash}
Once those changes have been made to `threads.qs`, save them and submit it as a batch job with
`{{ site.sched_submit }}`. A few minutes later we will run the `squeue` command to check the status of the batch job.
~~~~
 {{ site.host_short_prompt}} multiprocessing]$ {{ site.sched_submit }} threads.qs
Submitted batch job 11811379
 {{ site.host_short_prompt}} multiprocessing]$  squeue -j 11811379
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
          11811379  standard pi_multi    traine  R       0:21      1 r01n26
 ~~~~
 {: .language-bash}

 After the jobs completes we will look at the output which  will be found in
 `cat pi_multi-11811379.out`. 
~~~~
  {{ site.host_short_prompt}} multiprocessing]$  cat pi_multi-11811379.out
  -- OpenMP job setup complete:
  --  OMP_THREAD_LIMIT     = 10
  --  OMP_PROC_BIND        = true
  --  OMP_PLACES           = cores
  --  MKL_NUM_THREADS      = 10
  --  MKL_DYNAMIC          = true
  --  MP_BLIST             = 24,25,26,27,28,29,30,31,32,33

  List of cgroups to which this job is assigned:

  11:pids:/system.slice/slurmd.service
  10:net_prio,net_cls:/
  9:memory:/slurm/uid_2179/job_11811379/step_0/task_0
  8:devices:/system.slice/slurmd.service
  7:hugetlb:/
  6:freezer:/slurm/uid_2179/job_11811379/step_0
  5:cpuset:/slurm/uid_2179/job_11811379/step_0
  4:blkio:/system.slice/slurmd.service
  3:cpuacct,cpu:/slurm/uid_2179/job_11811379/step_0/task_0
  2:perf_event:/
  1:name=systemd:/system.slice/slurmd.service

  What processor cores/threads are assigned to this job: pid 35323 current affinity list: 24-33

  What SLURM environment variables say about allocated CPUS:
  SLURM_CPUS_ON_NODE=10
  SLURM_JOB_CPUS_PER_NODE=10

  Running threaded Python code:
    program started configured for 1 thread(s)
      sleeping 30 sec from thread 0...
      ...finished sleeping from thread 0
    program completed
  The python script started at Fri Mar 19 11:50:26 EDT 2021
  Adding package `python/3.6.5` to your environment
  10 core(s), 8738128 samples, 199.999878 MiB memory, 0.123430 seconds, 0.010924% error
  The python script ended at Fri Mar 19 11:50:26 EDT 2021
 ~~~~
 {: .language-bash}

Right away we can see that there is a lot more output compared to the serial.qs jobs output.
But looking down at the last few lines we can see that the stats are pretty much the same as the
first serial job that we submitted, but the run time was about 0.02 of a second faster than the
serial job of the same amount of samples. Lets see what happens when we increase the samples 
two more times like we did for the serial script. To do this we will need to increase 
the memory to `--mem-per-cpus=12G` and `--mem-per-cpus=50G`and the pythons calls 
`python3 piMulti.py 81652028` and `python3 piMulti.py 1431652028`. 

After looking at the output of the other two jobs we see that again that the jobs complete faster
than the serial jobs. This is because `piMulti.py` script break up the amount of n_samples so the
calculations of the `inside_circle` function is divided equally on 10 cores. As we can see this 
allows for faster results with similar errors. 

> ## What if we change the amount of cpus-per-tasks?
> 
> What happens to the run time of the script when we increase of decrease the amount of cpus 
> we request when running this script?
> Give it a try! Changes to the number of cores need to be changes in both `thread.qs` and 
> `piMulti.py`.
{: .challenge}


Now we will look if we can get even faster results by submitting a OpenMPI job.

## Running the Parallel Job

We will run an example that uses the Message Passing Interface (MPI) for parallelism &mdash;
this is a common tool on HPC systems.

> ## What is MPI?
> 
> The Message Passing Interface is a set of tools which allow multiple parallel jobs to
> communicate with each other. Typically, a single executable is run multiple times,
> possibly on different machines, and the MPI tools are used to inform each instance of
> the executable about how many instances there are, which instance it is. MPI also
> provides tools to allow communication and coordination between instances.
> An MPI instance typically has its own copy of all the local variables.
{: .callout}

Lets get started by setting up out work environment.
~~~~
 {{ site.host_short_prompt}} lesson-files]$ mkdir mpi
 {{ site.host_short_prompt}} lesson-files]$ cp pi-mpi.py mpi/pi-mpi.py
 {{ site.host_short_prompt}} lesson-files]$ cd mpi
 {{ site.host_short_prompt}} mpi]$ nano pi-mpi.py
 ~~~~
 {: .language-bash}

> ## What's `pi-mpi.py` doing?
>
> One subroutine, `inside_circle`, does all the work. It randomly samples points with both
> *x* and *y* on the half-open interval [0, 1). It then computes their distances from the
> origin (i.e., radii), and returns those values. All of this is done using *vectors* of
> single-precision (32-bit) floating-point values.
>
> The implicitly defined "main" function performs the overhead and accounting work
> required to subdivide the total number of points to be sampled and *partitioning* the
> total workload among the various parallel processors available. At the end, all the
> workers report back to a "rank 0," which prints out the result.
>
> This relatively simple program exercises four important concepts:
>
> * COMM_WORLD: the default MPI Communicator, providing a channel for all the
>   processes involved in this `mpirun` to exchange information with one
>   another.
> * Scatter: A collective operation in which an array of data on one MPI rank
>   is divided up, with separate portions being sent out to the partner ranks.
>   Each partner rank receives data from the matching index of the host array.
> * Gather: The inverse of scatter. One rank populates a local array, with the
>   array element at each index assigned the value provided by the
>   corresponding partner rank &mdash; including the host's own value.
> * Conditional Output: since every rank is running the *same code*, the
>   general `print` statements are wrapped in a conditional so that only one
>   rank does it.
>
{: .discussion}

MPI jobs cannot generally be run as stand-alone executables. Instead, they should be
started with the `mpirun` command, which ensures that the appropriate run-time support for
parallelism is included.

To help optimize MPI jobs on the {{ site.host_name }} cluster IT maintains a template jobs script, 
like the `serial.qs` and `threads.qs` for mpi jobs. Use the following directions to
get a copy of `openmpi.qs`.

~~~~
 {{ site.host_short_prompt}} mpi]$ cp /opt/templates/slurm/generic/mpi/openmpi/openmpi.qs
 {{ site.host_short_prompt}} mpi]$ nano openmpi.qs
 ~~~~
 {: .language-bash}

You will notice that the `openmpi.qs` starts with a lot of commented notes and the slurm commands.
As with `serial.qs` and `thread.qs` it is important that you take the time to read them so you get
a complete understanding what `openmpi.qs` is able to do. Towards the bottom of the `openmpi.qs` 
you notice that the `mpirun` command is different from what you would see on most of the HPC
systems. 

**{{ site.host_location }}'s way of running MPI scripts**
~~~~~
# Do standard Open MPI environment setup (networks, etc.)
#
. /opt/shared/slurm/templates/libexec/openmpi.sh

#
# [EDIT] Execute your MPI program
#
${UD_MPIRUN} ./my_mpi_program arg1 "arg2 has spaces" arg3
mpi_rc=$?
~~~~~
{: .language-bash}

 **More Commonly HPC way of running MPI scripts**
~~~~
-l nodes=2:ppn=5:mem=100G

mpirun  ./my_mpi_program arg1 "arg2 has spaces" arg3
~~~~
{: .language-bash}



In general, achieving a better estimate of π requires a greater number of points. Take a
closer look at `inside_circle`: should we expect to get high accuracy on a single
machine?

Probably not. The function allocates two arrays of size *N* equal to the number of points
belonging to this process. Using 32-bit floating point numbers, the memory footprint of
these arrays can get quite large. The default total number &mdash; 8,738,128 &mdash; was
selected to achieve a 100 MB memory footprint. Pushing this number to a billion yields a
memory footprint of 11.2 GB: if your machine has less RAM than that, it will grind
to a halt. If you have 16 GB installed, you won't quite make it to 1&frac12; billion points.

Our purpose here is to exercise the parallel workflow of the cluster, not to optimize the
program to minimize its memory footprint. Rather than push our local machines to the
breaking point (or, worse, the login node), let's give it to a cluster node with more
resources. 

Lets modifyy the submission file, requesting more than one task on a 2 nodes node:

```
{{ site.host_short_prompt}} mpi]$ nano openmpi.qs
```
{: .language-bash}
Make the following changes 
```
... Many lines later...
48 #SBATCH --nodes=2
49 #SBATCH --ntasks=10
50 # SBATCH --tasks-per-node=<nproc-per-node>
51 #
52 # [EDIT] Normally, each MPI worker will not be multithreaded; if each
53 #        worker allows thread parallelism, then alter this value to
54 #        reflect how many threads each worker process will spawn.
55 #
56 #SBATCH --cpus-per-task=1
57 #
58 # [EDIT] All jobs have memory limits imposed.  The default is 1 GB per
59 #        CPU allocated to the job.  The default can be overridden either
60 #        with a per-node value (--mem) or a per-CPU value (--mem-per-cpu)
61 #        with unitless values in MB and the suffixes K|M|G|T denoting
62 #        kibi, mebi, gibi, and tebibyte units.  Delete the space between
63 #        the "#" and the word SBATCH to enable one of them:
64 #
65 #SBATCH --mem=10G
66 # SBATCH --mem-per-cpu=1024M
... Many lines later...
79 # [EDIT] It can be helpful to provide a descriptive (terse) name for
80 #        the job (be sure to use quotes if there's whitespace in the
81 #        name):
82 #
83 #SBATCH --job-name=mpi-pi
... Many lines later...
83 #SBATCH --job-name=mpi-pi
84 #
85 # [EDIT] The partition determines which nodes can be used and with what
86 #        maximum runtime limits, etc.  Partition limits can be displayed
87 #        with the "sinfo --summarize" command.
88 #
89 #SBATCH --partition=standard
... Many lines later...
104 #SBATCH --time=0-00:10:00
105 #
106 #        You can also provide a minimum acceptable runtime so the scheduler
107 #        may be able to run your job sooner.  If you do not provide a
108 #        value, it will be set to match the maximum runtime limit (discussed
109 #        above).
110 #
111 # SBATCH --time-min=0-00:01:00
112 #
113 # [EDIT] By default SLURM sends the job's stdout to the file "slurm-<jobid>.out"
114 #        and the job's stderr to the file "slurm-<jobid>.err" in the working
115 #        directory.  Override by deleting the space between the "#" and the
116 #        word SBATCH on the following lines; see the man page for sbatch for
117 #        special tokens that can be used in the filenames:
118 #
119 #SBATCH --output=%x-%j.out
120 #SBATCH --error=%x-%j.out
... Many lines later...
139 # [EDIT] Do any pre-processing, staging, environment setup with VALET
140 #        or explicit changes to PATH, LD_LIBRARY_PATH, etc.
141 #
142 #vpkg_require openmpi/default
143 vpkg_require python-mpi/3.6.5:20180613
... Many lines later...
243 # [EDIT] Execute your MPI program
244 #
245 #${UD_MPIRUN} ./my_mpi_program arg1 "arg2 has spaces" arg3
246 #mpi_rc=$?
247 #${UD_MPIRUN}  python3 pi-mpi.py
248 mpi_rc=$?

```
{: .output}

Then submit your job. We will use the batch file to set the options,
rather than the command line.

```
{{ site.host_short_prompt}} mpi]$ {{ site.sched_submit }} openmpi.qs
```
{: .language-bash}

As before, use the status commands to check when your job runs. Use `ls` to locate the
output file, and examine it. Is it what you expected?

* How good is the value for &#960;?
* How much memory did it need?
* How much of that memory was used on each node?
> ## What if we change the amount of nodes or ntasks?
> 
> What happens to the run time of the script when we increase of decrease the amount of nodes or ntasks 
> we request when running this script?
> Give it a try! Changes to the number of cores need to be changes in both `openmpi.qs` and 
> `pi-mpi.py`.
{: .challenge}
