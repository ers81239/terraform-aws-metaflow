resource "aws_s3_bucket" "this" {
  bucket = local.s3_bucket_name

  force_destroy = var.force_destroy_s3_bucket

  tags = merge(
    var.standard_tags,
    {
      Metaflow = "true"
    }
  )


}


resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3.arn
    }
  }

}
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_policy     = true
  block_public_acls       = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
