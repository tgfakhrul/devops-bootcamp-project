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

# Create IAM Role
resource "aws_iam_role" "instance" {
  name               = "instance_role"
  path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

# Attach AWS Managed Policy for SSM Access
resource "aws_iam_role_policy_attachment" "ssm" {
  role          = aws_iam_role.instance.name
  policy_arn    = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create Instance Profile
resource "aws_iam_instance_profile" "devops_ssm_profile" {
  name = "devops_ssm_profile"
  role = aws_iam_role.instance.name
}