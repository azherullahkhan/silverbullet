----------------------------------------------------------------------------------------------------
                                      DOCKER ISSUES
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

Docker ISSUE 1: Docker containers were erroring with "No space left on device" message
---------------
 2022-03-21 15:11:44 ⌚  azhekhan-mac in ~/OS
± |region_rollout {15} U:26 ?:2 ✗| → 
HOME_DIR : /home/
Review: The following Wiki for more setup instructions
Error: [Errno 28] No space left on device
Aliasing vim --> vi editor
cp: error writing ‘/home//.gnupg/dirmngr.conf’: No space left on device
cp: failed to extend ‘/home//.gnupg/dirmngr.conf’: No space left on device
cp: error writing ‘/home//.gnupg/gpg-agent.conf’: No space left on device
---------------
Docker SOLUTION 1: Remove old docker containers
---------------
 2022-03-21 15:14:45 ⌚  azhekhan-mac in ~/OS
± |region_rollout {15} U:26 ?:2 ✗| → docker rm `docker ps --no-trunc -aq`

d609832fbc8e68fe214e32ecb5aac3aa3f8519d642847cffd3d371f35672451a
91c3246f4ff2f0da2d5f26fa4ad01150d6a9c9050c62af6d64b62e7f999ef921

----------------------------------------------------------------------------------------------------





----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
