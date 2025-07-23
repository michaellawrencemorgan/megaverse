from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List
from dotenv import load_dotenv
import os
import openai

from courses import COURSES

load_dotenv()

app = FastAPI(title="Immersive LMS")

openai.api_key = os.getenv("OPENAI_API_KEY")

class ChatRequest(BaseModel):
    prompt: str

class ChatResponse(BaseModel):
    reply: str

@app.get("/courses")
async def list_courses():
    return COURSES

@app.post("/chat", response_model=ChatResponse)
async def chat(req: ChatRequest):
    if not openai.api_key:
        raise HTTPException(status_code=500, detail="OPENAI_API_KEY not set")

    try:
        response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[{"role": "user", "content": req.prompt}]
        )
        reply = response.choices[0].message.content
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

    return {"reply": reply}

