# Code-Server Setup Script

This script automates the setup process for installing and configuring code-server, a web-based version of Visual Studio Code.

## Prerequisites

- This script is designed to run on Ubuntu or Debian-based Linux distributions.
- Make sure you have sudo privileges to execute the script.
- Ensure that you have internet access to download necessary packages.

## Steps to Run the Script

1. **Download the Script**

    Download the `setup_code_server.sh` script from this repository to your local machine.

2. **Set Execution Permissions**

    Open a terminal and navigate to the directory where the script is downloaded. Run the following command to set execution permissions:

    ```bash
    chmod +x setup_code_server.sh
    ```

3. **Run the Script**

    Execute the script with sudo privileges by running:

    ```bash
    sudo ./setup_code_server.sh
    ```

    Select an option from the dropdown menu:

    <select onchange="window.location.href=this.value">
        <option value="">Choose an option</option>
        <option value="./setup_code_server.sh 1">One-time setup (install and start code-server)</option>
        <option value="./setup_code_server.sh 2">Start code-server</option>
        <option value="./setup_code_server.sh 3">Remove code-server</option>
        <option value="./setup_code_server.sh 4">Change IP</option>
    </select>

4. **Follow On-screen Prompts**

    Depending on the option you choose, the script will prompt you for additional information such as the IP address. Follow the on-screen instructions to proceed.

5. **Access code-server**

    Once the script completes execution, you can access code-server by opening a web browser and navigating to the IP address provided during setup.

## Note

- Make sure to review the script before executing it to understand what actions it performs on your system.
- For changing the IP address, ensure that you update any firewall or network configurations accordingly.

