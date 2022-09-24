## Setting up local Kubernetes cluster  using MiniKube

Minikube is an excellent way to run Kubernetes (k8s) on your local machine. It creates a single node k8s cluster without requiring much time and resources.

#### Pre-requisite:
```
2 CPUs
2GB RAM
20GB HDD
Internet connection
Container or virtual machine manager, such as: Docker or VirtualBox
```
#### Install Minikube
To install the latest minikube stable release on x86-64 macOS:
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
sudo install minikube-darwin-amd64 /usr/local/bin/minikube
```

#### Start your cluster
From a terminal with administrator access (but not logged in as root), run
```
minikube start
```

#### Interact with your cluster
If you already have kubectl installed, you can now use it to access your cluster
```
kubectl get po -A
```
Alternatively, minikube can download the appropriate version of kubectl and you should be able to use it
```
minikube kubectl -- get po -A
```
We would recommend you to add an alias
```
alias kubectl="minikube kubectl --"
```

To gain additional insight into the cluster state; minikube bundles the k8s dashboard. This will enable you to understand your new k8s environment
```
minikube dashboard
```

#### Deploy applications
Create a sample deployment and expose it on port 8080
```
kubectl create deployment new-minikube --image=k8s.gcr.io/echoserver:1.4
kubectl expose deployment new-minikube --type=NodePort --port=8080
```
It may take a moment for your deployment to show up when you run:
```
kubectl get services new-minikube
```
The easiest way to access this service is to let minikube launch a web browser for you:
```
minikube service new-minikube
```
Alternatively, use kubectl to forward the port:
```
kubectl port-forward service/new-minikube 7080:8080
```
Your application is now available at http://localhost:7080/.

#### LoadBalancer deployments 
To access a LoadBalancer deployment, use the “minikube tunnel” command. Here is an example deployment:
```
kubectl create deployment balanced --image=k8s.gcr.io/echoserver:1.4  
kubectl expose deployment balanced --type=LoadBalancer --port=8080
```
In another window, start the tunnel to create a routable IP for the ‘balanced’ deployment:
```
minikube tunnel
```
To find the routable IP, run this command and examine the EXTERNAL-IP column:
```
kubectl get services balanced
```
Your deployment is now available at <EXTERNAL-IP>:8080

#### Manage your cluster
Pause Kubernetes without impacting deployed applications:
```
minikube pause
```
Unpause a paused instance:
```
minikube unpause
```
Halt the cluster:
```
minikube stop
```
Increase the default memory limit (requires a restart):
```
minikube config set memory 16384
```
Browse the catalog of easily installed Kubernetes services:
```
minikube addons list
```
Create a second cluster running an older Kubernetes release:
```
minikube start -p aged --kubernetes-version=v1.16.1
```
Delete all of the minikube clusters:
```
minikube delete --all
```


### Known Issues:

#### Issue 1:
```
  💥  initialization failed, will try again: run: /bin/bash -c "sudo env PATH=/var/lib/minikube/binaries/v1.18.0:$PATH kubeadm init --config /var/tmp/minikube/kubeadm.yaml  --ignore-preflight-errors=DirAvailable--etc-kubernetes-manifests,DirAvailable--var-lib-minikube,DirAvailable--var-lib-minikube-etcd,FileAvailable--etc-kubernetes-manifests-kube-scheduler.yaml,FileAvailable--etc-kubernetes-manifests-kube-apiserver.yaml,FileAvailable--etc-kubernetes-manifests-kube-controller-manager.yaml,FileAvailable--etc-kubernetes-manifests-etcd.yaml,Port-10250,Swap,SystemVerification": Process exited with status 1
```

#### Solution 1:
```
    Remove ~/.minikube directory and retry "minikube start"
```





