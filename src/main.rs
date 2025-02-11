use std::{
    fs::metadata,
    io::{stdin, stdout, Write},
    path::PathBuf,
    process::Command,
};
pub mod cytdlp;

use colored::Colorize;
use cytdlp::cyt;
use dirs::home_dir;
use indicatif::{ProgressBar, ProgressStyle};

#[tokio::main]
async fn main() {
    println!("{}", "========================================".dimmed().blue());
    println!("{}", "          YT_Downloader".bold().cyan());
    println!("{}", "========================================".dimmed().blue());
    println!(
        "{}",
        "Shall I use the built-in yt-dlp (it is very slow in downloading at the moment)?\n\
         If no, then I will try to run the \"yt\" command bash script from the repo.\n\
         You can download the bash file named \"yt\" from the repo and place it in your /usr/bin or /usr/local/bin.".yellow()
    );
    let mut ans = String::new();
    print!("{}", "yes or no > ".bold().green());
    stdout().flush().unwrap();
    stdin().read_line(&mut ans).unwrap();
    
    let use_cyt = match ans.trim().to_lowercase().as_str() {
        "yes" => {
            println!("{}", "Using built-in yt-dlp command.".green());
            true
        },
        _ => {
            println!("{}", "Proceeding with alternative yt command.".red());
            false
        }
    };
    println!("{}", "Enter YouTube links (type 'done' to finish):".bold().yellow());

    let mut links = Vec::new();
    loop {
        print!("{}", "Enter Link ~> ".bold().green());
        stdout().flush().unwrap();

        let mut link = String::new();
        stdin().read_line(&mut link).unwrap();
        let link = link.trim();

        if link.eq_ignore_ascii_case("done") {
            break;
        } else if !link.starts_with("http") {
            println!("{}", "Invalid URL! Please enter a valid YouTube link.".red());
            continue;
        } else {
            links.push(link.to_string());
            println!("{}", "Link added successfully.".bright_green());
        }
    }

    if links.is_empty() {
        println!("{}", "No links provided. Exiting...".red());
        return;
    }

    println!("{}", "========================================".dimmed().blue());

    let quality = loop {
        println!("{}", "Select video quality:".bold().yellow());
        println!("{}", "1) 360p\n2) 480p\n3) 720p\n4) 1080p".blue());

        print!("{}", "Enter Choice ~> ".green());
        stdout().flush().unwrap();

        let mut index = String::new();
        stdin().read_line(&mut index).unwrap();

        match index.trim().parse::<i32>() {
            Ok(i) => match i {
                1 => break 360,
                2 => break 480,
                3 => break 720,
                4 => break 1080,
                _ => println!("{}", "Invalid option! Please select 1, 2, 3, or 4.".red()),
            },
            Err(_) => println!("{}", "Invalid input! Enter a number (1-4).".red()),
        }
    };

    println!("{}", "========================================".dimmed().blue());

    let save_location = loop {
        println!("{}", "Enter the save location:".bold().yellow());
        print!("{}", "Path ~> ".green());
        stdout().flush().unwrap();

        let mut location = String::new();
        stdin().read_line(&mut location).unwrap();
        let location = location.trim();

        let resolved_path = if location.starts_with("~") {
            match home_dir() {
                Some(home) => {
                    let path_after_tilde = location.strip_prefix("~").unwrap_or("");
                    let joined = format!("{}/{}", home.display(), path_after_tilde);
                    PathBuf::from(joined)
                }
                None => {
                    println!("{}", "Failed to determine home directory.".red());
                    continue;
                }
            }
        } else {
            PathBuf::from(location)
        };

        match metadata(&resolved_path) {
            Ok(meta) if meta.is_dir() => break resolved_path,
            Ok(_) => println!("{}", "Path is not a directory!".red()),
            Err(_) => println!("{}", "Directory does not exist!".red()),
        }
    };

    println!("{}", "========================================".dimmed().blue());
    println!("Download location: {}", save_location.display());
    println!("Selected quality: {}p", quality);
    
    println!("{}", "Download only audio? (y/n):".bold().yellow());
    print!("{}", "Enter choice ~> ".green());
    stdout().flush().unwrap();
    let mut audio_input = String::new();
    stdin().read_line(&mut audio_input).unwrap();
    let audio_input = audio_input.trim().to_lowercase();
    let only_audio = audio_input.starts_with("y");

    // Generate and execute commands
    println!("{}", "========================================".dimmed().blue());
    println!("{}", "Executing download commands...".bold().cyan());

    let pb = ProgressBar::new(links.len() as u64);
    pb.set_style(
        ProgressStyle::default_bar()
            .template("{msg} [{bar:40.cyan/blue}] {pos}/{len} ({eta})")
            .expect("Error setting progress bar template")
            .progress_chars("##-"),
    );
    pb.set_message("Processing");

    for link in &links {
        if !use_cyt{
        let mut cmd = Command::new("yt");
        cmd.stdout(stdout()).arg("-u")
            .arg(link)
            .arg("-q")
            .arg(quality.to_string())
            .arg("-o")
            .arg(save_location.to_string_lossy().to_string());
        if only_audio {
            cmd.arg("-a");
        }
        // Execute the command and wait for it to finish
        match cmd.output() {
            Ok(output) => {
                if !output.status.success() {
                    println!(
                        "Error executing command for link {}: {}",
                        link,
                        String::from_utf8_lossy(&output.stderr)
                    );
                }
            }
            Err(e) => {
                println!("Error executing command for link {}: {:?}", link, e);
            }
        }
        pb.inc(1);
    }
    else{
        match cyt(&link, quality, &save_location, only_audio).await{
            Ok(_) => {}
            Err(e) => {
                eprintln!("err -> {:?}",e);
            }

        }
    }
    }
    pb.finish_with_message("All commands executed.");
    println!("{}", "Setup complete.".bold().green());
}
