import boto3
import zipfile
import os
from datetime import datetime


def list_objects(bucket_name):
    s3 = boto3.client('s3')
    response = s3.list_objects_v2(Bucket=bucket_name)
    objects = []
    for obj in response.get('Contents', []):
        name = obj['Key']
        date = obj['LastModified']
        size = obj['Size']
        objects.append({'name': name, 'date': date, 'size': size})
    return objects


def download_file(bucket_name, file_name):
    s3 = boto3.client('s3')
    file_path = f'/tmp/{file_name}'
    try:
        s3.download_file(bucket_name, file_name, file_path)
        return file_path
    except Exception as e:
        print(f"Error downloading file: {file_name}, {str(e)}")
        return None


def create_zip_file(file_paths, bucket_name):
    current_date = datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
    zip_file_path = f'/tmp/{current_date}_bucket_{bucket_name}.zip'
    with zipfile.ZipFile(zip_file_path, 'w') as zip_file:
        for file_path in file_paths:
            file_name = os.path.basename(file_path)
            zip_file.write(file_path, arcname=file_name)

    return zip_file_path
