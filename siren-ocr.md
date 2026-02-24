---
permalink: /siren-ocr/
layout: single
classes:
  - landing
  - dark-theme
sidebar:
  nav: "plugins_nav"
github_org: sirensolutions
github_repo: siren-arrow-java
toc: true
toc_sticky: true
toc_icon: "cog"
---

Wraps an OCR system in a flask microservice. The intent behind this service is a CPU-optimized solution for installations that do not have access to an LLM or GPUs.

This is based off of the  https://github.com/RapidAI/RapidOCR repo. 

Note that there are LLMs that offer OCR, but those require GPUs or cloud resources. This one works on CPU and is fast.


## Build the service
```bash
docker build -t rapidocr-service .
```


## Run the container
```bash
docker run -d -p 5070:5000 rapidocr-service
```


## Test the service
```bash
curl -X POST http://localhost:5070/ocr \
  -F "image=@/Users/billoliver/siren/images_with_text/uspis_scams/hello-world.png"

curl -X POST http://localhost:5070/ocr \
  -F "image=@/Users/billoliver/siren/images_with_text/uspis_scams/image001.jpg"

curl -X POST http://192.168.80.2:5070/ocr   -F "image=@./image001.jpg"
```