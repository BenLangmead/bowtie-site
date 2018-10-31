#!/bin/sh

# Followed this nice guide:
# https://medium.freecodecamp.org/how-to-host-a-website-on-s3-without-getting-lost-in-the-sea-e2b82aa6cd38

PROFILE=jhu-langmead
SITE=www.bowtie.bio

# 1. Make the bucket
aws --profile ${PROFILE} s3 mb s3://${SITE}

# 2. Make it a static website bucket
aws --profile ${PROFILE} s3 website \
    s3://${SITE}/ \
        --index-document index.html \
        --error-document error.html

# 3. Set bucket policy
cat >policy.json <<EOF
{
    "Version": "2008-10-17",
    "Id": "PolicyForPublicWebsiteContent",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${SITE}/*"
        }
    ]
}
EOF

aws --profile ${PROFILE} s3api \
    put-bucket-policy \
        --bucket ${SITE} \
        --policy file://policy.json

# 4. Copy files
aws --profile ${PROFILE} s3 \
    sync site/ s3://${SITE}/
