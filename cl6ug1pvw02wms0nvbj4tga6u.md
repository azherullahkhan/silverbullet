## Setup Kubernetes Kind Cluster

If your goal is to setup a local development kubernetes cluster for free and really fast "kind" is your solution.
[%https://kind.sigs.k8s.io/docs/user/quick-start/]

I've followed the below steps to have my Kubernetes kind cluster up and running in seconds


Step 1: Clone the below repo to fetch the config file to create the kind cluster


```
git clone git@github.com:azherullahkhan/kindcluster.git

○ → cat ./kindcluster/setup/kind-config.yaml

apiVersion: kind.x-k8s.io/v1alpha4
kind: Cluster
networking:
  apiServerAddress: "0.0.0.0"

nodes:
  - role: control-plane
    image: "kindest/node:v1.20.7@sha256:cbeaf907fc78ac97ce7b625e4bf0de16e3ea725daf6b04f930bd14c67c671ff9"
  - role: worker
    image: "kindest/node:v1.20.7@sha256:cbeaf907fc78ac97ce7b625e4bf0de16e3ea725daf6b04f930bd14c67c671ff9"
``` 



Step 2: Run the below kind create command to create the kind cluster


```
$ kind create cluster --config ./kindcluster/setup/kind-config.yaml --name testk8s --wait 5m --kubeconfig  $HOME/.kube/config
Creating cluster "testk8s" ...
 ✓ Ensuring node image (kindest/node:v1.20.7) 🖼
 ✓ Preparing nodes 📦 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
 ✓ Joining worker nodes 🚜
 ✓ Waiting ≤ 5m0s for control-plane = Ready ⏳
 • Ready after 4s 💚
Set kubectl context to "kind-testk8s"
You can now use your cluster with:

kubectl cluster-info --context kind-testk8s --kubeconfig $HOME/.kube/config

Have a nice day! 👋
``` 


Step 3: the below command creates the kube config file to access the kubernetes cluster


```
$ kubectl cluster-info --context kind-testk8s --kubeconfig $HOME/.kube/config
Kubernetes master is running at https://0.0.0.0:52594
KubeDNS is running at https://0.0.0.0:52594/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.


$ export KUBECONFIG=$HOME/.kube/config
``` 


Step 4: Run the below command to list the namespaces


```
$ kubectl get namespaces
NAME                 STATUS   AGE
default              Active   3m6s
kube-node-lease      Active   3m9s
kube-public          Active   3m9s
kube-system          Active   3m9s
local-path-storage   Active   3m1s
``` 

### Conclusion:
kind was primarily designed for testing Kubernetes itself, but it has been an excellent tool to test for my local development and CI

