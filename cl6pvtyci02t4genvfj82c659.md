## Docker Run errors with "No space left on device"

When you try to run the "docker run" command and if you see the following error messages
>  "No space left on device"

This generally happens when the volume for your Docker engine is full.

```
2022-03-21 15:11:44 ⌚  azhekhan-mac in ~/OS
→ docker run <image> bash
Error: [Errno 28] No space left on device
cp: error writing ‘/home/dirmngr.conf’: No space left on device
cp: failed to extend ‘/home/dirmngr.conf’: No space left on device
```

There are several steps that can be taken to free up some space from the volume.

A quick solution is to run the following docker command to remove old docker containers.

```
 2022-03-21 15:14:45 ⌚  azhekhan-mac in ~/OS
→ docker rm `docker ps --no-trunc -aq`

d609832fbc8e68fe214e32ecb5aac3aa3f8519d642847cffd3d371f35672451a
91c3246f4ff2f0da2d5f26fa4ad01150d6a9c9050c62af6d64b62e7f999ef921
```

Another solution, to free up significant space is to run the docker system prune command. 
This command prunes images, containers, and networks but it never prunes/delete the volumes associated with the docker container

```
 2022-03-21 15:14:45 ⌚  azhekhan-mac in ~/OS
→ docker system prune --all
        - all stopped containers
        - all networks not used by at least one container
        - all dangling images
        - all dangling build cache
```
For more details on docker prune command, refer below link:
* %[https://docs.docker.com/engine/reference/commandline/system_prune/]