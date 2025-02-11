use std::path::{Path, PathBuf};
use yt_dlp::{Youtube, fetcher::deps::Libraries};
use std::error::Error;

pub async fn cyt(
    link: &str,
    _quality: u32,
    save_location: &Path,
    audio_only: bool,
) -> Result<PathBuf, Box<dyn Error>> {
    // Instead of specifying a custom directory, just rely on system-installed binaries
    let yt_dlp_path = Path::new("yt-dlp"); // This will look in $PATH
    let ffmpeg_path = Path::new("ffmpeg"); // This will look in $PATH

    // Create a Libraries instance using the system binaries
    let libraries = Libraries::new(yt_dlp_path.to_path_buf(), ffmpeg_path.to_path_buf());
    
    let fetcher = Youtube::new(libraries, save_location.to_path_buf())?;
    
    println!("[DEBUG] Fetching video info for link: {}", link);

    let video_info = fetcher.fetch_video_infos(link.to_string()).await?;
    let sanitized_title = video_info.title.replace("/", "_").replace("\\", "_");
    let file_name = if !audio_only {
        format!("{}.mp3", sanitized_title)
    } else {
        format!("{}.mp4", sanitized_title)
    };

    if !audio_only {
        let path = fetcher.download_audio_stream_from_url(link.to_string(), &file_name).await?;
        Ok(path)
    } else {
        let path = fetcher.download_video_from_url(link.to_string(), &file_name).await?;
        Ok(path)
    }
}
