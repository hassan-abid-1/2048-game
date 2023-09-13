resource "aws_elastic_beanstalk_application" "game-2048" {
  name = "${var.project_name}-${var.environment_name}-2048-game"
}

resource "aws_elastic_beanstalk_application_version" "game-2048" {
  name        = "${var.project_name}-${var.environment_name}-2048-game-version"
  application = aws_elastic_beanstalk_application.game-2048.name
  bucket      = aws_s3_bucket.game-2048.id
  key         = aws_s3_object.game-2048.id
}

resource "aws_elastic_beanstalk_environment" "env-2048" {
  name                = "${var.project_name}-${var.environment_name}-2048-game"
  application         = aws_elastic_beanstalk_application.game-2048.name
  solution_stack_name = var.solution_stack_name
  version_label       = aws_elastic_beanstalk_application_version.game-2048.name

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.ebs_profile.arn
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.ebs_role.arn
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "vpc-00ded0d570a98afc0"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "subnet-09042f2953fe690a9"
  }

}