# KDE-Connect-Sorter 📂

**KDE-Connect-Sorter** is a bash utility wrapped in a GUI Installer that automatically organizes files received via KDE Connect (or any other source).

It moves **Images** to `~/Pictures` and **Videos** to `~/Videos` while ignoring other file types (like music or documents) to prevent errors.

## ✨ Features

* **GUI Installer:** User-friendly setup wizard using `kdialog`.
* **3 Modes:**
    * 🏎️ **Turbo:** Instantly opens received photos/videos (great for sharing memes).
    * 💬 **Interactive:** Asks permission before opening.
    * 🔕 **Silent:** Sorts quietly in the background.
* **Atomic Support:** Automatically handles dependencies (`inotify-tools`) on **Steam Deck (SteamOS)** and **Bazzite** (rpm-ostree).
* **Safe Logic:** Strict file filtering prevents infinite loops.
* **Uninstall Option:** Easily remove the tool via the installer menu.

## 🚀 How to Use (Generate Installer)

You can create the installer entirely using your mouse, no terminal required!

### Option 1: The Easy Way (GUI) 🖱️

1.  **Download** `generator.sh`, `logo.png`, and `icon.png` from this repository.
2.  **Right-click** on `generator.sh` and select **Properties**.
3.  Go to the **Permissions** tab and check **"Is executable"** (or "Allow executing file").
4.  **Double-click** the file and choose **"Run"**.
5.  **Follow the wizard:**
    * When asked for the **Window Logo**, select `logo.jpg`.
    * When asked for the **File Icon**, select `icon.jpg`.

The script will generate a standalone `.desktop` installer on your Desktop.

## 📦 Requirements

* `kdialog` (Usually pre-installed on KDE, but can be installed via package manager).
* `inotify-tools` (The script will help you install this automatically).

## 👨‍💻 Author
**Aleksandr Nesterenko**
Ver: 2.0 Ultimate

### Option 2: The Terminal Way 💻

If you prefer the command line:

```bash
# 1. Make executable
chmod +x generator.sh

# 2. Run
./generator.sh
