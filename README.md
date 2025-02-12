# FastAPI Book Management API

## Overview

This project is a RESTful API built with FastAPI for managing a book collection. It provides comprehensive CRUD (Create, Read, Update, Delete) operations for books with proper error handling, input validation, and documentation.

## Features

- 📚 Book management (CRUD operations)
- ✅ Input validation using Pydantic models
- 🔍 Enum-based genre classification
- 🧪 Complete test coverage
- 📝 API documentation (auto-generated by FastAPI)
- 🔒 CORS middleware enabled

## Project Structure

```
fastapi-book-project/
├── api/
│   ├── db/
│   │   ├── __init__.py
│   │   └── schemas.py      # Data models and in-memory database
│   ├── routes/
│   │   ├── __init__.py
│   │   └── books.py        # Book route handlers
│   └── router.py           # API router configuration
├── core/
│   ├── __init__.py
│   └── config.py           # Application settings
├── tests/
│   ├── __init__.py
│   └── test_books.py       # API endpoint tests
├── main.py                 # Application entry point
├── requirements.txt        # Project dependencies
└── README.md
```

## Technologies Used

- Python 3.12
- FastAPI
- Pydantic
- pytest
- uvicorn

## Installation Locally

1. Clone the repository:

```bash
git clone https://github.com/DevKanmi/fastapi-book-project.git
cd fastapi-book-project
```

2. Create a virtual environment:

```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. Install dependencies:

```bash
pip install -r requirements.txt
```

## Running the Application

1. Start the server:

```bash
uvicorn main:app
```

## Deployment on AWS EC2

### 1. **Set Up EC2 Instance**
- Launch an **Ubuntu 22.04** instance.
- Allow inbound rules for **ports 22 (SSH), 80, and 443 (HTTP/S), and 8000 (if testing)** in the **Security Group**.

### 2. **Connect to the Server**
```sh
ssh -i your-key.pem ubuntu@your-ec2-public-ip
```

### 3. **Install Required Packages**
```sh
sudo apt update && sudo apt install -y python3-pip python3-venv nginx
```

### 4. **Clone the Repository and Set Up the Environment**
```sh
git clone https://github.com/yourusername/fastapi-book-project.git
cd fastapi-book-project
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 5. **Run FastAPI with Uvicorn**
```sh
uvicorn main:app --host 0.0.0.0 --port 8000
```

### 6. **Configure Systemd Service**
```sh
sudo vi /etc/systemd/system/fastapi.service
```
Paste the following:
```ini
[Unit]
Description=FastAPI Application
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/fastapi-book-project
ExecStart=/home/ubuntu/fastapi-book-project/venv/bin/uvicorn main:app --host 0.0.0.0 --port 8000
Restart=always

[Install]
WantedBy=multi-user.target
```
Save and exit, then enable and start the service:
```sh
sudo systemctl daemon-reload
sudo systemctl enable fastapi
sudo systemctl start fastapi
```
Check status:
```sh
sudo systemctl status fastapi
```

### 7. **Set Up Nginx Reverse Proxy**
```sh
sudo vi /etc/nginx/sites-available/fastapi
```
Paste the following configuration:
```nginx
server {
    listen 80;
    server_name your-ec2-public-ip;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```
Enable the configuration and restart Nginx:
```sh
sudo ln -s /etc/nginx/sites-available/fastapi /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### 8. **Access Your API on the Browser**
Go to `http://your-ec2-public-ip/docs` to test the FastAPI application.


## API Endpoints

### Books

- `GET /api/v1/books/` - Get all books
- `GET /api/v1/books/{book_id}` - Get a specific book
- `POST /api/v1/books/` - Create a new book
- `PUT /api/v1/books/{book_id}` - Update a book
- `DELETE /api/v1/books/{book_id}` - Delete a book

### Health Check

- `GET /healthcheck` - Check API status

## Book Schema

```json
{
  "id": 1,
  "title": "Book Title",
  "author": "Author Name",
  "publication_year": 2024,
  "genre": "Fantasy"
}
```

Available genres:

- Science Fiction
- Fantasy
- Horror
- Mystery
- Romance
- Thriller

## Running Tests

```bash
pytest
```

## Error Handling

The API includes proper error handling for:

- Non-existent books
- Invalid book IDs
- Invalid genre types
- Malformed requests

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, please open an issue in the GitHub repository.
