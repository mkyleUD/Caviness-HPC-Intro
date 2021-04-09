---
title: "What is the Caviness Cluster and Why Should You Use it?"
teaching: 25
exercises: 5
questions:
- "What can I expect to learn from this course?"
- "What is the Caviness Cluster and who can use it?"
objectives:
- "Understand the basics about the Caviness Cluster, who are its owners and who can user it."
- "Identify how the Caviness Cluster could benefit your research."
- "Know how Caviness may diff from other High Performance Computing (HPC) Systems but also 
other Clusters Here at Universtiy of Delaware" 
- ""
keypoints:
- "Caviness and HPC systems can be used to do work that would either be impossible or much slower on
  smaller systems."
- "The standard method of interacting with such systems is via a command line interface such as
  Bash."
- "All Cavines user accounts require a sponorship from a investing-entity (stakeholer). The inverting-
   entity provide computer resources to their workgroup members."
---

## What is the  {{ site.host_name }} Cluster?
The  {{ site.host_name }} cluster is named in honor of Jane  {{ site.host_name }}, the former director of Academic Computing
Services at the University of Delaware. In the 1980's, Jane  {{ site.host_name }} led a groundbreaking expansion
of UD's computing resources and network infrastructure that laid the foundation for UD's current
research computing capabilities. 

 {{ site.host_name }} is University of Delaware's third community cluster. It was deployed in July 2018 and 
is a distributed-memory Linux cluster. It is based on a rolling-upgradeable model for expansion and 
replacement of hardware over time. The first generation consists of 126 compute nodes 
(4536 cores, 24.6 TB memory). The nodes are built of Intel “Broadwell” 18-core processors in a 
dual-socket configuration for 36-cores per node. An OmniPath network fabric supports high-speed 
communication and the Lustre filesystem (approximately 200 TB of usable space). Gigabit and 10-Gigabit 
Ethernet networks provide access to additional filesystems and the campus network. The cluster was 
purchased with a proposed 5 year life to the first generation hardware, putting its refresh in the 
April 2023 to June 2023 time period. 

 {{ site.host_name }} is a technical and financial partnership between UD's Information Technologies and UD's 
faculty and researchers who require high-performance computing resources. Faculty and researchers
become financial stakeholders by purchasing HPC resources (based on the cost of one or more compute
nodes) in the cluster. Only stakeholders and the researchers sponsored by a stakeholder may use the
cluster. It is located at UD's Computing Center.


## Why Use The  {{ site.host_name }} Cluster
> ## What do you need?
>
> Talk to your neighbor about your research. How does computing help you do your research? How 
>could more computing help you do more or better research?
{: .challenge}

Frequently, research problems that use computing can outgrow the desktop or laptop computer where
they start:

* A statistics student wants to cross-validate their model. This involves running the model 1000
  times -- but each run takes an hour. Running on their laptop will take over a month!
* A genomics researcher has been using small datasets of sequence data, but soon will be receiving 
  a new type of sequencing data that is 10 times as large. It's already challenging to open the
  datasets on their computer -- analyzing these larger datasets will probably crash it.
* An engineer is using a fluid dynamics package that has an option to run in parallel. So far, they
  haven't used this option on their desktop, but in going from 2D to 3D simulations, simulation 
  time has more than tripled and it might be useful to take advantage of that feature.

In all these cases, what is needed is access to more computers that can be used at the same time.
Luckily, large scale computing systems -- shared computing resources with lots of computers -- like
 {{ site.host_name }} can be use to help with these problems. HPC systems similar to  {{ site.host_name }} can be found at 
many other universities, labs, or through national networks. These resources usually have more 
central processing units(CPUs), CPUs that operate at higher speeds, more memory, more storage, and 
faster connections with other computer systems. They are frequently called "clusters", 
"supercomputers" or resources for "high performance computing" or HPC. In this lesson, we will 
usually use the terminology of HPC and HPC cluster.

Using a cluster often has the following advantages for researchers:

* **Speed.** With many more CPU cores, often with higher performance specs, than a typical laptop 
  or desktop, HPC systems can offer significant speed up.
* **Volume.** Many HPC systems have both the processing memory (RAM) and disk storage to handle 
  very large amounts of data. Terabytes of RAM and petabytes of storage are available for research
  projects.
* **Efficiency.** Many HPC systems operate a pool of resources that are drawn on by a many users. 
  In most cases when the pool is large and diverse enough the resources on the system are used 
  almost constantly.
* **Cost.** Bulk purchasing and government funding means that the cost to the research community for
  using these systems is significantly less than it would be otherwise.
