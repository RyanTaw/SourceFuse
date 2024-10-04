# One command to list the files in the S3 bucket created in the first step
import boto3

def keys(bucket_name, prefix='/', delimiter='/'):
    prefix = prefix.lstrip(delimiter)
    bucket = boto3.resource('s3').Bucket(bucket_name)
    return (_.key for _ in bucket.objects.filter(Prefix=prefix))