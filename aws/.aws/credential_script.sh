#!/usr/bin/env bash

# AWSのアクセスキーとシークレットアクセスキーを取得するロジックをここに記述
# 例として、環境変数から取得する場合
AWS_ACCESS_KEY_ID=$(op read --cache=true "op://Personal/aws access key - tomoyak31-cli/access key id")
AWS_SECRET_ACCESS_KEY=$(op read --cache=true "op://Personal/aws access key - tomoyak31-cli/secret access key")

# JSON形式で認証情報を出力
cat <<EOF
{
  "Version": 1,
  "AccessKeyId": "$AWS_ACCESS_KEY_ID",
  "SecretAccessKey": "$AWS_SECRET_ACCESS_KEY"
}
EOF
