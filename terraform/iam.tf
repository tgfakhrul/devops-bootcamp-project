# Assume Role Policy for EC2
data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# IAM Role for EC2 (SSM)
resource "aws_iam_role" "instance" {
  name               = "devops-ec2-ssm-role"
  path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json

  tags = {
    Name        = "devops-ec2-ssm-role"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

# Attach SSM Managed Policy
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance Profile
resource "aws_iam_instance_profile" "devops_ssm_profile" {
  name = "devops-ssm-instance-profile"
  role = aws_iam_role.instance.name
}

# Add ECR Pull Only policy.
resource "aws_iam_role_policy_attachment" "ec2_ecr_pull_policy" {
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}
