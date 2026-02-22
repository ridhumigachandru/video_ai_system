from fastapi import FastAPI, UploadFile, File
from fastapi.responses import FileResponse
from ultralytics import YOLO
import cv2
import tempfile
import subprocess
import os

app = FastAPI()
model = YOLO("yolov8n.pt")

@app.post("/detect")
async def detect(file: UploadFile = File(...)):

    # Save input
    temp_input = tempfile.NamedTemporaryFile(delete=False, suffix=".mp4")
    temp_input.write(await file.read())
    temp_input.close()

    input_path = temp_input.name
    raw_output = input_path.replace(".mp4", "_raw.mp4")
    final_output = input_path.replace(".mp4", "_final.mp4")

    cap = cv2.VideoCapture(input_path)
    fps = cap.get(cv2.CAP_PROP_FPS) or 25
    width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))

    fourcc = cv2.VideoWriter_fourcc(*"mp4v")
    out = cv2.VideoWriter(raw_output, fourcc, fps, (width, height))

    while True:
        ret, frame = cap.read()
        if not ret:
            break

        results = model(frame)[0]

        for box in results.boxes:
            x1, y1, x2, y2 = box.xyxy[0].tolist()
            cv2.rectangle(frame,
                          (int(x1), int(y1)),
                          (int(x2), int(y2)),
                          (0, 255, 0),
                          2)

        out.write(frame)

    cap.release()
    out.release()

    # 🔥 Re-encode to H264 for browser compatibility
    subprocess.run([
        "ffmpeg", "-y",
        "-i", raw_output,
        "-vcodec", "libx264",
        "-acodec", "aac",
        "-movflags", "faststart",
        final_output
    ])

    return FileResponse(final_output, media_type="video/mp4")