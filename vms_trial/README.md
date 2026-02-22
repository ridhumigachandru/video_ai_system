# Video AI Processing System

A full-stack video processing system built using:

- Phoenix (Elixir) – UI & video handling
- FastAPI (Python) – AI inference service
- YOLOv8 – Object detection
- FFmpeg – Video clipping & browser-compatible encoding

## Features

- Upload video file (.mp4)
- Select start and end time
- Clip video using FFmpeg
- Run YOLO object detection
- Generate annotated video
- View annotated video directly in browser
---

##  Architecture
User → Phoenix (LiveView UI)
↓
FFmpeg (clip video)
↓
FastAPI (YOLO detection)
↓
FFmpeg (H264 re-encode)
↓
Phoenix serves annotated video

#  Project Structure
video-ai-system/
├── vms_trial/ # Phoenix application

├── ai_service/ # FastAPI AI service

├── README.md

└── .gitignore

---

# Requirements
Make sure the following are installed:
### System Requirements

- Elixir 1.14+
  
- Phoenix 1.7+

- Python 3.10+
  
- FFmpeg (must be available in PATH)
  
---

**Start AI Service (FastAPI)**
cd ai_service

python -m venv venv

source venv/bin/activate

pip install -r requirements.txt

uvicorn main:app --reload

http://localhost:8000

**Open a new terminal:**
cd vms_trial

mix deps.get

mix phx.server

http://localhost:4000

