resource "aws_iam_role" "ebs_role" {
  name = "${var.project_name}-${var.environment_name}-ebs-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = ["ec2.amazonaws.com", "elasticbeanstalk.amazonaws.com"]
        },
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy" "ebs_policy" {
  name = "${var.project_name}-${var.environment_name}-ebs_role_policy"
  role = aws_iam_role.ebs_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "elasticloadbalancing:DescribeInstanceHealth",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeTargetHealth",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:GetConsoleOutput",
          "ec2:AssociateAddress",
          "ec2:DescribeAddresses",
          "ec2:DescribeSecurityGroups",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:DescribeNotificationConfigurations",
          "sns:Publish"
        ],
        "Resource" : [
          "*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:DescribeLogStreams",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk/*:log-stream:*"
      },
      {
        "Sid" : "ElasticBeanstalkPermissions",
        "Effect" : "Allow",
        "Action" : [
          "elasticbeanstalk:*"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "AllowPassRoleToElasticBeanstalkAndDownstreamServices",
        "Effect" : "Allow",
        "Action" : "iam:PassRole",
        "Resource" : "arn:aws:iam::*:role/*",
        "Condition" : {
          "StringEquals" : {
            "iam:PassedToService" : [
              "elasticbeanstalk.amazonaws.com",
              "ec2.amazonaws.com",
              "ec2.amazonaws.com.cn",
              "autoscaling.amazonaws.com",
              "elasticloadbalancing.amazonaws.com",
              "ecs.amazonaws.com",
              "cloudformation.amazonaws.com"
            ]
          }
        }
      },
      {
        "Sid" : "ReadOnlyPermissions",
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:DescribeAccountLimits",
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeLoadBalancers",
          "autoscaling:DescribeNotificationConfigurations",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:DescribeScheduledActions",
          "ec2:DescribeAccountAttributes",
          "ec2:DescribeAddresses",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeImages",
          "ec2:DescribeInstanceAttribute",
          "ec2:DescribeInstances",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSnapshots",
          "ec2:DescribeSpotInstanceRequests",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcClassicLink",
          "ec2:DescribeVpcs",
          "elasticloadbalancing:DescribeInstanceHealth",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
          "logs:DescribeLogGroups",
          "rds:DescribeDBEngineVersions",
          "rds:DescribeDBInstances",
          "rds:DescribeOrderableDBInstanceOptions",
          "sns:ListSubscriptionsByTopic"
        ],
        "Resource" : [
          "*"
        ]
      },
      {
        "Sid" : "EC2BroadOperationPermissions",
        "Effect" : "Allow",
        "Action" : [
          "ec2:AllocateAddress",
          "ec2:AssociateAddress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CreateLaunchTemplate",
          "ec2:CreateLaunchTemplateVersion",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteLaunchTemplate",
          "ec2:DeleteLaunchTemplateVersions",
          "ec2:DeleteSecurityGroup",
          "ec2:DisassociateAddress",
          "ec2:ReleaseAddress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "EC2RunInstancesOperationPermissions",
        "Effect" : "Allow",
        "Action" : "ec2:RunInstances",
        "Resource" : "*",
        "Condition" : {
          "ArnLike" : {
            "ec2:LaunchTemplate" : "arn:aws:ec2:*:*:launch-template/*"
          }
        }
      },
      {
        "Sid" : "EC2TerminateInstancesOperationPermissions",
        "Effect" : "Allow",
        "Action" : [
          "ec2:TerminateInstances"
        ],
        "Resource" : "arn:aws:ec2:*:*:instance/*",
        "Condition" : {
          "StringLike" : {
            "ec2:ResourceTag/aws:cloudformation:stack-id" : [
              "arn:aws:cloudformation:*:*:stack/awseb-e-*",
              "arn:aws:cloudformation:*:*:stack/eb-*"
            ]
          }
        }
      },
      {
        "Sid" : "ECSBroadOperationPermissions",
        "Effect" : "Allow",
        "Action" : [
          "ecs:CreateCluster",
          "ecs:DescribeClusters",
          "ecs:RegisterTaskDefinition"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "ECSDeleteClusterOperationPermissions",
        "Effect" : "Allow",
        "Action" : "ecs:DeleteCluster",
        "Resource" : "arn:aws:ecs:*:*:cluster/awseb-*"
      },
      {
        "Sid" : "ASGOperationPermissions",
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:AttachInstances",
          "autoscaling:CreateAutoScalingGroup",
          "autoscaling:CreateLaunchConfiguration",
          "autoscaling:CreateOrUpdateTags",
          "autoscaling:DeleteLaunchConfiguration",
          "autoscaling:DeleteAutoScalingGroup",
          "autoscaling:DeleteScheduledAction",
          "autoscaling:DetachInstances",
          "autoscaling:DeletePolicy",
          "autoscaling:PutScalingPolicy",
          "autoscaling:PutScheduledUpdateGroupAction",
          "autoscaling:PutNotificationConfiguration",
          "autoscaling:ResumeProcesses",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:SuspendProcesses",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "autoscaling:UpdateAutoScalingGroup"
        ],
        "Resource" : [
          "arn:aws:autoscaling:*:*:launchConfiguration:*:launchConfigurationName/awseb-e-*",
          "arn:aws:autoscaling:*:*:launchConfiguration:*:launchConfigurationName/eb-*",
          "arn:aws:autoscaling:*:*:autoScalingGroup:*:autoScalingGroupName/awseb-e-*",
          "arn:aws:autoscaling:*:*:autoScalingGroup:*:autoScalingGroupName/eb-*"
        ]
      },
      {
        "Sid" : "CFNOperationPermissions",
        "Effect" : "Allow",
        "Action" : [
          "cloudformation:*"
        ],
        "Resource" : [
          "arn:aws:cloudformation:*:*:stack/awseb-*",
          "arn:aws:cloudformation:*:*:stack/eb-*"
        ]
      },
      {
        "Sid" : "ELBOperationPermissions",
        "Effect" : "Allow",
        "Action" : [
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
          "elasticloadbalancing:ConfigureHealthCheck",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
          "elasticloadbalancing:RegisterTargets"
        ],
        "Resource" : [
          "arn:aws:elasticloadbalancing:*:*:targetgroup/awseb-*",
          "arn:aws:elasticloadbalancing:*:*:targetgroup/eb-*",
          "arn:aws:elasticloadbalancing:*:*:loadbalancer/awseb-*",
          "arn:aws:elasticloadbalancing:*:*:loadbalancer/eb-*",
          "arn:aws:elasticloadbalancing:*:*:loadbalancer/*/awseb-*/*",
          "arn:aws:elasticloadbalancing:*:*:loadbalancer/*/eb-*/*"
        ]
      },
      {
        "Sid" : "CWLogsOperationPermissions",
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:DeleteLogGroup",
          "logs:PutRetentionPolicy"
        ],
        "Resource" : "arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk/*"
      },
      {
        "Sid" : "S3ObjectOperationPermissions",
        "Effect" : "Allow",
        "Action" : [
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:PutObjectVersionAcl"
        ],
        "Resource" : "arn:aws:s3:::elasticbeanstalk-*/*"
      },
      {
        "Sid" : "S3BucketOperationPermissions",
        "Effect" : "Allow",
        "Action" : [
          "s3:GetBucketLocation",
          "s3:GetBucketPolicy",
          "s3:ListBucket",
          "s3:PutBucketPolicy"
        ],
        "Resource" : "arn:aws:s3:::elasticbeanstalk-*"
      },
      {
        "Sid" : "SNSOperationPermissions",
        "Effect" : "Allow",
        "Action" : [
          "sns:CreateTopic",
          "sns:GetTopicAttributes",
          "sns:SetTopicAttributes",
          "sns:Subscribe"
        ],
        "Resource" : "arn:aws:sns:*:*:ElasticBeanstalkNotifications-*"
      },
      {
        "Sid" : "SQSOperationPermissions",
        "Effect" : "Allow",
        "Action" : [
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl"
        ],
        "Resource" : [
          "arn:aws:sqs:*:*:awseb-e-*",
          "arn:aws:sqs:*:*:eb-*"
        ]
      },
      {
        "Sid" : "CWPutMetricAlarmOperationPermissions",
        "Effect" : "Allow",
        "Action" : [
          "cloudwatch:PutMetricAlarm"
        ],
        "Resource" : [
          "arn:aws:cloudwatch:*:*:alarm:awseb-*",
          "arn:aws:cloudwatch:*:*:alarm:eb-*"
        ]
      },
      {
        "Sid" : "AllowECSTagResource",
        "Effect" : "Allow",
        "Action" : [
          "ecs:TagResource"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "ecs:CreateAction" : [
              "CreateCluster",
              "RegisterTaskDefinition"
            ]
          }
        }
      },
    ]
  })
}

