# transcribe.py
# Uso: python transcribe.py <video_path> <filename>

import sys
import os
import whisper

if len(sys.argv) != 3:
    print("Usage: python transcribe.py <video_path> <filename>")
    sys.exit(1)

video_path = sys.argv[1].strip()
filename = sys.argv[2].strip()

if not os.path.exists(video_path):
    print(f"Error: Video file not found: {video_path}")
    sys.exit(1)

print(f"Transcribing video: {video_path}")
model = whisper.load_model("medium")
result = model.transcribe(video_path)

output_file = f"{filename}"
with open(output_file, "w", encoding="utf-8") as f:
    f.write(result["text"])

print(f"Transcription saved as {output_file}")