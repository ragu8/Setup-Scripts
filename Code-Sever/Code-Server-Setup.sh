#!/bin/bash

# Function to generate a random password
generate_password() {
    #PASSWORD=$(openssl rand -base64 12)
    PASSWORD=#11#
    echo "$PASSWORD"
}

# Function to install code-server
install_code_server() {
    # Step 1: Install Nginx
    sudo apt update && sudo apt install -y nginx

    # Step 2: Install code-server
    mkdir -p ~/code-server
    cd ~/code-server || exit
    wget https://github.com/coder/code-server/releases/download/v4.8.2/code-server-4.8.2-linux-amd64.tar.gz
    tar -xzvf code-server-4.8.2-linux-amd64.tar.gz
    sudo cp -r code-server-4.8.2-linux-amd64 /usr/lib/code-server
    sudo ln -s /usr/lib/code-server/bin/code-server /usr/bin/code-server
    sudo mkdir -p /var/lib/code-server

    # Create systemd service file
    cat <<EOF | sudo tee /lib/systemd/system/code-server.service
[Unit]
Description=code-server
After=nginx.service

[Service]
Type=simple
Environment=PASSWORD=$(generate_password)
ExecStart=/usr/bin/code-server --bind-addr 127.0.0.1:8080 --user-data-dir /var/lib/code-server --auth password
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    # Enable and start code-server service
    sudo systemctl daemon-reload
    sudo systemctl enable code-server
    sudo systemctl start code-server

    echo "Code-server has been installed and started."
}

# Function to configure Nginx as a reverse proxy
configure_nginx() {
    # Configure Nginx as a reverse proxy with dynamic domain name
    cat <<EOF | sudo tee /etc/nginx/sites-available/code-server.conf
server {
    listen 80;
    listen [::]:80;
    server_name $PUBLIC_IP;
    location / {
      proxy_pass http://localhost:8080/;
      proxy_set_header Upgrade \$http_upgrade;
      proxy_set_header Connection upgrade;
      proxy_set_header Accept-Encoding gzip;
    }
}
EOF

    sudo ln -s /etc/nginx/sites-available/code-server.conf /etc/nginx/sites-enabled/code-server.conf
    sudo nginx -t && sudo systemctl restart nginx

    echo "Nginx has been configured as a reverse proxy for code-server."
}

# Function to remove code-server and associated files
remove_code_server() {
    # Step 1: Stop and disable code-server service
    sudo systemctl stop code-server && sudo systemctl disable code-server

    # Step 2: Remove code-server installation directory
    sudo rm -rf /usr/lib/code-server /usr/bin/code-server

    # Step 3: Remove code-server user data directory
    sudo rm -rf /var/lib/code-server

    # Step 4: Remove code-server systemd service file
    sudo rm /lib/systemd/system/code-server.service

    # Step 5: Remove code-server Nginx configuration
    sudo rm /etc/nginx/sites-available/code-server.conf /etc/nginx/sites-enabled/code-server.conf

    # Step 6: Reload and restart Nginx
    sudo systemctl reload nginx

    echo "Code-server and associated files have been removed."
}

# Main script
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script with sudo privileges."
    exit 1
fi



if [ "$1" == "1" ]; then
    echo "IP address:? "
    read -p "Enter IP address: " PUBLIC_IP
    install_code_server
    configure_nginx
    echo "Code-server is now accessible at: http://$PUBLIC_IP  , Pass: #11#"
elif [ "$1" == "2" ]; then
    install_code_server
    configure_nginx
    echo "Code-server is now accessible at: http://$PUBLIC_IP"
elif [ "$1" == "3" ]; then
    remove_code_server
elif [ "$1" == "4" ]; then
    echo "IP address Assigned : $PUBLIC_IP"
    read -p "Enter new IP address : " NEW_IP
    PUBLIC_IP=$NEW_IP
    sed -i "s/server_name $PUBLIC_IP;/server_name $PUBLIC_IP;/g" /etc/nginx/sites-available/code-server.conf
    sudo nginx -t && sudo systemctl restart nginx
    echo "IP address has been updated to: $PUBLIC_IP"
else
    echo "Usage: $0 [option]"
    echo "Options:"
    echo "  1: One-time setup (install and start code-server)"
    echo "  2: Start code-server"
    echo "  3: Remove code-server"
    echo "  4: Change IP"
fi

