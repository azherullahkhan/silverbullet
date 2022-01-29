------------------------------------------------------------------------------------------
                                       HELM Rough book
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
    List of Helm Commands
------------------------------------------------------------------------------------------


Use the commands listed below as a quick reference when working with Helm inside Kubernetes.

Install and Uninstall Apps
The main function of Helm is Kubernetes app management. Besides the basic operations of installing and uninstalling apps, 
Helm enables you to perform test installations and customize the installation process to suit your needs.

Install an app:

helm install [name] [chart]
Install an app in a specific namespace:

helm install [name] [chart] --namespace [namespace]
Override the default values with those specified in a file of your choice:

helm install [name] [chart] --values [yaml-file/url]
Run a test install to validate and verify the chart:

helm install [name] --dry-run --debug
Uninstall a release:

helm uninstall [release]
Perform App Upgrade and Rollback
Helm offers users multiple options for app upgrades, such as automatic rollback and upgrading to a specific version. 
Rollbacks can also be executed on their own. For detailed instructions on how to perform a rollback, check out How to Roll Back Changes with Helm.

Upgrade an app:

helm upgrade [release] [chart]
Instruct Helm to rollback changes if the upgrade fails:

helm upgrade [release] [chart] --atomic
Upgrade a release. If it does not exist on the system, install it:

helm upgrade [release] [chart] --install
Upgrade to a specified version:

helm upgrade [release] [chart] --version [version-number]
Roll back a release:

helm rollback [release] [revision]
Download Release Information
The helm get command lets you download information about a release.

Download all the release information:

helm get all [release]
Download all hooks:

helm get hooks [release]
Download the manifest:

helm get manifest [release]
Download the notes:

helm get notes [release]
Download the values file:

helm get values [release]
Fetch release history:

helm history [release] 
Add, Remove, and Update Repositories
The helm command helm repo helps you manipulate chart repositories.

Add a repository from the internet:

helm repo add [name] [url]
Remove a repository from your system:

helm repo remove [name]
Update repositories:

helm repo update
List and Search Repositories
Use the helm repo and helm search commands to list and search Helm repositories.
Helm search also enables you to find apps and repositories in Helm Hub.

List chart repositories:

helm repo list
Generate an index file containing charts found in the current directory:

helm repo index
Search charts for a keyword:

helm search [keyword]
Search repositories for a keyword:

helm search repo [keyword]
Search Helm Hub:

helm search hub [keyword]
Release Monitoring
The helm list command enables listing releases in a Kubernetes cluster according to several criteria, 
including using regular (Pearl compatible) expressions to filter results. 
Commands such as helm status and helm history provide more details about releases.

List all available releases in the current namespace:

helm list
List all available releases across all namespaces:

helm list --all-namespaces
List all releases in a specific namespace:

helm list --namespace [namespace]
List all releases in a specified output format:

helm list --output [format]
Apply a filter to the list of releases using regular expressions:

helm list --filter '[expression]'
See the status of a specific release:

helm status [release]
Display the release history:

helm history [release]
See information about the Helm client environment:

helm env
Note: Learn more about managing Kubernetes cluster namespaces and unwanted or multiple copies of 
Helm deployments by referring to our article How To Delete Helm Deployment And Namespace.

Plugin Management
Install, manage and remove Helm plugins by using the helm plugin command.

Install plugins:

helm plugin install [path/url1] [path/url2] ...
View a list of all installed plugins:

helm plugin list
Update plugins:

helm plugin update [plugin1] [plugin2] ...
Uninstall a plugin:

helm plugin uninstall [plugin]
Chart Management
Helm charts use Kubernetes resources to define an application. 
To find out more about their structure and requirements for their creation, refer to How to Create a Helm Chart.

Create a directory containing the common chart files and directories (Chart.yaml, values.yaml, charts/ and templates/):

helm create [name]
Package a chart into a chart archive:

helm package [chart-path]
Run tests to examine a chart and identify possible issues:

https://helm.sh/docs/helm/helm_template/
helm template [NAME] [CHART] [flags]
# helm template ingress-watcher ingress-watcher

