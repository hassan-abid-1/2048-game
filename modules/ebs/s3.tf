resource "aws_s3_bucket" "game-2048" {
  bucket = "${var.project_name}-${var.environment_name}-2048-game"
}

resource "aws_s3_object" "game-2048" {
  bucket = aws_s3_bucket.game-2048.id
  key    = "beanstalk/Dockerfile"
  source = "dockerfile"
}