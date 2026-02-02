# Mergington High School Activities API

A super simple FastAPI application that allows students to view and sign up for extracurricular activities.

## Features

- View all available extracurricular activities
- Sign up for activities

## Prerequisites

**MongoDB Required**: This application requires MongoDB to be running.

### In Codespaces

MongoDB is automatically installed and started when you create the Codespace. If you encounter connection issues:

```bash
./.devcontainer/startMongoDB.sh
```

### Local Development

1. Install MongoDB:
   - macOS: `brew install mongodb-community`
   - Ubuntu: See `.devcontainer/installMongoDB.sh`
   - Windows: [Download MongoDB](https://www.mongodb.com/try/download/community)

2. Start MongoDB:
   ```bash
   mongod --dbpath /data/db
   ```

## Getting Started

1. Install the dependencies:

   ```
   pip install -r requirements.txt
   ```

2. Ensure MongoDB is running (see Prerequisites above)

3. Run the application:

   ```
   uvicorn src.app:app --reload
   ```

4. Open your browser and go to:
   - Web interface: http://localhost:8000/
   - API documentation: http://localhost:8000/docs
   - Alternative documentation: http://localhost:8000/redoc

## Checking MongoDB Status

To check if MongoDB is running:

```bash
bash check-mongodb-status.sh
```

Or see the detailed guide:
- 📖 **MongoDB Status Check Guide**: [MONGODB_STATUS_CHECK.md](../MONGODB_STATUS_CHECK.md) (日本語)

## Troubleshooting

If you see "HTTP ERROR 502" or MongoDB connection errors:

- 📖 **Japanese**: See [TROUBLESHOOTING_502_ERROR.md](../TROUBLESHOOTING_502_ERROR.md)
- 📖 **English**: See [TROUBLESHOOTING_502_ERROR_EN.md](../TROUBLESHOOTING_502_ERROR_EN.md)

**Quick fix**: Run `./.devcontainer/startMongoDB.sh` to start MongoDB

## API Endpoints

| Method | Endpoint                                                          | Description                                                         |
| ------ | ----------------------------------------------------------------- | ------------------------------------------------------------------- |
| GET    | `/activities`                                                     | Get all activities with their details and current participant count |
| POST   | `/activities/{activity_name}/signup?email=student@mergington.edu` | Sign up for an activity                                             |

## Data Model

The application uses a simple data model with meaningful identifiers:

1. **Activities** - Uses activity name as identifier:

   - Description
   - Schedule
   - Maximum number of participants allowed
   - List of student emails who are signed up

2. **Students** - Uses email as identifier:
   - Name
   - Grade level

All data is stored in memory, which means data will be reset when the server restarts.
