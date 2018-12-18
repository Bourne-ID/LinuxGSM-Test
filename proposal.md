# LinuxGSM Test Proposal

## Introduction
No-one likes it when things break - from your favourite coffee mug through to applications that have a bad patch release. Given the nature of LinuxGSM - any update to the kernel, dependency or  game server update can cause a dedicated server to break on creation or on update, and at present there is no way to track this apart from a user reporting the issue to the developers of LinuxGSM.  

This project aims to bridge that gap, becoming more responsive when things break either by a code change or by a dependency change. The information collected during the tests will be presented online and can be tracked so Developers of LinuxGSM can investigate issues as they occur, users are aware of any issues to servers and give links to related likes or pull requests. 

## Technical Details
This project aims to automate the downloading, installing, configuring and running of a game server using LinuxGSM. It will also test the standard user scenarios like checking the status of the server, getting debug information and other generally used commands. 

The tests will be performed in a virtualised environment where virtual containers will be created, configured, tested and destroyed using dynamically generated Ansible runbooks on a control server. These runbooks will configure the virtual server with:

 - The OS to test against (Ubuntu, CentOS, Debian, x)
 - The supported OS version
 - The architect type fo the OS (x32 or x64)
 - The dependencies required for installing the relevant game server

The controller will detect when a game server, dependency or OS update has been released and add the relevant tests to an internal message queue. Multiple listeners (scalable) will trigger when a game server requires testing, dynamically generating the relevant Ansible playbook and will control the lifecycle of a test server. 

Development will be done in a mix if Dockerfiles, shell scripts and GoLang. 

A cloud based provider will be required to run these tests, with Linode, vultr, Digital Ocean and UpCloud being identified as possible candidates as they are partners of LinuxGSM. 

Additional consideration will be made to minimise the impact of performing significant numbers of tests - [Cache servers](https://github.com/steamcache/steamcache-dns) will be used to minimise the bandwidth requirements and speed up downloads of game servers, whilst an internal DNS server will automatically route all download traffic to these cache servers. 

![Network Architecture](https://github.com/Bourne-ID/LinuxGSM-Test/raw/master/doc/LinuxGSM%20Test%20Workflow.png)

## Website
The domain checklinuxgsm.net has been created which will host the results and logs of completed tests and will display a filterable table for the user to browse. Details on the last and historic builds will be available either by linking to an external build agent result screen or through a homebrew solution. 

## Project Risks
### Capacity Management and Cache Validation
There is a significant requirement for storage due to the number of game servers and OS dependencies involved to minimise the ingress bandwidth. There is a risk that without invalidating the cache or clearing out old data that the amount of storage required will reach an unsustainable threshold and may affect cache server performance. 

This will be managed by ensuring cache headers are correctly utilised, that invalidating certain parts of the cache will remove the data from storage and that monitoring will be in place to ensure the storage is not filled.
