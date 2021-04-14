---
title: "Software: Development, libaries and Applications"
teaching: 30
exercises: 15
questions:
- "What is VALET?"
- "How do we load and unload software packages?"
- "How do we install software?"
objectives:
- "Learn the basics of VALET."
- "Understand how to load and use a software package."
keypoints:
- "Load software with `valet require <<software_name>>`"
- "Unload software with `valet rollback`"
- "The module system handles software versioning and package conflicts for you automatically."
- "List and load now non-default software versions with valet."
---
On a the {{site.host_name}} like most HPC systems, it is often the case that no software is loaded by
default. If we want to use a software package, we will need to "load" it ourselves.

Before we start using individual software packages, however, we should understand the reasoning
behind this approach. The three biggest factors are:

- software incompatibilities;
- versioning;
- dependencies.

Software incompatibility is a major headache for programmers. Sometimes the presence (or absence) of
a software package will break others that depend on it. Two of the most famous examples are Python 2
and 3 and C compiler versions. Python 3 famously provides a `python` command that conflicts with
the same in Python 2. Software compiled against a newer version of the C libraries and then
used when they are not present will result in a nasty `'GLIBCXX_3.4.20' not found` error, for
instance.

Software versioning is another common issue. A team might depend on a certain package version for
their research project - if the software version was to change (for instance, if a package was
updated), it might affect their results. Having access to multiple software versions allow a set of
researchers to prevent software versioning issues from affecting their results.

Dependencies are when a particular software package (or even a particular version)
depends on having access to another software package (or even a particular version of
another software package). For example, the VASP materials science software may 
depend on having a particular version of the FFTW (Fastest Fourer Transform in the West)
software library available for it to work.

> ## Remember to Join Your Workgroup!
>
> It is best practice to make sure that you join your workgroup before loading any software packages.
> If you load software then join your workgroup the loaded packages will be missing. This is because
> when you join your workgroup you also create a new shell session, and currently when this happens 
> you loaded software packages do not carry over to your new shell. 
{: .prereq}

## VALET Automates Linux Environment Tasks

Here at {{site.host_location}}, we developed VALET. VALET facilitates your use of compilers, libraries, programming tools and
application software. It provides a uniform mechanism for setting up a package's required UNIX 
environment. VALET Automates Linux Environment Tasks is {{site.host_location}}'s solution to 
these problems. Valet -- a recursive acronym  for  VALET  AutomatesLinux  Environment  Tasks  --  is  an 
alternative that strives to be as simple as possible to configure and to  use,  while  
adding  features that are not  present  in  the  *modules* software.

A *module* is a self-contained description of a software package - 
it contains the settings required to run a software packages 
and, usually, encodes required dependencies on other software packages.

There are a number of different environment module implementations commonly
used on HPC systems: the three most common are *module*, *TCL modules* and *Lmod*. The three of
these use similar syntax and the concepts are the same so learning to use one will
allow you to use whichever is installed on the system you are using. Since these are not used 
on {{site.host_name}} they will not be covered in this lesson, we will be focusing only on VALET.

VALET commands set the basic environment for software. This may include the PATH, MANPATH, 
INFOPATH, LDPATH, LIBPATH and LD_LIBRARY_PATH environment variables, compiler flags, software 
directory locations, and license paths. This reduces the need for you to set them or update them
yourself when changes are made to system and application software. For example, you might find 
several versions for a single package name, such as Mathematica/8 and Mathematica/8.0.4. You can even
apply VALET commands to packages that you install or alter its actions by customizing VALET's 
configuration files. Type man valet for instructions or see the VALET software documentation for 
complete details.

The table below shows the basic informational commands for VALET. In subsequent sections, 
VALET commands are illustrated in the contexts of application development (e.g., compiling,
using libraries) and running IT-installed applications. 

| Command | Function |
|-------|--------|
| vpkg_help | VALET help. | 
| vpkg_list | List the packages that have VALET configuration files. |
| vpkg_versions *<<pkgid>>* | List versions available for a single package. |
| vpkg_info *<<pkgid>>* | Show information for a single package (or package version). |
| vpkg_require *<<pkgid>>* | Configure environment for one or more VALET packages. |
| vpkg_devrequire *<<pkgid>>* | Configure environment for one or more VALET packages including software development such as `CPPFLAGS` and 'LDFLAGS`. |
| vpkg_rollback *# or all* | Each time VALET changes the environment, it makes a snapshot of your environment to which it can be return. `vpkg_rollback` attempts to restore the UNIX environment to its previous state.You can specify a number (`#`) to revert one or more prior changes to the environment or `all` to remove all changes. |
| vpkg_history | List the versioned packages that have been added to the environment. |
| man valet | Complete documentation of VALET commands. |

