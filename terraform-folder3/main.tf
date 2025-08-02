resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
}


locals{
file_list = fileset(var.folder_path, "*")
}

resource "aws_s3_object" "upload_files" {
  for_each = toset(local.file_list)

  bucket = aws_s3_bucket.my_bucket.bucket
  key = each.value
  source = "${var.folder_path}/${each.value}"
}



