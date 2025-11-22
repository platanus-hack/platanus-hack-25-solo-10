# transcribe.py
# Uso: python transcribe.py "https://youtu.be/xxxxxx" "key"

import sys
import os
import json
from datetime import timedelta
import yt_dlp
import whisper

def download_audio_only(url: str, key: str, output_folder: str = "downloads") -> str:
    os.makedirs(output_folder, exist_ok=True)
    
    ydl_opts = {
        'format': 'bestaudio/best',
        'outtmpl': f'{output_folder}/{key}.%(ext)s',
        'postprocessors': [{
            'key': 'FFmpegExtractAudio',
            'preferredcodec': 'mp3',
            'preferredquality': '192',
        }],
        'quiet': False,
        'nooverwrites': True,
    }
    
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(url, download=True)
        audio_file = f"{output_folder}/{key}.mp3"
    
    print(f"Audio downloaded: {audio_file}")
    return audio_file

def transcribe_with_whisper(audio_file: str) -> dict:
    model = whisper.load_model("medium") 
    result = model.transcribe(
        audio_file,
        word_timestamps=True
    )
    
    return result

def save_transcription(result: dict, title: str, output_folder: str = "downloads") -> None:
    base = os.path.join(output_folder, title)
    
    with open(f"{base}.txt", "w", encoding="utf-8") as f:
        f.write(result["text"])
    
    
    print(f"Transcription saved as {title}.txt")

def main():
    if len(sys.argv) != 3:
        print("Usage: python transcribe.py \"https://youtube.com/watch?v=...\" \"key\"")
        sys.exit(1)
    
    
    url = sys.argv[1].strip()
    key = sys.argv[2].strip()
    
    audio_path = download_audio_only(url, key)
    transcription = transcribe_with_whisper(audio_path)
    save_transcription(transcription, key)

    json.dump({"status": "ok", "data": transcription["text"]}, sys.stdout)
    print()
  

if __name__ == "__main__":
    main()