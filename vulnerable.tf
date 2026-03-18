provider "aws" {
  region     = "us-east-1"

  # ❌ Hardcoded credentials (critical vulnerability)
  access_key = "AKIAEXAMPLEKEY"
  secret_key = "supersecretkey123"
}

# ❌ Public S3 bucket
resource "aws_s3_bucket" "public_bucket" {
  bucket = "my-insecure-bucket-12345"
  acl    = "public-read"

  tags = {
    Name = "InsecureBucket"
  }
}

# ❌ Disable bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "disabled_encryption" {
  bucket = aws_s3_bucket.public_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ❌ Security group open to the entire internet
resource "aws_security_group" "open_sg" {
  name        = "open-security-group"
  description = "Allow all inbound traffic"

  ingress {
    description = "Open to world"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ❌ open to the internet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ❌ Public EC2 instance
resource "aws_instance" "insecure_ec2" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  # ❌ Public IP enabled
  associate_public_ip_address = true

  # ❌ Using insecure security group
  vpc_security_group_ids = [aws_security_group.open_sg.id]

  tags = {
    Name = "InsecureInstance"
  }
}

# ❌ IAM policy with full admin permissions
resource "aws_iam_policy" "admin_policy" {
  name        = "admin-full-access"
  description = "Overly permissive IAM policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "*"
      Resource = "*"
    }]
  })
}

# ❌ Attach admin policy to role
resource "aws_iam_role" "insecure_role" {
  name = "insecure-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_admin" {
  role       = aws_iam_role.insecure_role.name
  policy_arn = aws_iam_policy.admin_policy.arn
}
