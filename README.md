# ytgrab

ytgrab is a Rust-based command-line tool for downloading YouTube videos and audio using `yt-dlp`. It provides an enhanced wrapper around `yt-dlp` with custom progress bars and detailed debugging output.

## Features

- Download YouTube videos and audio
- Choose video quality (360p, 480p, 720p, 1080p)
- Download audio-only files in MP3 format
- Download captions and metadata
- Custom progress bar and detailed logging

## Installation

### Prerequisites

- Rust and Cargo installed on your system
- `yt-dlp` installed and available in your system's PATH

### Installing ytgrab

You can install ytgrab using the following `curl` command on Linux:

```sh
curl -sSL https://raw.githubusercontent.com/yourusername/ytgrab/main/install.sh | sudo bash
