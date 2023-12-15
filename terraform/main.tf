data "aws_caller_identity" "aws" {}

locals {
  tf_tags = {
    Terraform = true,
    By        = data.aws_caller_identity.aws.arn
  }
}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  namespace   = var.namespace
  stage       = var.environment
  name        = var.name
  delimiter   = "-"
  label_order = ["environment", "stage", "name", "attributes"]
  tags        = local.tf_tags
}

resource "random_string" "unique_bucket_suffix" {
  length  = 8
  special = false
  upper   = false
  numeric = false
}

resource "aws_iam_user" "user" {
  name = "prometheus-grafana"
  tags = module.label.tags
}

resource "aws_iam_access_key" "user_key" {
  user    = aws_iam_user.user.name
}

resource "aws_iam_policy" "grafana_folder_s3_access" {
  name        = "grafana-folder-s3-${var.s3_bucket_name}-access-policy"
  description = "Policy to access a grafana folder in S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
        ],
        Effect = "Allow",
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}/grafana/*"
        ]
      },
      {
        Action = [
          "s3:ListBucket"
        ],
        Effect = "Allow",
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}"
        ]
      },
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
        ],
        Effect = "Deny",
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}/grafana/secret_key"
        ]
      }
    ],
  })

  tags = module.label.tags
}


resource "aws_iam_user_policy_attachment" "user_policy_attach" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.grafana_folder_s3_access.arn
}
