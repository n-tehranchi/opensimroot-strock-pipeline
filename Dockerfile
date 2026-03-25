FROM --platform=linux/amd64 ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Add bionic repo to get libgfortran3 (not available in ubuntu 20.04 by default)
RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository "deb http://archive.ubuntu.com/ubuntu/ bionic main universe" && \
    apt-get update && apt-get install -y \
    python3 python3-pip git \
    libgfortran3 \
    && pip3 install pandas \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /pipeline

# Copy SimRoot binary
COPY SimRoot ./SimRoot
RUN chmod +x ./SimRoot

# Copy all input and replacement files
COPY InputFiles/ ./InputFiles/
COPY Replacements/ ./Replacements/

# Copy pipeline scripts
COPY run_all.sh ./run_all.sh
COPY summarize.py ./summarize.py
RUN chmod +x run_all.sh

# Clone the Strock results repo at build time using a token passed as build arg
# NEVER hardcode the token — always pass via --build-arg at build time
ARG GITHUB_TOKEN
RUN git clone https://${GITHUB_TOKEN}@github.com/n-tehranchi/opensimroot-strock-pipeline.git outputs

ENTRYPOINT ["./run_all.sh"]