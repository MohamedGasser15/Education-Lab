# EduLab

EduLab is a comprehensive educational platform built with a modern multi-platform architecture. It consists of a .NET 9.0 backend API, an ASP.NET Core MVC web application, and a Flutter mobile application.

## Project Structure

```
EduLab/
├── apps/
│   ├── api/                    # Backend API (Clean Architecture)
│   │   ├── EduLab_API/         # API layer - Web API entry point
│   │   ├── EduLab_Application/ # Application layer - Business logic
│   │   ├── EduLab_Domain/      # Domain layer - Core business entities
│   │   └── EduLab_Infrastructure/ # Infrastructure layer - Data access, external services
│   ├── web/
│   │   └── EduLab_MVC/         # ASP.NET Core MVC web application
│   └── mobile/
│       └── [Flutter App]       # Cross-platform mobile application
└── EduLab Project.sln          # Visual Studio solution file
```

## Technology Stack

### Backend API (.NET 9.0)
- **Framework**: ASP.NET Core 9.0
- **Architecture**: Clean Architecture (Domain, Application, Infrastructure, API layers)
- **Database**: SQL Server with Entity Framework Core 9.0
- **Authentication**: 
  - JWT Bearer Authentication
  - Google Authentication
  - Facebook Authentication
  - ASP.NET Core Identity
- **Key Libraries**:
  - AutoMapper - Object-object mapping
  - MailKit/MimeKit - Email functionality
  - Stripe.net - Payment processing
  - Scalar.AspNetCore - API documentation
  - Microsoft.AspNetCore.OpenApi - OpenAPI/Swagger support

### Web Application (.NET 9.0)
- **Framework**: ASP.NET Core MVC 9.0
- **Database**: SQL Server with Entity Framework Core 9.0
- **Authentication**: Same as backend API
- **Key Libraries**:
  - AutoMapper
  - MailKit/MimeKit
  - Microsoft.VisualStudio.Web.CodeGeneration.Design

### Mobile Application (Flutter)
- **Framework**: Flutter (Dart SDK ^3.11.0)
- **Platforms**: Android, iOS, Web, Windows, macOS, Linux
- **State Management**: Flutter default patterns

## Getting Started

### Prerequisites

- **.NET 9.0 SDK** - [Download](https://dotnet.microsoft.com/download/dotnet/9.0)
- **Visual Studio 2022** or **VS Code** with C# extension
- **SQL Server** or **SQL Server Express**
- **Flutter SDK** (for mobile development) - [Download](https://docs.flutter.dev/get-started/install)

### Backend Setup

1. **Restore dependencies**:
   ```bash
   dotnet restore "EduLab Project.sln"
   ```

2. **Configure database connection**:
   - Update the connection string in `appsettings.json` in the EduLab_API project

3. **Apply migrations**:
   ```bash
   cd apps/api/EduLab_API
   dotnet ef database update
   ```

4. **Run the API**:
   ```bash
   dotnet run --project apps/api/EduLab_API/EduLab_API.csproj
   ```

### Web Application Setup

1. **Configure the web project**:
   - Update connection string and API URLs in `appsettings.json`

2. **Run the web application**:
   ```bash
   dotnet run --project apps/web/EduLab_MVC/EduLab_MVC.csproj
   ```

### Mobile Application Setup

1. **Navigate to mobile directory**:
   ```bash
   cd apps/mobile
   ```

2. **Get Flutter dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run on your preferred platform**:
   ```bash
   flutter run
   ```

## Development

### Building the Solution

```bash
dotnet build "EduLab Project.sln"
```

### Running Tests

```bash
dotnet test "EduLab Project.sln"
```

### API Documentation

The API uses Scalar.AspNetCore for interactive API documentation. Once the API is running, navigate to:
```
https://edulab.runasp.net/scalar/v1
```

## Architecture

The backend follows **Clean Architecture** principles:

- **Domain Layer**: Contains enterprise business logic and types (entities, value objects, domain events)
- **Application Layer**: Contains application business logic and interfaces
- **Infrastructure Layer**: Contains implementations of interfaces, data access, external services
- **API Layer**: Contains controllers, request/response models, and API composition

## Features

- 🔐 **Authentication & Authorization**: Multi-provider authentication (JWT, Google, Facebook)
- 📧 **Email Support**: Integrated email functionality via MailKit
- 💳 **Payment Processing**: Stripe integration for payments
- 📱 **Cross-Platform**: Web and mobile applications
- 📚 **Educational Focus**: Designed for educational purposes and learning management
- 🔄 **Clean Architecture**: Maintainable and testable codebase
- 📖 **API Documentation**: Interactive API docs with Scalar

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For questions or support, please open an issue in the repository.

---

*Built with .NET 9.0, ASP.NET Core, and Flutter*
