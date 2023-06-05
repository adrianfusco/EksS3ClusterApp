# S3 Simple Bucket Listing App

This is a simple Python application that uses Flask and Boto3 to list the content of an S3 bucket.

## Building and Pushing the Docker Image

We have a simple Dockerfile with instructions to build the container.

To build and push the Docker image, follow these steps:

1. Log in to Docker Hub (docker.io) using the `docker login` command. You will be prompted to enter your Docker Hub username and password.

```bash
$ docker login docker.io
```

We should specify the username and the password.

2. Build and tag the image. This Dockerfile contains the argument BUCKET_NAME. It will be used to connect to our bucket.

```bash
docker build -t adrianfusco/s3-bucket-listing:latest --build-arg BUCKET_NAME=bucket-name .
```

3. Push the image:

```bash
docker push username/s3-bucket-listing:latest
```

Note: We should substitute username by our user in docker.io in the steps 2 and 3.
