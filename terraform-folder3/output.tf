output "s3_bucket_name"{
value = aws_s3_bucket.my_bucket.bucket
}
output "uploaded_files"{
value = [ for f in aws_s3_object.upload_files : f.key ]
}
