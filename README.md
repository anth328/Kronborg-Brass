# Kronborg-Brass

A redesign and rebuild of the Kronborg Brass website, made for the band as the customer. The goal is to keep the existing features but deliver them with cleaner, better-tested and easier-to-maintain code.

This is our 3rd semester final project (Datamatiker, Systemudvikling + Programmering 2 + Teknologi 2). The project is developed with an agile/Scrum process in a team of four.

## Team

| Name | GitHub | Role |
| :-- | :-- | :-- |
| Micki Mogensen | LordGlarthir | Product Owner, Developer, QA, UX/UI |
| André P. Thai | anth328 | Scrum Master, Developer, QA, UX/UI |
| Malik Ghaleth | magh0003 | Developer, QA, UX/UI |
| Daniel K. Ugueto | DanielUgueto | Developer, QA, UX/UI |

## Features (current scope)

**Visitors (not logged in)**
- Information about the band, its history and an FAQ
- Public concert calendar
- Media gallery with images and videos
- Links to the band's social media
- Mobile-friendly, simple and high-contrast design (primary users are 50+)

**Members** (shared member login)
- Everything visitors can see
- Internal rehearsal calendar and internal information

**Administrators**
- Separate administrator login
- Edit website content directly on the site
- Add images and videos to the gallery
- Create, edit and delete calendar events (concerts and rehearsals)

Planned but **outside current scope**: sheet music, mailing list, contact/booking form and a news section.

> Features are being built sprint by sprint. See the [issues](https://github.com/anth328/Kronborg-Brass/issues) for what is done and what is still open.

## Tech stack

| Layer | Technology |
| :-- | :-- |
| Backend | Java, Spring Boot 4, Spring Web (REST API), Spring Data JPA, Spring Security |
| Database | MySQL |
| Frontend | HTML, CSS, JavaScript (communicates with the backend using `fetch`) |
| Build | Maven (wrapper included) |
| Infrastructure | Docker Compose |

## Project structure

```
kronborg-brass/
├── src/
│   ├── main/java/ek/dk/kronborgbrass/   # controller, model, service, repository
│   ├── main/resources/                  # application.properties, static files
│   └── test/                            # tests
├── .github/workflows/ci.yml             # CI pipeline
├── docker-compose.yaml                  # App + MySQL
├── .env.example                         # Template for local environment variables
└── pom.xml
```

## Getting started

### Prerequisites

- Git
- Docker and Docker Compose
- A JDK matching the Java version set in `pom.xml`

The Maven wrapper is included, so Maven does not need to be installed.

### 1. Clone the repository

```bash
git clone https://github.com/anth328/Kronborg-Brass.git
cd Kronborg-Brass
```

### 2. Configure environment variables

Copy the template and fill in your own values:

```bash
cp .env.example .env
```

| Variable | Description |
| :-- | :-- |
| `MYSQL_ROOT_PASSWORD` | Password for the MySQL root user (required, choose your own) |
| `MYSQL_DATABASE` | Name of the database (required, choose your own) |
| `MYSQL_USER` | Application database user (required, choose your own) |
| `MYSQL_PASSWORD` | Password for the application user (required, choose your own) |
| `MYSQL_PORT` | Port on your own machine that MySQL is reachable on (required, choose your own) |

The password and user values are empty in the template and must be filled in before starting the database.

> Never commit `.env`, since it contains your own passwords. Only `.env.example` belongs in the repository.

### 3. Start the infrastructure

```bash
docker compose up -d
```

This starts a MySQL 8.4 container (`orchestra-mysql`) with a persistent volume. For security, the database port is only published on `127.0.0.1`, so it can be reached from your own machine but not from the network.

Check that the container is running:

```bash
docker compose ps
```

### 4. Run the application

The application reads its database settings from the environment variables `MYSQL_PORT`, `MYSQL_DATABASE`, `MYSQL_USER` and `MYSQL_PASSWORD` (see `application.properties`). Spring Boot does not load `.env` files on its own, so these must be set in the environment you start the app from. If they are missing, the application will fail to start.

**Linux / macOS (bash or zsh):** load `.env` into your shell, then start the app:

```bash
set -a; source .env; set +a
./mvnw spring-boot:run
```

**Windows (PowerShell):**

```powershell
Get-Content .env | ForEach-Object {
  if ($_ -match '^\s*([^#=]+)=(.*)$') { [Environment]::SetEnvironmentVariable($matches[1].Trim(), $matches[2].Trim()) }
}
.\mvnw.cmd spring-boot:run
```

**IDE (e.g. IntelliJ):** add the same four variables to the run configuration's environment variables.

Hibernate is set to `ddl-auto=update`, so the tables are created and updated automatically in the database.

The application starts on <http://localhost:8080> unless configured otherwise.

### Stopping

```bash
docker compose down        # stop the containers
docker compose down -v     # stop and also delete the database volume
```

## Running the tests

```bash
./mvnw test
```

Tests that start the Spring context use the same datasource settings, so keep the database running and the environment variables set as described above (unless the tests are configured with their own test database).

Our team target is at least 80% code coverage in automated tests.

## Roadmap

The following parts of the final project requirements are planned and will be documented here once they are in the repository:

- Dockerfile (multi-stage) so the application itself runs in a container
- GitHub Actions workflow that compiles and tests on pull requests to `main`
- GitHub Actions workflow that builds and pushes the image to GitHub Container Registry (GHCR)

## Process

We work in 5-day sprints with Scrum ceremonies (daily stand-up, sprint planning, review, retrospective and backlog refinement). Our Definition of Done requires peer-reviewed code, passing tests, updated documentation and a demo accepted by the Product Owner.

## Customer

Kronborg Brass, a brass band.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
