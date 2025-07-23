# Immersive LMS Backend (Python)

This directory contains a minimal FastAPI backend for an immersive learning management system. It exposes two simple endpoints:

- `GET /courses` returns a list of available courses.
- `POST /chat` proxies a prompt to the OpenAI API (GPT‑4) and returns the response.

## Requirements

Install Python dependencies:

```bash
pip install -r requirements.txt
```

Create a `.env` file with your OpenAI API key:

```
OPENAI_API_KEY=your-key-here
```

## Running

```
uvicorn main:app --reload
```

Then access `http://localhost:8000/docs` for the interactive API documentation.
