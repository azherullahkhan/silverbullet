## Terraform Workspace

Terraform creates a default workspace whenever `terraform init` is run. 


### Use cases for workspaces

`terraform workspaces` helps you to keep separate local or remote states within the same directory for specific resources or multiple environments that you want to manage. 

A typical pattern used "without" workspaces is to create multiple working directories to separate configuration or environments. This results in complexity, dealing with repetition throughout multiple directories where state files, caches and modules exist. 

Hence, using `terraform workspaces` for state management can help keep Terraform code clean by reusing the same HCL from a single directory.


### Managing Terraform workspaces

The `terraform workspace` command will be used to create and manage workspaces. 

```
.
├── infrastructure
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf

```

### Below are some the workspace commands:


#### terraform workspace new

From a dedicated working directory we will create a workspace layout by executing the workspace new command. Consequently, this will create development, production and staging workspaces.

```
terraform workspace new dev
terraform workspace new prod
terraform workspace new stage

```

#### terraform workspace list

You may have noticed that creating a new workspace switched you directly into that created workspaces context. You can view the workspaces in your working directory with the workspace list command. 

```
terraform workspace list
  default
  dev
  prod
* stage

```
The asterisk `*` represents the current workspace context.

#### terraform workspace select

To switch workspaces use the `terraform workspace select` command.

Switch to the dev workspace:

```
terraform workspace select dev
Switched to workspace "dev".

```

#### terraform workspace show

`terraform workspace show` will display the currently selected workspace.

```
terraform workspace show
dev

```

#### terraform workspace delete

`terraform workspace delete` removes an existing workspace.

```
terraform workspace delete stage
Deleted workspace "stage"!

```
Terraform will not allow you to delete a workspace if it contains active state or is your current workspace. If you have infrastructure deployed you will get a warning when attempting to delete that workspace. If you want to leave your infrastructure in place and delete the workspace you can use the -force flag.

```
terraform workspace delete dev
Workspace "dev" is not empty.

Deleting "dev" can result in dangling resources: resources that
exist but are no longer manageable by Terraform. Please destroy
these resources first.  If you want to delete this workspace
anyway and risk dangling resources, use the '-force' flag.

```