* **Convenience.** Maybe your calculations just take a long time to run or are otherwise
  inconvenient to run on your personal computer. There's no need to tie up your own computer for
  hours when you can use someone else's instead.

This is how a large-scale compute system like a cluster can help solve problems like those listed 
at the start of the lesson.

> ## Thinking ahead
>
> How do you think using a large-scale computing system will be different from using your laptop?
> Talk to your neighbor about some differences you may already know about, and some
> differences or difficulties you imagine you may run into.
{: .challenge}

## On Command Line

Using Caviness like most HPC systems involves the use of a shell through a command line interface 
(CLI) and either specialized software or programming techniques. The shell is a program with the 
special role of having the job of running other programs rather than doing calculations or similar
tasks itself. Whatever the user types, is passed to the shell, which then figures out what commands
to run and orders the computer to execute them. (Note that the shell is called "the shell" because it 
encloses the operating system in order to hide some of its complexity and make it simpler to 
interact with.) The most popular Unix shell is Bash, the Bourne Again SHell (so-called because it's
derived from a shell written by Stephen Bourne). Bash is the default shell on most modern 
implementations of Unix and in most packages that provide Unix-like tools for Windows.


## Requesting A {{site.host_name}} Cluster Account

All {{site.host_name}} user accounts must be sponsored by a 
[{{ site.host_name }} stakeholder](https://docs.hpc.udel.edu/abstract/caviness/account/stakeholders) 
for a particular investing entity. The request for the account **MUST** come from the investing
entity's stakeholder. After a request has been made a member of UD's Research Cyberinfrastructure
team will create the account and add them to the investing entity's workgroup to be able use and 
share {{ site.host_name}}'s resources. 

### {{site.host_name}} Accounts
{{site.host_name}}'s compute nodes are organizationally identified by UD research group names.
A *stakeholder* is a UD researcher who contributed financially to a node's purchase. An *investing-entity* 
consists of the stakeholders who's combined funds to purchase a particular compute node or set of nodes. 
Each investing-entity has a principle *stakeholder* who is the administrative point of contact for its 
compute nodes. For each investing-entity, the principal stakeholder is responsible for establishing 
and enforcing group-use policies for his/her sponsored users. 

There are two types of cluster accounts. *stakeholders* and *sponsored users*. Sponsored users are researchers
having at least one stakeholder willing to share their cluster resources (compute nodes, storage allocations).

### {{site.host_name}} Groups
The cluster groups of which you are a member determine which computing nodes, job queues, and storage 
resources you may use. Each group has a unique descriptive group name (gname). There are two categories 
of group names: class and investing-entity. 

- The class category
:   
    All users belong to the group named everyone. Members of the UD community also belong to the group named 
    ud-user. Non-UD users are members of the group named hpc-guests. Other group names currently include 
    facstaff, students, and stakeholders. 
- The investing-entity category
:   
    Each investing-entity has a unique group name (e.g., nanotech or the principal stakeholder's username) 
    also referred to as 
    [workgroup](https://docs.hpc.udel.edu/abstract/caviness/app_dev/compute_env#using-workgroup-and-directories). 
    The investing-entity's stakeholders and its sponsored users are members of that cluster group. To see the 
    usernames of all members of an investing-entity's group, type the `getent group «investing_entity»` command. 

    For example, the command below will display the username of the it_css members.

    ```
    getent group it_css
    ```
    {: .language-bash}
    ```
    it_css:*:1002:user_1,user_2,user_3,traine
    ```
    {: .output}
    Together, `getent <<investing-entity>>` and `hpc-user-info -a` will let you determine the identities of a cluster's
    group members.
    To get complete infromation regarding the cluster group and member you can use the command `hpc-user-info`. The output of this command will list the cluster's group information (description = stakeholder), along with every member in the workgroup and their account information (Username, Full Name, Email Address).

    ```
    hpc-group-info -a it_css
    ```
    {: .language-bash}
    ```
    
    member = user1; User One; user1@udel.edu
    member = user2; User Two; user2@UDel.Edu
    member = traine; Student Training;
    member = user3; User Three; user3@UDel.Edu
    ```
    {: .output}


## The Rest of this Lesson
This lesson will cover the basic information on how to use the {{site.host_name}} cluster to assist you with your research.
The topics covered will include {{site.host_name}}’s unique software management system, *VALET*. We will also cover 
topics about the use of *slurm* to submit jobs and the best practices for using the cluster’s resources responsibly.
That will include information on {{site.host_name}}’s file systems and compute node types. This lesson will not be 
able to cover everything. For more information about the {{site.host_name}} cluster and all other 
{{site.host_location}} HPC clusters you can visit [UD's HPC Wiki](https://docs.hpc.udel.edu). 


{% include links.md %}
