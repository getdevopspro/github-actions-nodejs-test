# GitHub Actions Nodejs Test

A minimal Node.js/Express application for testing GitHub Actions, Docker builds, and docker-bake workflows.

## Quick Start

### Install Dependencies

```bash
npm install
```

### Local Development

```bash
npm run dev
```

### Build

```bash
npm run build
npm start
```

### Lint

```bash
npm run lint          # Check for linting errors
npm run lint:fix      # Auto-fix linting errors
```

### Test

```bash
npm test              # Run tests once
npm run test:watch    # Run tests in watch mode
```

### Docker Build

```bash
docker buildx bake --load
docker run -p 3000:3000 github-actions-test
```

## Endpoints

- `GET /` - Main endpoint with app info
- `GET /health` - Health check endpoint

## Testing

Visit http://localhost:3000 to see the app running.
