## Enable DEBUG mode on NGINX Ingress Controller

In order to debug your NGINX ingress controller to investigate issues with your ingress. You need to enable it in DEBUG mode.


To enable the Debug logging, please refer to the following steps:

Login to your Kubernetes cluster where you've your NGINX Ingress controller deployed and execute below commands:
```
# kubectl get ns | grep -i ingress
ingress-nginx          Active   223d
```

Edit the NGINX Ingress controller deployment and add the `--v=X` to the args
```
# kubectl edit deployment nginx-ingress-controller -n ingress-nginx
# Add --v=X to "- args", where X is an integer

--v=2 shows details using diff about the changes in the configuration in nginx
--v=3 shows details about the service, Ingress rule, endpoint changes and it dumps the nginx configuration in JSON format
--v=5 configures NGINX in debug mode
```

Update your NGINX Ingress controller deployment as below:
```
      - args:
        - /nginx-ingress-controller
        - --v=5
        - --publish-service=$(POD_NS)/nginx-ingress-controller
        - --election-id=ingress-controller-leader
        - --ingress-class=nginx-public
        - --configmap=$(POD_NS)/nginx-ingress-controller
```

The NGINX Ingress controller pods will restart and start showing DEBUG Level logs

#### Further Reference
%[https://kubernetes.github.io/ingress-nginx/troubleshooting/]
%[https://github.com/kubernetes/ingress-nginx/issues/1832]
