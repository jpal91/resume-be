terraform {
    required_version = ">= 1.0.11"

    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 3.68.0"
      }
    }

    backend "s3" {
        bucket = "tf-resume-state"
        key = "terraform.tfstate"
        region = "us-east-1"
        encrypt = true
    }
}

provider "aws" {
    region = "us-east-1"

    default_tags {
        tags = {
            Project = "resume"
        }
    }
}

resource "aws_iam_role" "lambda_role" {
    name = "Lambda_Function_Role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Action = "sts:AssumeRole",
                Principal = {
                    Service = "lambda.amazonaws.com"
                },
                Effect = "Allow",
                Sid = ""
            }
        ]
    })
}

resource "aws_iam_policy" "lambda_iam_policy" {
    name = "aws_iam_lambda_role"
    path = "/"
    description = "IAM Policy for managing aws lambda role"

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Action = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                Resource = "arn:aws:logs:*:*:*",
                Effect = "Allow"
            },
            {
                Action = [
                    "dynamodb:*"
                ],
                Resource = "*",
                Effect = "Allow"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy" {
    role = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.lambda_iam_policy.arn
}
