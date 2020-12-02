---
layout: reference
permalink: /reference/
---

## Cheatsheets for Queuing System Quick Reference

* [SLURM](https://slurm.schedmd.com/pdfs/summary.pdf)

## HPC Terminology

{:auto_ids}
Accelerator Node
:    Nodes are equipped with accelerator cards as co-processors, such as gpu nodes or phi nodes.

Beowulf cluster
:   A cluster built from PCs running the Linux operating system. Clusters were already
    well established when Beowulf clusters were first built in the early 1990s. Prior to 
    Beowulf, however, clusters were built with workstations running UNIX. By dropping 
    the cost of cluster hardware, Beowulf clusters dramatically increased access to 
    cluster computing.
 

Central processing unit (CPU)
:   Is the part of a computer which executes software programs. The term is not specific to 
    a particular method of execution: units based on transistors, relays, or vacuum tubes 
    might be considered CPU's. However, for clarity, we will use the term to refer to individual 
    silicon chips, such as Intel's Pentium or AMD's Athlon. Thus, a CPU contains one or more 
    cores, however, an HPC system may contain many CPU's. For example, Kraken contains 
    several thousand AMD Opteron CPU's

Cloud computing
:   Is where one can access a lot of computer power from a desktop or laptop computer, but the
    actual calculation is done remotely on another more powerful server or supercomputer. So 
    replace the word 'cloud' with 'Internet' and the meaning becomes clearer. Cloud computing 
    is where Internet-based resources, such as software and storage, are provided to computers 
    on demand, possibly in a pay-per-use model. It is seen as a way to increase one's computing 
    capacity without investing in new infrastructure or training new personnel.

Cluster
:   A collection of technology components – including servers, networks, and storage – deployed 
    together to form a platform for scientific computation

Compute nodes
:   
    Is the cluster nodes where users run their jobs. Jobs need to be submitted and scheduled a 
    time to run on the nodes through the job scheduler.
       
Cyberinfrastructure
:   First used in 1991 according to Merriam-Webster, the prefix 'cyber' means relating to computers
    or computer networks. So cyberinfrastructure means the combination of computer software, 
    hardware, and other technologies – as well as human expertise – required to support current 
    and future discoveries in science and engineering. Similar to the way a highway infrastructure 
    includes roads, bridges, and tunnels working together to keep vehicles moving, all these 
    components are necessary to keep scientific discovery moving along as well.

Development (dev) nodes
:   
    Are compute nodes that are meant for compliling debugging and testing programs, but not long computation.
    They have similar configuration and environment to computer nodes but often have less resources.
    
Distributed Computing
:   A type of computing in which a computational task is divided into subtasks that execute on a 
    collection of networked computers. The networks are general-purpose networks 
    (LANs, WANs, or the Internet) as opposed to dedicated cluster interconnects.
    

Distributed memory
:   
    A computer system that constructs an address space shared among multiple UEs from physical memory
    subsystems that are distinct and distributed about the system. There may be operating-system and 
    hardware support for the distributed shared memory system, or the shared memory may be implemented 
    entirely in software as a separate middleware layer.

Grid computing
:   
    A grid is an architecture for distributed computing and resource sharing. A grid system is 
    composed of a heterogeneous collection of resources connected by local-area and/or wide-area 
    networks (often the Internet). These individual resources are general and include compute servers, 
    storage, application servers, information services, or even scientific instruments. Grids are 
    often implemented in terms of Web services and integrated middleware components that provide a 
    consistent interface to the grid. A grid is different from a cluster in that the resources in a 
    grid are not controlled through a single point of administration; the grid middleware manages the 
    system so control of resources on the grid and the policies governing use of the resources remain 
    with the resource owners. 

Grid Engine
:    
    Is a cluster management software which manages access, reports usage and enforce business policies 
    for a compute cluster. Grid Engine is the cluster management software on Farber.

High-Performance Computing (HPC)
:   
    Is the term often used for large-scale computers and the simulations and models which run on them. 
    
Infiniband
:   
    Is a high-speed, low-latency network that connects all compute nodes to each other and to data 
    storage. This network is sometimes referred to as a fabric. It enables independent compute nodes to 
    communicate with each other much faster than a traditional network, enabling computational jobs that 
    span multiple servers to operate more efficiently, often through a technology known as Message 
    Passing Interface (MPI). 

Job
:   
    A request from a user for computational resources from the cluster.

Node
:   
    A common term for the computational elements that make up a distributed-memory parallel machine. 
    Each node has its own memory and at least one processor; that is, a node can be a uniprocessor or 
    some type of multiprocessor. 

Parallel File System
:    
    A file system that is visible to any processor in the system and can be read and written by multiple 
    UEs simultaneously. Although a parallel file system appears to the computer system as a single file 
    system, it is physically distributed among a number of disks. To be effective, the aggregate throughput
    for read and write must be scalable. 

Parallel processing 
:   
    Is the use of multiple processors running on different parts of the same computer program concurrently,
    resulting in significantly faster compute times. Parallel processing is used when many complex 
    calculations are required, such as in climate or earthquake modeling. Processing "runs" that used to 
    take months can often be done within days or even hours on larger supercomputers.

Preemption
:   
    The act of "stopping" one or more "low-priority" jobs to let a "high-priority" job run.

Scratch space
:   
    Supercomputers generally have what is called scratch space; disk space available for 
    temporary use. It is analogous to scratch paper. This may be thought of as a desk, 
    it is where papers are stored while they are waiting to be worked on or filed away.

Serial Processing
:    Execution of a program sequentially, one statement at a time. 

Shared memory
:    
    A term applied to both hardware and software indicating the presence of a memory region that is 
    shared between system components. For programming environments, the term means that memory is shared 
    between processes or threads. Applied to hardware, it means that the architectural feature tying 
    processors together is shared memory.

Slurm
:    
    Is an open source, fault-tolerant, and highly scalable cluster management and job scheduling system 
    for large and small Linux clusters. Slurm is the cluster management software used on Caviness and 
    will be used on Darwin.
    

Supercomputer
:    
     Is a very fast computer. Usually the term is reserved for the 500 fastest computers in the world. 
     Because technology moves rapidly, the list of top supercomputers changes constantly, and today's 
     supercomputer is destined to become tomorrow's "regular" computer. Modern supercomputers are made up 
     of many smaller computers – sometimes thousands of them – connected via fast local network connections.
     Those smaller computers work as an "army of ants" to solve difficult calculations very fast to benefit 
     science and society. A supercomputer is typically used for solving larger scientific or engineering 
     challenges in numerous fields, such as new drug development and medical research, environmental 
     sciences such as global climate change, or helping us better respond to natural or man-made disasters 
     by creating earthquake simulations or modeling the projected flow of oil spills.

Workstation
:   
    A computer used for tasks such as programming, engineering, and design.


## Glossary

{:auto_ids}
absolute path
:   
    A [path](#path) that refers to a particular location in a file system.
    Absolute paths are usually written with respect to the file system's
    [root directory](#root-directory),
    and begin with either "/" (on Unix) or "\\" (on Microsoft Windows).
    See also: [relative path](#relative-path).

argument
:   
    A value given to a function or program when it runs.
    The term is often used interchangeably (and inconsistently) with [parameter](#parameter).

command shell
:   
    See [shell](#shell)

command-line interface
:   
    A user interface based on typing commands,
    usually at a [REPL](#read-evaluate-print-loop).
    See also: [graphical user interface](#graphical-user-interface).

comment
:   
    A remark in a program that is intended to help human readers understand what is going on,
    but is ignored by the computer.
    Comments in Python, R, and the Unix shell start with a `#` character and run to the end of the line;
    comments in SQL start with `--`,
    and other languages have other conventions.


current working directory
:   
    The directory that [relative paths](#relative-path) are calculated from;
    equivalently,
    the place where files referenced by name only are searched for.
    Every [process](#process) has a current working directory.
    The current working directory is usually referred to using the shorthand notation `.` (pronounced "dot").

file system
:   
    A set of files, directories, and I/O devices (such as keyboards and screens).
    A file system may be spread across many physical devices,
    or many file systems may be stored on a single physical device;
    the [operating system](#operating-system) manages access.

filename extension
:   
    The portion of a file's name that comes after the final "." character.
    By convention this identifies the file's type:
    `.txt` means "text file", `.png` means "Portable Network Graphics file",
    and so on. These conventions are not enforced by most operating systems:
    it is perfectly possible (but confusing!) to name an MP3 sound file `homepage.html`.
    Since many applications use filename extensions to identify the [MIME type](#mime-type) of the file,
    misnaming files may cause those applications to fail.

filter
:   
    A program that transforms a stream of data.
    Many Unix command-line tools are written as filters:
    they read data from [standard input](#standard-input),
    process it, and write the result to [standard output](#standard-output).

flag
:   
    A terse way to specify an option or setting to a command-line program.
    By convention Unix applications use a dash followed by a single letter,
    such as `-v`, or two dashes followed by a word, such as `--verbose`,
    while DOS applications use a slash, such as `/V`.
    Depending on the application, a flag may be followed by a single argument, as in `-o /tmp/output.txt`.

for loop
:   
    A loop that is executed once for each value in some kind of set, list, or range.
    See also: [while loop](#while-loop).

FTP
:   
    A protocol or utility which is used to transfer over a network connection. For security, user SFTP.

graphical user interface
:   
    A user interface based on selecting items and actions from a graphical display,
    usually controlled by using a mouse.
    See also: [command-line interface](#command-line-interface).

home directory
:   
    The default directory associated with an account on a computer system.
    By convention, all of a user's files are stored in or below her home directory.


Linux
:   
    Linux is an operating system, similar to UNIX, which is becoming quite popular for supercomputers due
    to abundant support, user familiarity, and comparable performance with optimized UNIX systems. 
    Kraken, for example, runs on a modified version of Linux.

loop
:   
    A set of instructions to be executed multiple times. Consists of a [loop body](#loop-body) and (usually) a
    condition for exiting the loop. See also [for loop](#for-loop) and [while loop](#while-loop).

loop body
:   
    The set of statements or commands that are repeated inside a [for loop](#for-loop)
    or [while loop](#while-loop).

MIME type
:   
    MIME (Multi-Purpose Internet Mail Extensions) types describe different file types for exchange on the Internet,
    for example images, audio, and documents.

operating system
:   
    Software that manages interactions between users, hardware, and software [processes](#process). Common
    examples are Linux, macOS, and Windows.

orthogonal
:   
    To have meanings or behaviors that are independent of each other.
    If a set of concepts or tools are orthogonal,
    they can be combined in any way.

parameter
:   
    A variable named in a function's declaration that is used to hold a value passed into the call.
    The term is often used interchangeably (and inconsistently) with [argument](#argument).

parent directory
:   
    The directory that "contains" the one in question.
    Every directory in a file system except the [root directory](#root-directory) has a parent.
    A directory's parent is usually referred to using the shorthand notation `..` (pronounced "dot dot").

path
:   
    A description that specifies the location of a file or directory within a [file system](#file-system).
    See also: [absolute path](#absolute-path), [relative path](#relative-path).


pipe
:   
    A connection from the output of one program to the input of another.
    When two or more programs are connected in this way, they are called a "pipeline".

process
:   
    A running instance of a program, containing code, variable values,
    open files and network connections, and so on.
    Processes are the "actors" that the [operating system](#operating-system) manages;
    it typically runs each process for a few milliseconds at a time
    to give the impression that they are executing simultaneously.


prompt
:   
    A character or characters display by a [REPL](#read-evaluate-print-loop) to show that
    it is waiting for its next command.

quoting
:   
    (in the shell):
    Using quotation marks of various kinds to prevent the shell from interpreting special characters.
    For example, to pass the string `*.txt` to a program,
    it is usually necessary to write it as `'*.txt'` (with single quotes)
    so that the shell will not try to expand the `*` wildcard.

read-evaluate-print loop
:   
    (REPL): A [command-line interface](#command-line-interface) that reads a command from the user,
    executes it, prints the result, and waits for another command.

redirect
:   
    To send a command's output to a file rather than to the screen or another command,
    or equivalently to read a command's input from a file.

regular expression
:   
    A pattern that specifies a set of character strings.
    REs are most often used to find sequences of characters in strings.

relative path
:   
    A [path](#path) that specifies the location of a file or directory
    with respect to the [current working directory](#current-working-directory).
    Any path that does not begin with a separator character ("/" or "\\") is a relative path.
    See also: [absolute path](#absolute-path).

root directory
:   
    The top-most directory in a [file system](#file-system).
    Its name is "/" on Unix (including Linux and macOS) and "\\" on Microsoft Windows.


shell
:   
    A [command-line interface](#cli) such as Bash (the Bourne-Again Shell)
    or the Microsoft Windows DOS shell
    that allows a user to interact with the [operating system](#operating-system).

shell script
:   
    A set of [shell](#shell) commands stored in a file for re-use.
    A shell script is a program executed by the shell;
    the name "script" is used for historical reasons.

SSH
:   
    A protocol for securely connecting to a remote computer, or also a program which uses this 
    protocol. This connection is generally for a command line interface, but it is possible to 
    use GUI programs through SSH. For more information about how to use SSH, see Access. 

standard input
:   
    A process's default input stream.
    In interactive command-line applications,
    it is typically connected to the keyboard;
    in a [pipe](#pipe),
    it receives data from the [standard output](#standard-output) of the preceding process.


standard output
:   
    A process's default output stream.
    In interactive command-line applications,
    data sent to standard output is displayed on the screen;
    in a [pipe](#pipe),
    it is passed to the [standard input](#standard-input) of the next process.


sub-directory
:   
    A directory contained within another directory.

tab completion
:   
    A feature provided by many interactive systems in which
    pressing the Tab key triggers automatic completion of the current word or command.

UNIX
:   
    UNIX is an operating system first developed in the 1970's. It has gone through a 
    number of incarnations, and still has many popular versions. UNIX has dominated 
    supercomputing for many years, however, the high performance computing community 
    has been increasingly turning to Linux for an operating system.

variable
:   
    A name in a program that is associated with a value or a collection of values.

while loop
:   
    A loop that keeps executing as long as some condition is true.
    See also: [for loop](#for-loop).

wildcard
:   
    A character used in pattern matching.
    In the Unix shell,
    the wildcard `*` matches zero or more characters,
    so that `*.txt` matches all files whose names end in `.txt`.
    
## External references

### Opening a terminal
* [Using the Terminal program on a Macintosh computer](https://services.udel.edu/TDClient/32/Portal/KB/ArticleDet?ID=477)
* [Using X-Windows (X11) and secure shell (SSH) to connect to a remote UNIX 
  server](https://services.udel.edu/TDClient/32/Portal/KB/ArticleDet?ID=477)
* [Using a UNIX/Linux emulator (Cygwin) or Secure Shell (SSH) client (Putty)](http://faculty.smu.edu/reynolds/unixtut/windows.html) 

### Manuals
* [GNU manuals](http://www.gnu.org/manual/manual.html)
* [Core GNU utilities](http://www.gnu.org/software/coreutils/manual/coreutils.html)

### UD Sites 
* [UD Service Portal](https://services.udel.edu/TDClient/32/Portal/Home/)
* [UD IT-RCI](https://sites.udel.edu/research-computing/)
* [UD IT-RCI HPC Documentation Wiki](https://sites.udel.edu/research-computing/)


### Text Editing

* [Nano editor home page](https://www.nano-editor.org/)

  * [Nano tutorial](https://www.howtoforge.com/linux-nano-command/)

* [VIM editor home page](https://www.vim.org/)

  * Vim also has a built-in tutorial. From the bash prompt, type `vimtutor`
    and follow the instructions.

### Helpful Resources
* [Explain Shell](https://explainshell.com/) is a website that can dissect any shell command and any passed options and 
  display helpful information it. 

* [Shell Check](https://shellcheck.net) is a website that will check a shell script for common errors. It can be done by manually typing 
  the script or by uploading a script to the site.