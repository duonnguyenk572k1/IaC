resource "aws_s3_bucket" "s3_bucket" {

  bucket = format("%s", var.name)

  tags = merge(
    {
      "name" = format("%s".var.name)
    }, var.tags
  )
}

// Block public access
resource "aws_s3_bucket_public_access_block" "s3_bucket" {
  bucket                  = format("%s", var.name)
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
  depends_on              = [
    aws_s3_bucket.s3_bucket
  ]
}

resource "aws_s3_bucket_policy" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Deny",
          "Principal" : "*",
          "Action" : "s3:*",
          "Resource" : "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}/*",
          "Condition" : {
            "Bool" : {
              "aws:SecureTransport" : "false"
            }
          }
        }
      ]
    }
  )
  depends_on = [
    aws_s3_bucket_public_access_block.s3_bucket
  ]
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket
  name   = format("%s-%s", var.name, "all-objects")
  status = "Enabled"

  dynamic "tiering" {
    for_each = var.s3_bucket_tiering[0].intelligent_tiering
    content {
      days        = tiering.value["days"]
      access_tier = tiering.value["access_tier"]
    }
  }
}