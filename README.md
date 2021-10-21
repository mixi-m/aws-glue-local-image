# aws-glue-local-image

[![build and push](https://github.com/ratel-pay/aws-glue-local-image/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/ratel-pay/aws-glue-local-image/actions/workflows/build.yml)

This repository holds Dockerfiles of unofficial AWS Glue locally Docker images.
Please refer to the [AWS Glue Developer Guide - Developing Locally using Docker image](https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-etl-libraries.html#develop-local-docker-image).

## How to use Docker images

The images are published to [GitHub Container Registry](https://github.com/ratel-pay/aws-glue-local-image/pkgs/container/aws-glue-local-image) so that you can pull images like this:

```
$ docker pull ghcr.io/ratel-pay/aws-glue-local-image:glue-2.0
```

or

```
$ docker pull ghcr.io/ratel-pay/aws-glue-local-image:glue-3.0
```
