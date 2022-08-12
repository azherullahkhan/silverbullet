## Docker Run errors with "No space left on device"

When you try to run the "docker run" command and if you see the following error messages
>  "No space left on device"
```
---------------
2022-03-21 15:11:44 ⌚  azhekhan-mac in ~/OS
→ docker run <image> bash
HOME_DIR : /home/
Error: [Errno 28] No space left on device
Aliasing vim --> vi editor
cp: error writing ‘/home/dirmngr.conf’: No space left on device
cp: failed to extend ‘/home/dirmngr.conf’: No space left on device
---------------
```

Run the following docker command to remove old docker containers, to free up some space
```
---------------
 2022-03-21 15:14:45 ⌚  azhekhan-mac in ~/OS
→ docker rm `docker ps --no-trunc -aq`

d609832fbc8e68fe214e32ecb5aac3aa3f8519d642847cffd3d371f35672451a
91c3246f4ff2f0da2d5f26fa4ad01150d6a9c9050c62af6d64b62e7f999ef921
```