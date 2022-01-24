# terraform-for_each
how to use for_each with terraform using

The for_each meta-argument accepts a map or a set of strings, and creates an instance for each item in that map or set.

# How to use this repo
clone and cd into repo
```
git clone https://github.com/ion-training/terraform-for_each.git
```
```
cd terraform-for_each
```

terraform init, plan, apply
```
terraform init
```
```
terraform plan
```
```
terraform apply
```

# How code looks like
main.tf
```
variable filename {
    type = list
    default = [
        "apples.txt",
        "oranges.txt",
        "pears.txt"
    ]
}

resource local_file pet {
    for_each = toset(var.filename)
    filename = each.value
}
```

# Understand the data structure from terraform.tfstate
The state file records the instance of each file and reference it by file name.\
If a file is removed from the list contained in variable filename the other files will not be recreated.
```
$ cat terraform.tfstate 
{
  "version": 4,
  "terraform_version": "1.0.11",
  "serial": 1,
  "lineage": "43b1bd1d-7471-c265-454d-a852df97e468",
  "outputs": {},
  "resources": [
    {
      "mode": "managed",
      "type": "local_file",
      "name": "pet",
      "provider": "provider[\"registry.terraform.io/hashicorp/local\"]",
      "instances": [
        {
          "index_key": "apples.txt",   <<< ------ index_key is the file name
          "schema_version": 0,
          "attributes": {
            "content": null,
            "content_base64": null,
            "directory_permission": "0777",
            "file_permission": "0777",
            "filename": "apples.txt",
            "id": "da39a3ee5e6b4b0d3255bfef95601890afd80709",
            "sensitive_content": null,
            "source": null
          },
          "sensitive_attributes": [],
          "private": "bnVsbA=="
        },
        {
    --------------    OUTPUT OMITTED FOR BREVITY ------------
```

# Sample output
```
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/local...
- Installing hashicorp/local v2.1.0...
- Installed hashicorp/local v2.1.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # local_file.pet["apples.txt"] will be created
  + resource "local_file" "pet" {
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "apples.txt"
      + id                   = (known after apply)
    }

  # local_file.pet["oranges.txt"] will be created
  + resource "local_file" "pet" {
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "oranges.txt"
      + id                   = (known after apply)
    }

  # local_file.pet["pears.txt"] will be created
  + resource "local_file" "pet" {
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "pears.txt"
      + id                   = (known after apply)
    }

Plan: 3 to add, 0 to change, 0 to destroy.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run
"terraform apply" now.
$ terraform apply 

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # local_file.pet["apples.txt"] will be created
  + resource "local_file" "pet" {
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "apples.txt"
      + id                   = (known after apply)
    }

  # local_file.pet["oranges.txt"] will be created
  + resource "local_file" "pet" {
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "oranges.txt"
      + id                   = (known after apply)
    }

  # local_file.pet["pears.txt"] will be created
  + resource "local_file" "pet" {
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "pears.txt"
      + id                   = (known after apply)
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

local_file.pet["apples.txt"]: Creating...
local_file.pet["pears.txt"]: Creating...
local_file.pet["oranges.txt"]: Creating...
local_file.pet["pears.txt"]: Creation complete after 0s [id=da39a3ee5e6b4b0d3255bfef95601890afd80709]
local_file.pet["apples.txt"]: Creation complete after 0s [id=da39a3ee5e6b4b0d3255bfef95601890afd80709]
local_file.pet["oranges.txt"]: Creation complete after 0s [id=da39a3ee5e6b4b0d3255bfef95601890afd80709]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
$ cat terraform.tfstate 
{
  "version": 4,
  "terraform_version": "1.0.11",
  "serial": 1,
  "lineage": "43b1bd1d-7471-c265-454d-a852df97e468",
  "outputs": {},
  "resources": [
    {
      "mode": "managed",
      "type": "local_file",
      "name": "pet",
      "provider": "provider[\"registry.terraform.io/hashicorp/local\"]",
      "instances": [
        {
          "index_key": "apples.txt",
          "schema_version": 0,
          "attributes": {
            "content": null,
            "content_base64": null,
            "directory_permission": "0777",
            "file_permission": "0777",
            "filename": "apples.txt",
            "id": "da39a3ee5e6b4b0d3255bfef95601890afd80709",
            "sensitive_content": null,
            "source": null
          },
          "sensitive_attributes": [],
          "private": "bnVsbA=="
        },
        {
          "index_key": "oranges.txt",
          "schema_version": 0,
          "attributes": {
            "content": null,
            "content_base64": null,
            "directory_permission": "0777",
            "file_permission": "0777",
            "filename": "oranges.txt",
            "id": "da39a3ee5e6b4b0d3255bfef95601890afd80709",
            "sensitive_content": null,
            "source": null
          },
          "sensitive_attributes": [],
          "private": "bnVsbA=="
        },
        {
          "index_key": "pears.txt",
          "schema_version": 0,
          "attributes": {
            "content": null,
            "content_base64": null,
            "directory_permission": "0777",
            "file_permission": "0777",
            "filename": "pears.txt",
            "id": "da39a3ee5e6b4b0d3255bfef95601890afd80709",
            "sensitive_content": null,
            "source": null
          },
          "sensitive_attributes": [],
          "private": "bnVsbA=="
        }
      ]
    }
  ]
}
$
```
