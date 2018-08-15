# Updating package lists
sudo apt-get update

# Installing packages
sudo apt-get install -y build-essential python-pip python-dev git zip

# Installing Python packages
# HINT:
# check pip version:
# $ pip --version
sudo pip install --upgrade pip
sudo pip install numpy pandas matplotlib sklearn jupyter

# Try Jupyter
jupyter notebook --no-browser --ip=*

# Configure Jupyter password
jupyter notebook password

# Configure Jupyter
jupyter notebook --generate-config
vim ~/.jupyter/jupyter_notebook_config.py

# Try again
# NOTE: no command line options here
jupyter notebook

# Creating certificates
mkdir certs
openssl req -x509 -nodes\
    -days 365 -newkey rsa:2048\
    -keyout certs/key.key\
    -out certs/cert.pem

# Update config: fields `certfile` and `keyfile` must be updated with actual keys
vim ~/.jupyter/jupyter_notebook_config.py

# Create code and data moutpoints
mkdir projects
mkdir data

# Update notebooks folder in Jupyter config
vim ~/.jupyter/jupyter_notebook_config.py

# Try again
# NOTE: no command line options here
jupyter notebook

# Try Jupyter as a systemd service
# sudo cp jupyter.service /et/systemd/system
# sudo systemctl enable jupyter.service
# sudo systemctl restart jupyter.service

# Check, if EBS disk is attached
ls /dev/xvd*

# Use actual device name instead of `/dev/xvdf` here!
mkfs.ext4 /dev/xvdf
sudo mount /dev/xvdf projects

# Consider adding to fstab: UUID=<disk-uuid> <mountpoint> ext4 defaults,user,nofail,x-systemd.device-timeout=1 0 0
sudo vim /etc/fstab
sudo chown -R ubuntu projects
sudo chgrp -R ubuntu projects

# Launch EC2 instance with AWS CLI
aws ec2 run-instances\
    --count 1 --image-id ami-5228a42a\
    --instance-type t2.micro\
    --key-name netology-aws\
    --security-group-ids sg-72bede0d\
    --subnet-id subnet-6118fa2a

# Use S3 with AWS CLI
aws s3 ls
aws s3 ls s3://netology-aws-bucket
aws s3 cp examples/setup.sh s3://netology-aws-bucket

# Use Rekognition with AWS CLI
aws rekognition detect-faces\
    --image "S3Object={Bucket=netology-aws-bucket,Name=img_rekognition.jpg}"

# Use Comprehend with AWS CLI
aws comprehend detect-entities\
    --text "Some funny English text about AWS, deep learning and tensorflow."\
    --language-code en