resource "aws_iam_policy" "ebs_policy" {
  name        = "${var.project_name}-${var.environment_name}-ebs_policy"
  description = "Allow read access to the S3 bucket"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "BucketAccess",
        "Action" : [
          "s3:Get*",
          "s3:List*",
          "s3:PutObject"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:s3:::elasticbeanstalk-*",
          "arn:aws:s3:::elasticbeanstalk-*/*"
        ]
      },
      {
        "Sid" : "ElasticBeanstalkHealthAccess",
        "Action" : [
          "elasticbeanstalk:PutInstanceStatistics"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:elasticbeanstalk:*:*:application/*",
          "arn:aws:elasticbeanstalk:*:*:environment/*"
        ]
      },
      {
        "Sid" : "ECSAccess",
        "Effect" : "Allow",
        "Action" : [
          "ecs:Poll",
          "ecs:StartTask",
          "ecs:StopTask",
          "ecs:DiscoverPollEndpoint",
          "ecs:StartTelemetrySession",
          "ecs:RegisterContainerInstance",
          "ecs:DeregisterContainerInstance",
          "ecs:DescribeContainerInstances",
          "ecs:Submit*"
        ],
        "Resource" : "*"
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ebs_profile" {
  name = "${var.project_name}-${var.environment_name}-ebs_instance_profile"
  role = aws_iam_role.ebs_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_ebs_policy_attachment" {
  role       = aws_iam_role.ebs_role.name
  policy_arn = aws_iam_policy.ebs_policy.arn
}