helm lint [chart]
Inspect a chart and list its contents:

helm show all [chart] 
Display the chart’s definition:

helm show chart [chart] 
Display the chart’s values:

helm show values [chart]
Download a chart:

helm pull [chart]
Download a chart and extract the archive’s contents into a directory:

helm pull [chart] --untar --untardir [directory]
Display a list of a chart’s dependencies:

helm dependency list [chart]
Get Help and Version Information
Display the general help output for Helm:

helm --help
Show help for a particular helm command:

helm [command] --help
See the installed version of Helm:

helm version

## helm search -r "chartmuseum/alerts"
## helm plugin install https://github.com/chartmuseum/helm-push.git
## helm repo update
## helm push alerts chartmuseum

# helm plugin install https://github.com/chartmuseum/helm-push.git
# helm push <CHART> chartmuseum
# helm repo update
# helm search -r "chartmuseum/<CHART>"
# helm search repo -l "REPO_NAME"


# $ helm repo list
# $ helm show values bitnami/thanos
# $ helm get values -n NAMESPACE
# helm status CHARTS
# helm ls -n NAMESPACE


# helm ls -n infra-monitoring 
# helm history CHARTNAME -n NAMESPACE

#$ helm diff release -h
# helm diff revision kafka-schema-registry 24 25 -n kafka

------------------------------------------------------------------------------------------
    List of Helmfile Commands
------------------------------------------------------------------------------------------


---------------------------------
Create a helfile repos yaml file:

cat helmfilerepos.yaml
repositories:
# To use official "stable" charts a.k.a https://github.com/helm/charts/tree/master/stable
- name: stable
  url: https://charts.helm.sh/stable
- name: incubator
  url: https://charts.helm.sh/incubator
- name: bitnami
  url: https://charts.bitnami.com/bitnami
- name: hashicorp
  url: https://helm.releases.hashicorp.com
- name: grafana
  url: https://grafana.github.io/helm-charts
- name: ingress-nginx
  url: https://kubernetes.github.io/ingress-nginx
- name: argo
  url: https://argoproj.github.io/argo-helm
- name: banzaicloud-stable
  url: https://kubernetes-charts.banzaicloud.com
- name: prometheus-community
  url: https://prometheus-community.github.io/helm-charts
- name: strimzi
  url: https://strimzi.io/charts
- name: traefik
  url: https://helm.traefik.io/traefik
---------------------------------
Helm Repo Update
$ helmfile -e ENVIRONMENT -f YAML_FILE repos
$ helmfile -e PRE_PROD -f helmfilerepos.yaml repos
$ helmfile -e STAGE -f helmfilerepos.yaml repos
$ helmfile -e DEVL -f helmfilerepos.yaml repos
---------------------------------

helmfile -e dev -f helmfile-namespace.yaml -l name=vault-config-data-pipeline-psr diff --concurrency 7 
helmfile -e dev -f helmfile-namespace.yaml -l region=us-phoenix-1  sync --concurrency 7 
helmfile -e dev -f helmfile-namespace.yaml template
helmfile -e dev -f helmfile-monitoring.yaml destroy

helmfile --log-level debug -e dev -f helmfile-kafka.yaml -n az-kafka-strimzi diff
## IF you get helmfile timeout issue 'context deadline exceeded (Client.Timeout exceeded while awaiting headers)
##  then change concurrency to 1

---------------------------------
                            Helmfile Cheat Sheet

helmfile diff | egrep -A20 -B20 "^.{5}(\-|\+)"

------------------------------------------------------------------------------------------


# helm ls -n infra-monitoring 
# helm history kafka-schema-registry -n <kafka>

#$ helm diff release -h
# helm history kafka-schema-registry -n <kafka>
# helm diff revision kafka-schema-registry 24 25 -n kafka

## Helm on V1
# helm ls --tiller-namespace <CNS>
○ $ helm history NAMESPACE
○ $ helm ls --deployed -q --namespace NAMESPACE
○ $ helm ls --deleted -q --namespace NAMESPACE
○ $ helm delete --purge NAMESPACE
release "NAMESPACE" deleted

