#!/usr/bin/env bash
# Drift Management Installation Script

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

INSTALL_DIR="${HOME}/drift-management"
BIN_DIR="${HOME}/.local/bin"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Drift Management Installation${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Check dependencies
echo "Checking dependencies..."

if ! command -v ansible &> /dev/null; then
    echo -e "${YELLOW}⚠ Ansible not found. Installing...${NC}"
    if command -v dnf &> /dev/null; then
        sudo dnf install -y ansible
    elif command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y ansible
    else
        echo -e "${RED}❌ Could not install Ansible. Please install manually.${NC}"
        exit 1
    fi
fi

if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python 3 required but not found${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} Dependencies OK"
echo ""

# Create directories
echo "Creating directories..."
mkdir -p "${BIN_DIR}"
mkdir -p "${HOME}/.local/share/drift-management/reports"
mkdir -p "${HOME}/backups"

echo -e "${GREEN}✓${NC} Directories created"
echo ""

# Install CLI tools
echo "Installing CLI tools..."
for tool in content-sync drift-status sync-verify; do
    if [[ -f "${INSTALL_DIR}/bin/${tool}" ]]; then
        ln -sf "${INSTALL_DIR}/bin/${tool}" "${BIN_DIR}/${tool}"
        chmod +x "${BIN_DIR}/${tool}"
        echo -e "${GREEN}✓${NC} Installed ${tool}"
    fi
done

echo ""

# Verify PATH includes ~/.local/bin
if [[ ":${PATH}:" != *":${BIN_DIR}:"* ]]; then
    echo -e "${YELLOW}⚠ ${BIN_DIR} not in PATH${NC}"
    echo "Add this to your ~/.bashrc or ~/.zshrc:"
    echo ""
    echo "    export PATH=\"\${HOME}/.local/bin:\${PATH}\""
    echo ""
fi

# Done
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✅ Installation Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Next steps:"
echo "  1. Create .sync-config.yml in directories you want to sync"
echo "  2. Run: content-sync setup"
echo "  3. Run: content-sync status"
echo ""
echo "Documentation: ${INSTALL_DIR}/docs/GETTING-STARTED.md"
echo ""