### Listing currently loaded VALET Packages

You can use the `vpkg_history` command to see which packages you currently have loaded
in your environment. If you have no packages are loaded, a blank line will be returned.

```
{{ site.host_prompt }} vpkg_history
```
{: .language-bash}
```
                    #If no packages are loaded a blank line will be returned.
```
{: .output}

### Listing available VALET packages

To see available software packages, use `vpkg_list`

```
{{ site.host_prompt }} vpkg_list
```
{: .language-bash}
```
{% include /snippets/14/module_avail.snip %}
```
{: .output}


## Loading and unloading software

To load a software package, use `vpkg_require`.
In this example we will use Python 3.

Initially, Python 3 is not loaded. 
We can test this by using the `which` command.
`which` looks for programs the same way that Bash does,
so we can use it to tell us where a particular piece of software is stored.

```
{{ site.host_prompt }} which python3
```
{: .language-bash}
```
{% include /snippets/14/which_missing.snip %}
```
{: .output}

We can load the `python3` command with `vpkg_require`:

```
{% include /snippets/14/load_python.snip %}
```
{: .language-bash}
```
{% include /snippets/14/which_python.snip %}
```
{: .output}

So, what just happened?

To understand the output, first we need to understand the nature of the `$PATH` environment
variable. `$PATH` is a special environment variable that controls where a UNIX system looks for
software. Specifically `$PATH` is a list of directories (separated by `:`) that the OS searches
through for a command before giving up and telling us it can't find it. As with all environment
variables we can print it out using `echo`.

```
{{ site.host_prompt }} echo $PATH
```
{: .language-bash}
```
{% include /snippets/14/path.snip %}
```
{: .output}

You'll notice a similarity to the output of the `which` command. In this case, there's only one
difference: the different directory at the beginning. When we ran the `module load` command,
it added a directory to the beginning of our `$PATH`. Let's examine what's there:

```
{% include /snippets/14/ls_dir.snip %}
```
{: .language-bash}
```
{% include /snippets/14/ls_dir_output.snip %}
```
{: .output}

Taking this to it's conclusion, `vpkg_require` will add software to your `$PATH`. To load a 
specific version of a software you can look that up with the `vpkg_versions` command then specify
the version when running the vpkg_require command. Additionally, `vpkg_require ` will also load all
software dependencies.

{% include /snippets/14/depend_demo.snip %}

## Software versioning

So far, we've learned how to load and unload software packages. This is very useful. However, we
have not yet addressed the issue of software versioning. At some point or other, you will run into
issues where only one particular version of some software will be suitable. Perhaps a key bugfix
only happened in a certain version, or version X broke compatibility with a file format you use. In
either of these example cases, it helps to be very specific about what software is loaded.

To see all available versions of a specific software package, use `vpkg_versions <<package_name>>`
This can be done with any software package that is in the `vpkg_list` results. In this example 
we will use *matlab* to see which version are currently available on {{site.host_name}}.

```
{{ site.host_prompt }} vpkg_versions matlab
```
{: .language-bash}

```

Available versions in package (* = default version):

[/opt/shared/valet/2.1/etc/matlab.vpkg_yaml]
matlab    Matlab - The Language Of Technical Computing
  r2018a  Version R2018a
  r2018b  Version R2018b
  r2019a  Version R2019a
* r2019b  Version R2019b
  r2020b  Version R2020b
s
```
{: .output}

> ## What does the * mean? 
> The * means that is the default version that will be loaded if one is not
> specified when using the vpkg_require command.
> 
{: .callout}


> ## Using software packages in scripts
>
> Create a job that can run `python3`. Remember, no software is loaded by default!
> Running a job is just like logging on to the system (you should not assume a module loaded on the
> login node is loaded on a compute node).
{: .challenge}

{% comment %}
This is not something the IT-RCI team suggest users to do. 
> ## Loading a module by default
> 
> Adding a set of `module load` commands to all of your scripts and having to manually load modules
> every time you log on can be tiresome. Fortunately, there is a way of specifying a set of 
> "default  modules" that always get loaded, regardless of whether or not you're logged on or 
> running a job. Every user has two hidden files in their home directory: `.bashrc` and 
> `.bash_profile` (you can see these files with `ls -la ~`). These scripts are run every time you 
> log on or run a job. Adding a `module load` command to one of these shell scripts means that 
> that module will always be loaded. Modify either your `.bashrc` or `.bash_profile` scripts to 
> load a commonly used module like Python. Does your `python3 --version` job from before still 
> need `module load` to run?
{: .challenge}
{% endcomment %}

{% include links.md %}