# helm version 3
# helm uninstall <deployment>  -n <namespace>
# helm version 2
# helm delete --purge <deployment> 
# helm delete kafka-client --purge --tiller-namespace=<yourNamespace>

-------------------------------------------------------------------------------------------------------------------------------------------------------
                                    Helmfile 
# How to manage Kubernetes Helm releases #
# https://youtu.be/qIJt8Iq8Zb0           #
##########################################
-------------------------------------------------------------------------------------------------------------------------------------------------------
# Referenced videos:
# - K3d - How to run Kubernetes cluster locally using Rancher k3s: https://youtu.be/mCesuGk-Fks

#########
# Setup #
#########

git clone https://github.com/vfarcic/helmfile-demo

cd helmfile-demo

# Please watch https://youtu.be/mCesuGk-Fks if you are not familiar with k3d
# It could be any other k8s cluster with an Ingress controller
k3d cluster create --config k3d.yaml

# Install Helm

# Install `helmfile` from https://github.com/roboll/helmfile#installation

helm plugin install https://github.com/databus23/helm-diff

helm plugin install https://github.com/aslafy-z/helm-git

helm plugin install https://github.com/jkroepke/helm-secrets

##############################
# Defining a simple Helmfile #
##############################

cat helmfile-prometheus.yaml

helmfile \
    --file helmfile-prometheus.yaml \
    apply \
    --wait

#####################
# Updating releases #
#####################

cat helmfile-prometheus-rbac.yaml

helmfile \
    --interactive \
    --file helmfile-prometheus-rbac.yaml \
    apply \
    --wait

helmfile \
    --interactive \
    --file helmfile-prometheus-rbac.yaml \
    destroy

##############################
# Defining multiple-releases #
##############################

cat helmfile-multi.yaml

helmfile \
    --file helmfile-multi.yaml \
    apply \
    --wait

# If not using k3d, change the value to whatever is the base host
export BASE_HOST=localhost

helmfile \
    --file helmfile-multi.yaml \
    --interactive \
    apply \
    --wait

kubectl --namespace production \
    get ingresses

# Open devops-toolkit host

######################
# Applying templates #
######################

cat helmfile-multi.yaml

cat helmfile.yaml

helmfile --interactive apply --wait

#######################
# Destroying releases #
#######################

helmfile destroy

k3d cluster delete helmfile-demo
-------------------------------------------------------------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------------------------------------------------------------
                          Helm template


https://pkg.go.dev/text/template

helm lint is your go-to tool for verifying that your chart follows best practices
helm install --dry-run --debug or helm template --debug: 
helm get manifest: This is a good way to see what templates are installed on the server.


For example, this template snippet includes a template called mytpl, then lowercases the result, then wraps that in double quotes.

value: {{ include "mytpl" . | lower | quote }}

The following example of the required function declares an entry for .Values.who is required, and will print an error message when that entry is missing:

value: {{ required "A valid .Values.who entry required!" .Values.who }}
Quote Strings, Dont Quote Integers
When you are working with string data, you are always safer quoting the strings than leaving them as bare words:

name: {{ .Values.MyName | quote }}

To make it possible to include a template, and then perform an operation on that templates output, Helm has a special include function:

{{ include "toYaml" $value | indent 2 }}


The required function gives developers the ability to declare a value entry as required for template rendering. If the entry is empty in values.yaml, the template will not render and will return an error message supplied by the developer.

For example:

{{ required "A valid foo is required!" .Values.foo }}


Using the 'tpl' Function
The tpl function allows developers to evaluate strings as templates inside a template. This is useful to pass a template string as a value to a chart or render external configuration files. Syntax: {{ tpl TEMPLATE_STRING VALUES }}

Examples:

# values
template: "{{ .Values.name }}"
name: "Tom"

# template
{{ tpl .Values.template . }}

# output
Tom


-------------------------------------------------------------------------------------------------------------------------------------------------------


