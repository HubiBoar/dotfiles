#terraform
curl -L https://releases.hashicorp.com/terraform/1.8.2/terraform_1.8.2_linux_amd64.zip -O \
&& unzip terraform_1.8.2_linux_amd64.zip \
&& mv terraform /usr/local/bin/ \
&& rm terraform_1.8.2_linux_amd64.zip \
&& rm LICENSE.txt