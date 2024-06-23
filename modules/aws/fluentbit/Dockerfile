# Fluent Bitのカスタム設定ファイルをイメージ内にコピーしています。
# 2021/11/6時点でFargateでホストする場合はカスタム設定ファイルをS3から取得できないので、イメージ作成時に対応する必要があります。

FROM amazon/aws-for-fluent-bit:latest
COPY fluentbit/extra.conf /fluent-bit/etc/extra.conf