# Cloud-Design

![Infrastructure Diagram](<img/Screenshot from 2024-09-27 14-16-28.png>)

## Credits

Anton
Karlutska

## Prerequisites

1. Amazon account
2. Terraform
3. AWS CLI (connected to your account)
4. kubectl (see https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html to set up your kubectl to work with your cloud)
5. Docker

## Project structure

The project consists of 3 micro services, API gateway (which routes the traffic to each app), billing-app (which handles everything billing related), movies-app (which handles everything movies related). Our project also has RabbitMQ and 2 postgres instances. All of the services run in Docker containers which only have the bare minimum software to run all the apps inorder to provide easier scalability and lower costs.

The project leverages EKS (AWS Elastic Kubernetes service) for microservice deployment and scaling across multiple AZs (Availability Zones) for high availability. The use of API Gateway, Route 53, and ALB allows efficient handling of both internal and external traffic. Terraform and Helm simplify infrastructure management, while CloudWatch ensures comprehensive monitoring. Each component, including databases and messaging via RabbitMQ, is optimized for redundancy and fault tolerance.

This architecture exemplifies best practices in cloud-native, microservices-based applications, balancing security, scalability, and maintainability that we could build in our first actual cloud based project.

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
terraform apply --var-file=vars/stage.tfvars
```
After applying the terraform you will need to spin up the kubernetes clusters by running the following command(ensure you are in root folder and have kubectl set up)
```bash
kubectl apply -f ./manifests
```

### End result
![kubernetes running](<img/Screenshot_from_2024-09-27_01-07-37.png>)

## Answers to audit questions

#### What is the cloud and its associated benefits?

- "The cloud" refers to the use of remote servers hosted on the internet to store, manage, and process data, as opposed to local servers or personal computers.

#### Why is deploying the solution in the cloud preferred over on-premises?

- Instead of purchasing and maintaining physical hardware, cloud platforms offer a pay-as-you-go model. Cloud platforms also support automation tools for managing infrastructure, such as Infrastructure as Code (IaC) using tools like Terraform or AWS CloudFormation. Cloud providers offer highly available infrastructure by distributing applications across multiple regions and availability zones, ensuring minimal downtime.

#### How would you differentiate between public, private, and hybrid cloud?

- The public cloud is a cloud environment provided by third-party vendors over the internet and shared among multiple organizations like AWS, Azure, and Google Cloud Platform. A private cloud is a cloud infrastructure that is dedicated to a single organization. The hybrid cloud combines both public and private cloud environments, allowing data and applications to move between them as needed.

#### What drove your decision to select AWS for this project, and what factors did you consider?

- It was in the project requirements. Also, AWS is one of the most popular and widely used cloud platforms. Having knowledge and experience with AWS will definitely prove useful in the future.

#### Can you describe your microservices application's AWS-based architecture and the interaction between its components?

- Our AWS-based architecture leverages EKS for microservice deployment across multiple AZs within a VPC, ensuring high availability and scalability. The use of API Gateway, Route 53, and ALB allows efficient handling of both internal and external traffic. Terraform and Helm simplify infrastructure management, while CloudWatch ensures comprehensive monitoring.

#### How did you manage and optimize the cost of your AWS solution?

- Our main objective was to implement everything within AWS’s free tier and ensure everything worked. After that, we gradually started adding more components, keeping an eye on costs as we ran the project.

#### What measures did you implement to ensure application security on AWS, and what AWS security best practices did you adhere to?

- We used a Certificate Manager and NAT gateways in public subnets with corresponding route tables set to communicate only outwards, ensuring secure communication with the internet. We also made sure that each microservice interacted only with its respective database and used encoded environment variables (secrets) to ensure that sensitive information remained secure.

#### What AWS monitoring and logging tools did you utilize, and how did they assist in identifying and troubleshooting application issues?

- Amazon CloudWatch is integrated into the architecture to monitor the performance of our EKS cluster, track metrics from the microservices, and generate logs. This helps with real-time performance monitoring and troubleshooting. A metrics server is also present to collect resource metrics (CPU, memory) from the Kubernetes cluster for auto-scaling and monitoring.

#### Can you describe the AWS auto-scaling policies you implemented and how they help your application accommodate varying workloads?

- We scaled our applications based on CPU usage. Each time the average CPU usage hit 60%, a new replica of the application was created. This ensures that our application scales according to demand, ensuring a smooth experience.

#### How did you optimize Docker images for each microservice, and how did it influence build times and image sizes?

- The Docker images were created on a minimal Alpine Linux base, using only the absolutely necessary tools and dependencies required to run the applications, databases, and queues. This reduced image size and build time.

#### If you had to redo this project, what modifications would you make to your approach or the technologies you used?

- Overall, the setup is satisfactory. However, it would be more optimal to use the NGINX Ingress Controller instead of K8s Ingress for incoming traffic and AWS ALB (Application Load Balancer [Layer 7]) for outgoing traffic. It would be faster since it would employ NLB (Network Load Balancer [Layer 4]).

#### How can your AWS solution be expanded or altered to cater to future requirements like adding new microservices or migrating to a different cloud provider?

- Adding new microservices would be as simple as creating the service itself and its Kubernetes manifest. Our solution makes it relatively simple to apply the changes by using `kubectl` to make the updates.

#### What challenges did you face during the project and how did you address them?

- The first challenge we faced was setting up permissions to access and manage the AWS cloud environment, as neither of us had done this before. We resolved this by researching and following tutorials to accomplish the task.
    
- The second challenge was setting up `kubectl` for the cloud. While we had used Kubernetes on VMs and local machines, configuring `kubectl` to work with the cloud required setting up credentials and an API to connect to the cloud servers.
    
- The third challenge was determining which AWS services to use from their vast offerings, such as whether to use EKS or ECS. To address this, we researched the benefits of each service and reviewed industry best practices to make the best choice for our project, which was EKS.
    

#### How did you ensure your documentation's clarity and completeness, and what measures did you take to make it easily understandable and maintainable?

- We aimed to keep the documentation as concise as possible while ensuring that no important information was left out.
