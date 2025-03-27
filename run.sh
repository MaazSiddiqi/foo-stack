set -e

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

clean_up () {
    ARG=$?
    log_info "Cleaning up containers..."
    podman compose down
    # Don't report error on interrupt
    if [ $ARG -eq 0 ]; then
        log_success "Cleanup completed successfully"
    elif [ $ARG -eq 130 ]; then
        log_info "Cleanup completed after interrupt"
    else
        log_error "Cleanup completed with errors"
        log_info "If you can't access the service, please make sure you have the certificate installed in your keychain."
        log_info "You can add it by doing:"
        log_info "Open Keychain Access"
        log_info "Select System"
        log_info "Drag nginx/cert.crt inside the System keychain"
        log_info "Double click on foo.com"
        log_info "Click on the 'Trust' tab"
        log_info "Select 'When using this certificate'"
        log_info "Select 'Always Trust'"
        log_info "Click 'Done'"
    fi
    exit $ARG
}

trap clean_up EXIT

log_info "Getting everything ready..."
podman compose down &>/dev/null

# Function to check if service is ready
wait_for_service() {
    log_info "Waiting for service to be ready..."
    while ! curl -s -k https://foo.com:5443 > /dev/null; do
        echo -n "."
        sleep 1
    done
    echo
    log_success "Service is ready and accepting connections!"
}

# Start the containers in the background
log_info "Starting containers in the background..."
podman compose up --build &

# Wait for service to be ready and then open browser
wait_for_service
log_info "Opening browser..."
open https://foo.com:5443

# Wait for the compose process to complete
log_info "Waiting for containers to complete..."
wait
