# Infrastructure as Code with Terraform
## What is Terraform
### Terraform Architecture
#### Terraform default file/folder structure
##### .gitignore
###### AWS keys with Terraform security

![diagram](https://paradise-devs-media.s3.amazonaws.com/media/django-summernote/2020-02-13/3d4c1893-2a8a-4835-ac3f-fb117a5ce047.png)

**- Terraform commands**
- `terraform init` to initialise Terraform
- `terraform plan` reads script and checks everything. Will let you know of any syntax errors. 
- `terramform apply` implements the script
- `terraform destroy` deletes everything
- `terraform` to list all the commands that we can use with terraform

**- Terraform file/folder structure**
- `.tf` file extensions used in TF - `main.tf`
- To apply properly, implement `DRY` - `Don't Repeat Yourself!`

### Set up AWS as an ENV in windows machine
- `AWS_ACCESS_KEY_ID` for aws access keys
- `AWS_SECRET_ACCESS_KEY` for aws secret keys
- In order to get there, we can click the `windows` key on your keyboard. Enter type `env` and you'll see a pop-up - `edit the system environment variable`
- click on `new` for user variables
- add 2 environment variables 