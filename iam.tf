resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.product}.${var.environment}-ec2-profile"
  role = "${aws_iam_role.ec2_role.name}"
  tags = local.common_tags
}

resource "aws_iam_role_policy" "iam" {
  name = "test_policy"
  role = aws_iam_role.iam.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:*",
          "logs:*",
          "ssm:*",
          "kms:Decrypt",
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "iam" {
  name = "test_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:*",
          "logs:*",
          "ssm:*",
          "kms:Decrypt",
          "secretsmanager:GetSecretValue"
        ]
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      },
    ]
  })
}