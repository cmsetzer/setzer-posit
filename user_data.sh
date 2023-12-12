#!/bin/bash

# Install dependencies
sudo yum update -y && sudo yum install -y curl cronie

# Create folder structure
mkdir -p /home/ec2-user/app/output

# Write shell script and make it executable
sudo echo '#!/bin/bash' > /home/ec2-user/app/download_random_wikipedia_article.sh
sudo echo 'curl -L --max-redirs 1 -o "/home/ec2-user/app/output/$(date +%Y-%m-%d).html" https://en.wikipedia.org/api/rest_v1/page/random/html' >> /home/ec2-user/app/download_random_wikipedia_article.sh
sudo chmod +x /app/download_random_wikipedia_article.sh

# Pass cron job to crontab via standard input
echo '0 0 * * * /home/ec2-user/app/download_random_wikipedia_article.sh' | crontab -

# Run service
sudo systemctl enable crond
sudo systemctl start crond
