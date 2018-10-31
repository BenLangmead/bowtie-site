#!/bin/sh

PROFILE=jhu-langmead
SITE=bowtie.bio

# 4. Copy files
aws --profile ${PROFILE} s3 \
    sync site/ s3://${SITE}/
