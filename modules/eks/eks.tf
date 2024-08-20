# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "~> 20.0"

#   cluster_name    = "my-cluster"
#   cluster_version = "1.30"

#   #   cluster_endpoint_public_access  = true

#   vpc_id     = aws_vpc.main.id
#   subnet_ids = aws_subnet.private.id

#   # EKS Managed Node Group(s)
#   #   eks_managed_node_group_defaults = {
#   #     instance_types = "m5.large"
#   #   }

#   eks_managed_node_groups = {
#     one = {
#       # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
#       name           = "group-one"
#       ami_type       = "AL2023_x86_64_STANDARD"
#       instance_types = "t3.small"

#       min_size     = 2
#       max_size     = 3
#       desired_size = 2
#     }
#   }


#   # Enable VPC CNI custom networking
#   cluster_addons = [
#     {
#       name   = "vpc-cni"
#       config = jsonencode({ AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG = true })
#       type   = "SELF_MANAGED"
#     }
#   ]
#   # Cluster access entry
#   # To add the current caller identity as an administrator
#   enable_cluster_creator_admin_permissions = true

#   access_entries = {
#     # One access entry with a policy associated
#     example = {
#       kubernetes_groups = []
#       principal_arn     = "arn:aws:iam::123456789012:role/something"

#       policy_associations = {
#         example = {
#           policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
#           access_scope = {
#             namespaces = ["default"]
#             type       = "cluster"
#           }
#         }
#       }
#     }
#   }

#   tags = {
#     Environment = "dev"
#     Terraform   = "true"
#   }
# }

resource "aws_eks_cluster" "main-cluster" {
  name     = "eks-cluster"
  role_arn = aws_iam_role.example.arn

  vpc_config {
    subnet_ids = aws_subnet.private[*].id
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
  ]
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSVPCResourceController" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

# module "irsa-ebs-csi" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
#   version = "5.39.0"

#   create_role                   = true
#   role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
#   provider_url                  = module.eks.oidc_provider
#   role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
#   oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
# }
