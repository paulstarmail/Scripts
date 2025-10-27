import subprocess
import sys
import time

def download_with_retry(url):
    while True:
        try:
            print(f"Starting download: {url}")
            # Call wget with -c (continue) option
            result = subprocess.run(["wget", "-c", url], check=True)
            
            if result.returncode == 0:
                print("Download completed successfully!")
                break
        except subprocess.CalledProcessError:
            print("Download failed. Retrying in 2 seconds...")
            time.sleep(2)  # wait before retrying

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Usage: python {sys.argv[0]} <URL>")
        sys.exit(1)
    
    url = sys.argv[1]
    download_with_retry(url)
