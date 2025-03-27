# foo-stack

This project demonstrates a fully containerized web application setup with Nginx reverse proxy, a main application service, and a PostgreSQL database. The setup includes custom SSL encryption for secure communication.

Built as an exploration of self-provisioning ssl certificates, container orchestration, and nginx (reverse proxy, static serving, load balancing, etc.)

## Architecture

The project consists of three main services:

1. **Nginx Reverse Proxy** (`foo` service)
   - Handles SSL termination
   - Routes traffic to the main application
   - Exposes ports 5000 (HTTP) and 5443 (HTTPS)

2. **Main Application** (`app` service)
   - Node.js application
   - Runs on port 3000 internally
   - Exposed on port 5001
   - Connects to the PostgreSQL database

3. **PostgreSQL Database** (`db` service)
   - PostgreSQL 16 (Alpine)
   - Exposed on port 5432
   - Persistent storage using Docker volumes

## Prerequisites

- Podman
- Podman Compose
- curl (for health checks)
- macOS (for the provided run script)

## SSL Certificate Setup

The project uses a custom SSL certificate. To use the application, you need to install the certificate in your system's keychain:

1. Open Keychain Access
2. Select System
3. Drag `nginx/cert.crt` inside the System keychain
4. Double click on `foo.com`
5. Click on the 'Trust' tab
6. Select 'When using this certificate'
7. Select 'Always Trust'
8. Click 'Done'

## Running the Application

1. Clone the repository
2. Run the application using the provided script:
   ```bash
   ./run.sh
   ```

The script will:
- Build and start all containers
- Wait for the service to be ready
- Open your default browser to `https://foo.com:5443`

## Development

The application is structured as follows:
- `app/` - Main application code
- `nginx/` - Nginx configuration and SSL certificates
- `compose.yml` - Container orchestration configuration
- `run.sh` - Development and deployment script

## Environment Variables

### Main Application
- `DATABASE_URL`: PostgreSQL connection string
- `NODE_ENV`: Application environment
- `SKIP_ENV_VALIDATION`: Skip environment validation

### Database
- `POSTGRES_USER`: Database user
- `POSTGRES_PASSWORD`: Database password
- `POSTGRES_DB`: Database name

## Cleanup

The `run.sh` script includes a cleanup function that will:
- Stop all containers
- Remove containers and networks
- Handle interrupts gracefully

## Security Notes

- The SSL certificate is self-signed and should be replaced with a proper certificate in production
- Database credentials are set to default values and should be changed in production
- Ports are exposed for development purposes and should be restricted in production
