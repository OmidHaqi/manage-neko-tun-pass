#!/bin/bash

GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

RULES_FILE="/etc/polkit-1/rules.d/99-nekoray.rules"

check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${RED}This script requires root privileges.${RESET}"
        read -p "Do you want to run this script with sudo? (press Enter to continue): " dummy
        sudo bash "$0"
        exit 0
    fi
}
clear

check_root

if [ -n "$SUDO_USER" ]; then
    USERNAME="$SUDO_USER"
else
    USERNAME="$(whoami)"
fi

echo -e "${YELLOW}Please choose an option:${RESET}"
echo "1. Enable tun mode without requiring a password."
echo "2. Require a password for tun mode."
read -p "Enter your choice (1/2): " choice

case $choice in
    1)
        echo -e "${YELLOW}Adding the rule to bypass password for tun mode for user '${USERNAME}'...${RESET}"
        sudo bash -c "cat <<'EOL' > $RULES_FILE
polkit.addRule(function(action, subject) {
 if (action.id == \"org.freedesktop.policykit.exec\" &&
     subject.user == \"${USERNAME}\") {
     return polkit.Result.YES;
 }
});
EOL" && echo -e "${GREEN}Password bypass for tun mode enabled for user '${USERNAME}'.${RESET}" || {
            echo -e "${RED}Failed to add the rule file. Please check your permissions.${RESET}"
            exit 1
        }
        ;;
    2)
        if [ -f "$RULES_FILE" ]; then
            echo -e "${YELLOW}Removing the rule for tun mode...${RESET}"
            sudo rm -f "$RULES_FILE" && echo -e "${GREEN}Password requirement for tun mode enabled.${RESET}" || {
                echo -e "${RED}Failed to remove the rule file. Please check your permissions.${RESET}"
                exit 1
            }
        else
            echo -e "${GREEN}No existing rule found. Password requirement is already enabled.${RESET}"
        fi
        ;;
    *)
        echo -e "${RED}Invalid choice. Please run the script again.${RESET}"
        exit 1
        ;;
esac

echo -e "${YELLOW}Restarting polkit service to apply changes...${RESET}"
sudo systemctl restart polkit && echo -e "${GREEN}Polkit service restarted successfully.${RESET}" || {
    echo -e "${RED}Failed to restart polkit service. Please restart it manually.${RESET}"
}

echo -e "${GREEN}Operation completed successfully.${RESET}"
exit 0
