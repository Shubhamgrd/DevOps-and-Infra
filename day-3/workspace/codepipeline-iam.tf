data "aws_caller_identity" "current" {}

locals {
    account_id = data.aws_caller_identity.current.account_id
}

data "aws_iam_policy_document" "codepipeline-policy-document" {
    statement{
        actions = ["cloudwatch:*"]
        resources = ["*"]
        effect = "Allow"
    }
    statement{
        actions = ["codebuild:*"]
        resources = [
          "arn:aws:codebuild:${var.aws_region}:${local.account_id}:project/${var.codebuild_plan_project_name}",
          "arn:aws:codebuild:${var.aws_region}:${local.account_id}:project/${var.codebuild_apply_project_name}"
          ]
        effect = "Allow"
    }
    statement{
        actions = ["codecommit:*"]
        resources = [aws_codecommit_repository.infra-vpc-codecommit-repo.arn]
        //resources = ["arn:aws:codecommit:ap-south-1:521390506014:infra-vpc-repo"]
        effect = "Allow"
    }

    statement{
        actions = ["s3:*"]
        resources = ["${aws_s3_bucket.s3-bucket-backend.arn}/*"]
        //resources = ["arn:aws:s3:::shubham-infra-vpc-backend/*"]
        effect = "Allow"
    }
}

resource "aws_iam_policy" "codepipeline-policy" {
    name = var.codepipeline_policy_name
    path = "/"
    policy = data.aws_iam_policy_document.codepipeline-policy-document.json
}

resource "aws_iam_role" "codepipeline-role" {
  name = var.codepipeline_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codepipeline-policy-attachment" {
    policy_arn  = aws_iam_policy.codepipeline-policy.arn
    role        = aws_iam_role.codepipeline-role.id
}