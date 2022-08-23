## Setup Traefik Ingress Controller

To setup Traefik Ingress Controller locally follow the below steps:

1. Setup a kind cluster (follow the below article)
%[https://azhercan.com/setup-kubernetes-kind-cluster]
2. Install Helm Package Manager
%[https://helm.sh/docs/intro/install/]
Run below command to confirm the helm version
```
helm version
version.BuildInfo{Version:"v3.3.4", GitCommit:"a61ce5633af99708171414353ed49547cf05013d", GitTreeState:"clean", GoVersion:"go1.14.9"}
```
3. Add official helm repo for Traefik 
```
helm repo add traefik https://helm.traefik.io/traefik
helm repo update
```
4. Create 'traefik' Namespace
``` 
kubectl create namespace traefik
namespace/traefik created
```
5. Helm Install Traefik Charts
To configure the Traefik Helm chart, you can specify certain [values](https://github.com/traefik/traefik-helm-chart/blob/master/traefik/values.yaml). 
For more details on configuration, please review the [Traefik docs](https://doc.traefik.io/traefik/reference/dynamic-configuration/file/).
```
 helm install --namespace=traefik --set="additionalArguments={--log.level=DEBUG}" traefik traefik/traefik
NAME: traefik
LAST DEPLOYED: Tue Aug 23 10:43:09 2022
NAMESPACE: traefik
STATUS: deployed
REVISION: 1
TEST SUITE: None
```
Run k8s command to review the install
```
kubectl get all -n traefik
NAME                          READY   STATUS    RESTARTS   AGE
pod/traefik-7775d6554-lnnbs   1/1     Running   0          40s
NAME              TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
service/traefik   LoadBalancer   10.96.130.104   <pending>     80:31306/TCP,443:30216/TCP   40s
NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/traefik   1/1     1            1           40s
NAME                                DESIRED   CURRENT   READY   AGE
replicaset.apps/traefik-7775d6554   1         1         1       40s
```
6. Expose the Traefik dashboard
You can access the traefik dashboard through port forwarding 
```
 kubectl port-forward $(kubectl get pods --selector "app.kubernetes.io/name=traefik" --output=name -n traefik) 9000:9000 -n traefik
Forwarding from 127.0.0.1:9000 -> 9000
Forwarding from [::1]:9000 -> 9000
Handling connection for 9000
Handling connection for 9000
Handling connection for 9000
Handling connection for 9000
Handling connection for 9000
Handling connection for 9000
```
Once done, You can access the Traefik Dashboard via: http://127.0.0.1:9000/dashboard/
![image.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1661232222241/_62GgA5BH.png align="left")


Reference:
- https://helm.sh/docs/intro/install/
- https://doc.traefik.io/traefik/getting-started/install-traefik/
