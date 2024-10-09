# Cloud-Design

![Infrastructure Diagram](<img/Screenshot from 2024-09-27 14-16-28.png>)

## Credits

Anton
Karlutska

## Audit & Video
Video Link[] It contains everything neccesary for audit

01 GitHub audit link [https://github.com/01-edu/public/tree/master/subjects/devops/cloud-design/audit]
for question presented in the audit, please refer to the bottom of the readme.

## Prerequisites

1. Amazon account
2. Terraform
3. AWS cli
4. kubectl (see https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html to set up your kubectl to work with your cloud)
5. Docker

## Running the project
**!!!Warning!!!**

**Attempting to run this project might cost you a bit! Proceed at you own risk!**

To run this project, you will need to have everything listed in the prerequisites list. After that you need to apply the credentials to Terraform inorder to run everything in the cloud. 
First you will need to initialise your terraform by running
```bash
terraform init
```
After the initialisation, plan the changes to the cloud
```bash
terraform plan
```
Applying the project in the cloud.
```bash 
terraform apply
```
After applying the terraform you will need to spin up the kubernetes clusters by running the following command(ensure you are in root folder and have kubectl set up)
```bash
kubectl apply -f ./manifests
```

### End result
![kubernetes running](<img/Screenshot_from_2024-09-27_01-07-37.png>)

## Answers to roleplays suggested questions

What is the cloud and its associated benefits?
- "The cloud" refers to the use of remote servers hosted on the internet to store, manage, and process data, as opposed to local servers or personal computers.

Why is deploying the solution in the cloud preferred over on-premises?
- Instead of purchasing and maintaining physical hardware, cloud platforms offer a pay-as-you-go model. Cloud platforms also support automation tools for managing infrastructure, like Infrastructure as Code (IaC) using tools like Terraform or AWS CloudFormation. Cloud providers offer highly available infrastructure by distributing applications across multiple regions and availability zones, ensuring minimal downtime.

How would you differentiate between public, private, and hybrid cloud?
- The public cloud is a cloud environment provided by third-party vendors over the internet and shared among multiple organizations like AWS, Azure, Google Cloud Platform. A private cloud is a cloud infrastructure that is dedicated to a single organization. The hybrid cloud combines both public and private cloud environments, allowing data and applications to move between them as needed.

What drove your decision to select AWS for this project, and what factors did you consider?
- It in the project requirement, also it is one of the most popular, having knowledge and experience with it will definetly prove useful in the future.

Can you describe your microservices application's AWS-based architecture and the interaction between its components?
- Our AWS-based architecture leverages EKS for microservice deployment across multiple AZs within a VPC, ensuring high availability and scalability. The use of API Gateway, Route 53, and ALB allows efficient handling of both internal and external traffic. Terraform and Helm simplify infrastructure management, while CloudWatch ensures comprehensive monitoring.

How did you manage and optimize the cost of your AWS solution?
- 

What measures did you implement to ensure application security on AWS, and what AWS security best practices did you adhere to?
- We used a certificate manager and gateways in subnets to ensure secure communication. We also made sure that each microservice is only able to interact with its own respective database and used encoded enviormental variables(secrets) to ensure that our sensitive info stays secret. 

What AWS monitoring and logging tools did you utilize, and how did they assist in identifying and troubleshooting application issues?
-  Amazon CloudWatch is integrated into the architecture to monitor the performance of your EKS cluster, track metrics from the microservices, and generate logs. This helps in real-time performance monitoring and troubleshooting. A metrics server is also preset, to collect resource metrics (CPU, memory) from the Kubernetes cluster for auto-scaling and monitoring purposes.

Can you describe the AWS auto-scaling policies you implemented and how they help your application accommodate varying workloads?
- We scaled our applications based on CPU usage of the server, so that every time the average CPU usage hit 60% we create a new replica of our application. Doing this ensures that our application scales according to demand for a smooth experience.

How did you optimize Docker images for each microservice, and how did it influence build times and image sizes?
- The Docker images were created on the most basic alpine linux base only used absolutely neccessary tools/dependencies that were require to run the applications, databases and queues which reduced the image size and build time.

If you had to redo this project, what modifications would you make to your approach or the technologies you used?
- 

How can your AWS solution be expanded or altered to cater to future requirements like adding new microservices or migrating to a different cloud provider?
- Adding microservices will be as easy as creating the service itself and its kubernetes manifest, after that our solution makes it relatively simple to apply the changes by just kubectl to make the changes.

What challenges did you face during the project and how did you address them?
- 

How did you ensure your documentation's clarity and completeness, and what measures did you take to make it easily understandable and maintainable?
- 
