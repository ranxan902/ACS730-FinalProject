# ACS730-Final-Project
## Pre-Requirements

- An AWS account with appropriate permissions for creating resources
- Access to the GitHub repository where the workflow will be established
- Terraform installed locally or configured within any other environment like Cloud9
- Ansible installed locally or configured within any other environment like Cloud9
- Install Python boto3 for successful running of the codes
- Install GitHub and clone the project using the clone command
- Create S3 bucket named "**acs730-final-group1-bucket**" and change all the places where S3 bucket is required

## Steps to Deploy Code

1. **Clone the Repository:**
   ```
   git clone https://github.com/ranxan902/ACS730-FinalProject
   cd ACS730-FinalProject
   ```

2. **Copy SSH key:**
   ```
   cd ACS730-FinalProject/terraform/webserver/
   ssh-keygen -t rsa -f group
   ```

3. **Terraform Configuration:**
   First, navigate to the network directory:
   ```
   cd ~/environment/ACS730-FinalProject/terraform/network
   ```
   Then run the following commands:
   ```
   terraform init
   terraform validate
   terraform plan
   terraform apply
   ```
   Next, navigate to the webserver directory:
   ```
   cd ~/environment/ACS730-FinalProject/terraform/webserver
   ```
   Repeat the same Terraform commands as above.

   **Note:** Before applying the terraform, we used the tag for webserver 3 and 4 as Owner: "**acs730**"

4. **Ansible Configuration:**
   ```
   pip3 install boto3
   python3 -m pip install --user ansible
   cd ~/environment/ansiblefinal
   Replace bucket name in s3playbook.yml
   ansible-playbook -i aws_ec2.yml myplaybook.yml
   cp ~/environment/terraform/webserver/group ~/.ssh/
   chmod 400 ~/.ssh/group
   cd ~/environment/ansiblefinal
   ansible-playbook -i aws_ec2.yml myplaybook.yml
   **Note:** Before using Ansible, we have to upload an image to the S3 bucket manually. The name of the file should be "**demo.png**", which is used in the Ansible configuration.

   #review
