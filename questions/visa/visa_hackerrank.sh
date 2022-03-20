Firstly we would create a ticket to track the "Error X" issue with the application using JIRA and capture the following details from the user, such as:

1.  Environment (realm, region, cluster, namespace)

2. Application name

3. The Pod/Deployment where the "Error X" was seen

4. Capture details such as when was the issue observed and (if possible) steps to reproduce the issue

5. Severity of the issue, we have a SLA contract for the infrastructure that we support. Example Sev-0 will be the severity if the issue was seen in Production

With these details we would look at our Monitoring Systems (Prometheus, Thanos, AlertManager Grafana) to review the overall health of the systems interacting with the Application

If this issue is a Sev-0 we will open a channel and involve the stakeholders (Primary & Secondary On call engineers, application SME , Infrastructure SME)  and we work until the issue is resolved

We quickly verify if this issue was experienced before by looking at our Run books and documentation 

We will look at our Logging Dashboard for the application and review the Application Logs and trace when the issue was observed 

We will next login to the respective Environment (realm, region, cluster, namespace) of the application and review the events in the namespace and describe the Pods and if possible try to reproduce the issue.

Once we have found the cause of the issue and have provided a fix, we perform a RCA (root cause analysis) for the issue and capture the steps taken to resolve the issue in the JIRA incident.

We also raise a JIRA Story to add it to our Product Backlog to automate the resolution or document in Run books to ensure the SRE engineer in the future can resolve such issues by themselves 





Concurrency is a task of running and managing multiple process at the same time. Concurrency is achieved by context switching. An example use case: We use concurrency while deploying using Helm, this gives the ability to run several executions in parallel

Parallelism is a task of running multiple process simultaneously. Parallelism is used to increase the throughput along with the computational speed by leveraging multiple processors. An example use case: we run Jenkins test pipelines in parallel



