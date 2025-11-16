#!/bin/bash
# KiCAD Docker Helper Script
# Provides convenient commands for managing KiCAD container

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function print_usage() {
    echo "KiCAD Docker Helper"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  start      Start KiCAD container"
    echo "  stop       Stop KiCAD container"
    echo "  restart    Restart KiCAD container"
    echo "  status     Show container status"
    echo "  logs       Show container logs (follow)"
    echo "  shell      Open shell in container"
    echo "  url        Show KiCAD web URL"
    echo "  update     Pull latest image and restart"
    echo "  clean      Stop and remove container + config"
    echo "  help       Show this help message"
}

function check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}Error: Docker is not installed${NC}"
        exit 1
    fi

    if ! command -v docker-compose &> /dev/null; then
        echo -e "${RED}Error: Docker Compose is not installed${NC}"
        exit 1
    fi
}

function start_kicad() {
    echo -e "${GREEN}Starting KiCAD container...${NC}"
    docker-compose up -d
    echo -e "${GREEN}KiCAD is starting...${NC}"
    echo -e "${YELLOW}Access KiCAD at: http://localhost:3000${NC}"
}

function stop_kicad() {
    echo -e "${YELLOW}Stopping KiCAD container...${NC}"
    docker-compose down
    echo -e "${GREEN}KiCAD stopped${NC}"
}

function restart_kicad() {
    echo -e "${YELLOW}Restarting KiCAD container...${NC}"
    docker-compose restart
    echo -e "${GREEN}KiCAD restarted${NC}"
}

function show_status() {
    echo -e "${GREEN}Container Status:${NC}"
    docker-compose ps
    echo ""
    if docker ps | grep -q kicad_mobmon12; then
        echo -e "${GREEN}✓ KiCAD is running${NC}"
        echo -e "${YELLOW}Access at: http://localhost:3000${NC}"
    else
        echo -e "${RED}✗ KiCAD is not running${NC}"
    fi
}

function show_logs() {
    echo -e "${GREEN}Showing KiCAD logs (Ctrl+C to exit)...${NC}"
    docker-compose logs -f kicad
}

function open_shell() {
    if ! docker ps | grep -q kicad_mobmon12; then
        echo -e "${RED}Error: KiCAD container is not running${NC}"
        echo "Start it first with: $0 start"
        exit 1
    fi
    echo -e "${GREEN}Opening shell in KiCAD container...${NC}"
    docker exec -it kicad_mobmon12 /bin/bash
}

function show_url() {
    if docker ps | grep -q kicad_mobmon12; then
        echo -e "${GREEN}KiCAD Web Interface:${NC}"
        echo "  HTTP:  http://localhost:3000"
        echo "  HTTPS: https://localhost:3001"
    else
        echo -e "${RED}KiCAD container is not running${NC}"
    fi
}

function update_kicad() {
    echo -e "${YELLOW}Pulling latest KiCAD image...${NC}"
    docker-compose pull
    echo -e "${YELLOW}Restarting with new image...${NC}"
    docker-compose down
    docker-compose up -d
    echo -e "${GREEN}Update complete${NC}"
}

function clean_kicad() {
    echo -e "${RED}WARNING: This will stop the container and remove all KiCAD settings${NC}"
    echo -e "${RED}Your project files will NOT be deleted${NC}"
    read -p "Are you sure? (yes/no): " -r
    if [[ $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
        echo -e "${YELLOW}Stopping container...${NC}"
        docker-compose down -v
        echo -e "${YELLOW}Removing config directory...${NC}"
        rm -rf docker/kicad-config
        echo -e "${GREEN}Clean complete${NC}"
    else
        echo "Cancelled"
    fi
}

# Main script
check_docker

case "${1:-}" in
    start)
        start_kicad
        ;;
    stop)
        stop_kicad
        ;;
    restart)
        restart_kicad
        ;;
    status)
        show_status
        ;;
    logs)
        show_logs
        ;;
    shell)
        open_shell
        ;;
    url)
        show_url
        ;;
    update)
        update_kicad
        ;;
    clean)
        clean_kicad
        ;;
    help|--help|-h)
        print_usage
        ;;
    *)
        echo -e "${RED}Unknown command: ${1:-}${NC}"
        echo ""
        print_usage
        exit 1
        ;;
esac
