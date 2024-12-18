# Afro Stores Project Structure 

This project consists of three main components:

## 1. Backend (.NET)
- `src/` - Source code directory
  - `Api/` - Web API project
    - `Controllers/` - API endpoint controllers
    - `Models/` - Data models and DTOs
    - `Services/` - Business logic implementation
    - `Repositories/` - Data access layer
    - `Middleware/` - Custom middleware components
    - `Extensions/` - Extension methods
  - `Core/` - Core business logic
    - `Entities/` - Domain entities
    - `Interfaces/` - Abstractions and contracts
    - `Services/` - Core business services
  - `Infrastructure/` - External dependencies and implementations
    - `Data/` - Database context and configurations
    - `External/` - Third-party service integrations
- `tests/` - Test projects
  - `Unit/` - Unit tests
  - `Integration/` - Integration tests
  - `E2E/` - End-to-end tests

## 2. Mobile Application (Flutter)
- `lib/` - Main application code
  - `screens/` - UI screens/pages
  - `widgets/` - Reusable UI components
  - `models/` - Data models
  - `services/` - API services and business logic
  - `providers/` - State management
  - `utils/` - Helper functions and utilities
  - `constants/` - App-wide constants
  - `theme/` - App theming
- `assets/` - Static assets (images, fonts, etc.)
- `test/` - Test files

## 3. Web Application (Next.js)
- `src/` - Source code directory
  - `pages/` - Route components and API routes
    - `api/` - API route handlers
  - `components/` - Reusable React components
    - `ui/` - Basic UI components
    - `layouts/` - Page layouts
    - `forms/` - Form components
  - `hooks/` - Custom React hooks
  - `services/` - API services
  - `utils/` - Helper functions
  - `styles/` - CSS/SCSS files
  - `types/` - TypeScript type definitions
  - `context/` - React context providers
  - `lib/` - Third-party library configurations
- `public/` - Static files
- `tests/` - Test files

## Shared Resources
- `docs/` - Documentation
- `scripts/` - Build and deployment scripts
- `.github/` - GitHub workflows and templates
- `docker/` - Docker configurations
- `kubernetes/` - Kubernetes manifests

## Configuration Files
- Backend:
  - `appsettings.json` - Application settings
  - `Dockerfile` - Container configuration
  - `*.csproj` - Project files
- Mobile:
  - `pubspec.yaml` - Dependencies and assets
  - `android/` - Android-specific files
  - `ios/` - iOS-specific files
- Web:
  - `package.json` - Dependencies and scripts
  - `next.config.js` - Next.js configuration
  - `tsconfig.json` - TypeScript configuration
  - `.env.local` - Environment variables


