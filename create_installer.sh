#!/bin/bash

# ==============================================================================
# KDE SORTER GENERATOR: ULTIMATE EDITION v2.0
# (Uninstaller + Deep Descriptions + Smart Dep Check + Loop Fix)
# ==============================================================================

if ! command -v kdialog &>/dev/null; then
    echo "Error: kdialog is missing. Please install it."
    exit 1
fi

# 1. GATHER RESOURCES
WINDOW_IMG=$(kdialog --title "1/2 Logo (Window)" --getopenfilename "$HOME" "Images (*.png *.jpg *.jpeg *.svg)")
[ -z "$WINDOW_IMG" ] && exit 0

ICON_IMG=$(kdialog --title "2/2 Icon (File)" --getopenfilename "$HOME" "Images (*.png *.jpg *.jpeg *.svg *.ico)")
[ -z "$ICON_IMG" ] && exit 0

echo "⏳ Packing resources..."
ICON_B64=$(base64 -w 0 "$ICON_IMG")
WINDOW_B64=$(base64 -w 0 "$WINDOW_IMG")

# ==============================================================================
# INNER INSTALLER SCRIPT
# ==============================================================================
INNER_SCRIPT=$(cat << 'EOF_INNER'
#!/bin/bash

# --- CONFIG ---
AUTHOR="Aleksandr Nesterenko"
VER="2.0 Ultimate"
DATE=$(date +%Y-%m-%d)

# Extract Resources
TEMP_DIR="/tmp/kde_sorter_ult_res"
mkdir -p "$TEMP_DIR"
LOGO="$TEMP_DIR/logo.img"
ICON="$TEMP_DIR/icon.img"

#PLACEHOLDER_LOGO_B64
#PLACEHOLDER_ICON_B64

echo "$B64_LOGO" | base64 -d > "$LOGO"
echo "$B64_ICON" | base64 -d > "$ICON"

# Install Paths
BIN_DIR="$HOME/.local/bin"
AUTO_DIR="$HOME/.config/autostart"
ICON_DEST="$HOME/.local/share/icons/kde-sorter.png"
SCRIPT_PATH="$BIN_DIR/kde-sorter.sh"
DESKTOP_PATH="$HOME/Desktop/KDE-Sorter.desktop"
AUTO_FILE="$AUTO_DIR/KDE-Sorter.desktop"

# --- 1. LANGUAGE SELECTION ---
LANG_SEL=$(kdialog --title "Language / Язык" --geometry 400x500 --icon "globe" \
              --menu "Select language / Выберите язык:" \
              "en" "🇺🇸 English" \
              "de" "🇩🇪 Deutsch" \
              "ru" "🇷🇺 Русский")

[ -z "$LANG_SEL" ] && exit 0
LANG_CODE="$LANG_SEL"

# --- 2. LOCALIZATION DATABASE ---
case $LANG_CODE in
    de)
        T_TITLE="KDE Sorter Ultimate"
        T_MAIN="<b>Willkommen!</b><br>Autor: $AUTHOR<br>Version: $VER ($DATE)<br><br>Dieses Tool organisiert Ihre Downloads automatisch und intelligent."
        
        # Menu
        T_BTN_INSTALL="✨ Installieren"
        T_BTN_FOLDERS="📂 Ordner konfigurieren"
        T_BTN_MODE="⚙️ Modus wählen"
        T_BTN_AUTO="🚀 Autostart"
        T_BTN_UNINSTALL="🗑️ Deinstallieren"
        T_BTN_EXIT="❌ Beenden"
        T_BACK="🔙 Zurück"

        # Detailed Descriptions
        T_F_TITLE="Warum Ordner konfigurieren?"
        T_F_DESC="Das Skript muss genau wissen, wohin Ihre Dateien verschoben werden sollen.<br><br>Standardmäßig werden die Systempfade (Downloads, Bilder, Videos) verwendet.<br>Ändern Sie diese nur, wenn Sie eine spezielle Struktur haben (z. B. externe Festplatte)."
        T_W="📥 Quelle (Downloads)"
        T_V="🎥 Ziel für Videos"
        T_P="🖼️ Ziel für Bilder"

        T_M_TITLE="Warum Modus wählen?"
        T_M_DESC="Jeder Nutzer hat andere Vorlieben.<br><br><b>Turbo:</b> Ideal für Medienkonsum. Die Datei öffnet sich sofort nach dem Empfang.<br><b>Interactive:</b> Für mehr Kontrolle. Das System fragt höflich, ob die Datei geöffnet werden soll.<br><b>Silent:</b> Für ungestörtes Arbeiten. Alles passiert leise im Hintergrund."
        T_M1="🏎️ Turbo (Sofort öffnen)"
        T_M2="💬 Interactive (Fragen)"
        T_M3="🔕 Silent (Nur sortieren)"

        # Dependencies
        T_DEP_TITLE="Systemprüfung"
        T_DEP_HEAD="🔍 <b>Komponente fehlt:</b> inotify-tools"
        T_DEP_WARN_ATOMIC="⚠️ <b>WICHTIG (Atomic/Bazzite):</b><br>Die Installation über <i>rpm-ostree</i> dauert 2-5 Minuten.<br>Es mag so aussehen, als ob nichts passiert - bitte warten Sie.<br><br>♻️ <b>Danach ist ein NEUSTART erforderlich!</b>"
        T_DEP_WARN_STD="⏳ Die Installation dauert nur wenige Sekunden."
        T_DEP_INSTALLING="📥 Installiere Komponenten... Bitte warten..."
        T_DEP_REBOOT="♻️ <b>Neustart erforderlich!</b><br>Bitte starten Sie Ihren PC neu und führen Sie diese Datei erneut aus."
        
        # Final & Uninstall
        T_DONE="<h3>🎉 Installation erfolgreich!</h3><br>Vielen Dank, dass Sie dieses Programm installiert haben!<br>Es wurde mit Sorgfalt entwickelt, um Ihnen zu helfen.<br>Viel Spaß mit der automatischen Sortierung!"
        T_UNINST_CONFIRM="Sind Sie sicher, dass Sie KDE Sorter entfernen möchten?<br>Das Skript und der Autostart werden gelöscht."
        T_UNINST_DONE="✅ KDE Sorter wurde erfolgreich entfernt."
        T_Q="Datei empfangen. Öffnen?"
        T_PASS="Sudo Passwort:"
        ;;
    ru)
        T_TITLE="KDE Sorter Ultimate"
        T_MAIN="<b>Добро пожаловать!</b><br>Автор: $AUTHOR<br>Версия: $VER ($DATE)<br><br>Эта утилита автоматически наводит порядок в ваших файлах."
        
        # Menu
        T_BTN_INSTALL="✨ Установить"
        T_BTN_FOLDERS="📂 Настроить папки"
        T_BTN_MODE="⚙️ Выбрать режим"
        T_BTN_AUTO="🚀 Автозапуск"
        T_BTN_UNINSTALL="🗑️ Удалить программу"
        T_BTN_EXIT="❌ Выход"
        T_BACK="🔙 Назад"

        # Detailed Descriptions
        T_F_TITLE="Зачем настраивать папки?"
        T_F_DESC="Скрипту нужно точно знать, куда перекладывать ваши файлы.<br><br>По умолчанию используются стандартные системные папки (Загрузки, Изображения, Видео).<br>Меняйте их только если у вас нестандартная структура папок или вы хотите сохранять файлы сразу на другой диск."
        T_W="📥 Источник (Загрузки)"
        T_V="🎥 Папка для Видео"
        T_P="🖼️ Папка для Фото"

        T_M_TITLE="Зачем выбирать режим?"
        T_M_DESC="У каждого пользователя свой стиль работы.<br><br><b>Turbo:</b> Для тех, кто хочет видеть контент сразу. Файл открывается мгновенно.<br><b>Interactive:</b> Для тех, кто любит контроль. Система вежливо спросит перед открытием.<br><b>Silent:</b> Для тех, кто занят. Файлы сортируются тихо в фоне, не отвлекая вас."
        T_M1="🏎️ Turbo (Мгновенно)"
        T_M2="💬 Interactive (Спрашивать)"
        T_M3="🔕 Silent (Тихий режим)"

        # Dependencies
        T_DEP_TITLE="Проверка системы"
        T_DEP_HEAD="🔍 <b>Не хватает компонента:</b> inotify-tools"
        T_DEP_WARN_ATOMIC="⚠️ <b>ВАЖНО (Atomic/Bazzite):</b><br>Установка через <i>rpm-ostree</i> занимает 2-5 минут.<br>В это время может казаться, что программа зависла - <b>пожалуйста, ждите.</b><br><br>♻️ <b>После завершения нужен ПЕРЕЗАПУСК ПК!</b>"
        T_DEP_WARN_STD="⏳ Установка займет несколько секунд."
        T_DEP_INSTALLING="📥 Идет установка компонентов... Пожалуйста, ждите..."
        T_DEP_REBOOT="♻️ <b>Требуется перезагрузка!</b><br>Пожалуйста, перезагрузите компьютер и запустите этот файл снова."
        
        # Final & Uninstall
        T_DONE="<h3>🎉 Установка успешно завершена!</h3><br>Огромное спасибо, что выбрали эту программу.<br>Я очень старался сделать её удобной и душевной.<br>Пусть ваши файлы всегда будут в порядке. Хорошего дня!"
        T_UNINST_CONFIRM="Вы уверены, что хотите удалить KDE Sorter?<br>Скрипт перестанет работать, автозагрузка будет отключена."
        T_UNINST_DONE="✅ KDE Sorter был полностью удален."
        T_Q="Файл получен. Открыть?"
        T_PASS="Пароль Sudo:"
        ;;
    *)
        T_TITLE="KDE Sorter Ultimate"
        T_MAIN="<b>Welcome!</b><br>Author: $AUTHOR<br>Version: $VER ($DATE)<br><br>This tool organizes your downloads automatically."
        
        # Menu
        T_BTN_INSTALL="✨ Install"
        T_BTN_FOLDERS="📂 Configure Folders"
        T_BTN_MODE="⚙️ Select Mode"
        T_BTN_AUTO="🚀 Autostart"
        T_BTN_UNINSTALL="🗑️ Uninstall"
        T_BTN_EXIT="❌ Exit"
        T_BACK="🔙 Back"

        # Descriptions
        T_F_TITLE="Why configure folders?"
        T_F_DESC="The script needs to know exactly where to move your files.<br><br>By default, it uses standard system paths (Downloads, Pictures, Videos).<br>Change these only if you have a custom structure."
        T_W="📥 Source (Downloads)"
        T_V="🎥 Destination for Videos"
        T_P="🖼️ Destination for Pictures"

        T_M_TITLE="Why select a mode?"
        T_M_DESC="Different users have different workflows.<br><br><b>Turbo:</b> Opens immediately. Great for media.<br><b>Interactive:</b> Asks permission first. Good for control.<br><b>Silent:</b> Sorts quietly in the background. Good for focus."
        T_M1="🏎️ Turbo (Instant)"
        T_M2="💬 Interactive (Ask me)"
        T_M3="🔕 Silent (Background)"

        # Dep Check
        T_DEP_TITLE="System Check"
        T_DEP_HEAD="🔍 <b>Missing Component:</b> inotify-tools"
        T_DEP_WARN_ATOMIC="⚠️ <b>IMPORTANT (Atomic/Bazzite):</b><br>Installing via <i>rpm-ostree</i> takes 2-5 minutes.<br>It might look like the app is frozen - <b>please wait.</b><br><br>♻️ <b>REBOOT REQUIRED afterwards!</b>"
        T_DEP_WARN_STD="⏳ Installation will take a few seconds."
        T_DEP_INSTALLING="📥 Installing components... Please wait..."
        T_DEP_REBOOT="♻️ <b>Reboot Required!</b><br>Please reboot your PC and run this file again."
        
        # Done
        T_DONE="<h3>🎉 Installation Complete!</h3><br>Thank you so much for choosing this tool!<br>I put a lot of heart into making it useful for you.<br>Have a wonderful day!"
        T_UNINST_CONFIRM="Are you sure you want to remove KDE Sorter?<br>The script and autostart entry will be deleted."
        T_UNINST_DONE="✅ KDE Sorter has been removed."
        T_Q="File received. Open?"
        T_PASS="Sudo Password:"
        ;;
esac

HEADER="<center><img src='$LOGO' width='400'></center>"

# --- 3. DEPENDENCY CHECK (ON STARTUP) ---
if ! command -v inotifywait &>/dev/null; then
    
    # OS Detection
    CMD=""
    IS_ATOMIC=false
    
    if [[ -f /etc/os-release ]]; then . /etc/os-release; fi
    
    if [[ "$ID" == "bazzite" ]] || [[ "$ID" == "fedora" && -x /usr/bin/rpm-ostree ]]; then
        CMD="rpm-ostree install inotify-tools"
        IS_ATOMIC=true
        WARN_TEXT="$T_DEP_WARN_ATOMIC"
    elif [[ "$ID" == "fedora" ]]; then
        CMD="dnf install inotify-tools -y"
        WARN_TEXT="$T_DEP_WARN_STD"
    elif [[ "$ID_LIKE" == *"debian"* ]] || [[ "$ID" == "ubuntu" ]]; then
        CMD="apt update && apt install inotify-tools -y"
        WARN_TEXT="$T_DEP_WARN_STD"
    elif [[ "$ID_LIKE" == *"arch"* ]]; then
        CMD="pacman -S inotify-tools --noconfirm"
        WARN_TEXT="$T_DEP_WARN_STD"
    fi

    if [ -z "$CMD" ]; then
        kdialog --error "Your Linux distribution is not supported automatically.\nPlease install 'inotify-tools' manually."
        exit 1
    fi

    # Information Dialog
    MSG="$HEADER\n\n$T_DEP_HEAD\n\n$WARN_TEXT"
    kdialog --title "$T_DEP_TITLE" --geometry 500x400 --icon "system-software-install" --yesno "$MSG"
    if [ $? -ne 0 ]; then exit 0; fi

    # Installation Process
    PASS=$(kdialog --password "$T_PASS")
    [ -z "$PASS" ] && exit 0
    
    dbus_ref=$(kdialog --title "$T_DEP_TITLE" --progressbar "$T_DEP_INSTALLING" 0)
    echo "$PASS" | sudo -S sh -c "$CMD" >/dev/null 2>&1
    RES=$?
    qdbus $dbus_ref close

    if [ $RES -eq 0 ]; then
        if [ "$IS_ATOMIC" = true ]; then
            kdialog --msgbox "$HEADER\n\n$T_DEP_REBOOT"
            exit 0
        fi
    else
        kdialog --error "Installation failed."
        exit 1
    fi
fi

# --- DEFAULT SETTINGS ---
W_RAW=$(xdg-user-dir DOWNLOAD 2>/dev/null); WATCH_DIR=${W_RAW:-$HOME/Downloads}
V_RAW=$(xdg-user-dir VIDEOS 2>/dev/null); VIDEO_DIR=${V_RAW:-$HOME/Videos}
P_RAW=$(xdg-user-dir PICTURES 2>/dev/null); PIC_DIR=${P_RAW:-$HOME/Pictures}

# Path Fallbacks
if [ ! -d "$WATCH_DIR" ] && [ -d "$HOME/Загрузки" ]; then WATCH_DIR="$HOME/Загрузки"; fi
if [ ! -d "$VIDEO_DIR" ] && [ -d "$HOME/Видео" ]; then VIDEO_DIR="$HOME/Видео"; fi
if [ ! -d "$PIC_DIR" ] && [ -d "$HOME/Изображения" ]; then PIC_DIR="$HOME/Изображения"; fi

MODE="Turbo"
MODE_CODE="instant"
AUTO_BOOL="true"
AUTO_TXT="ON"

# --- 4. MAIN MENU ---
while true; do
    ACT=$(kdialog --title "$T_TITLE" --geometry 650x800 --icon "$LOGO" \
          --menu "$HEADER\n\n$T_MAIN" \
          "install" "$T_BTN_INSTALL" \
          "folders" "$T_BTN_FOLDERS" \
          "mode"    "$T_BTN_MODE ($MODE)" \
          "auto"    "$T_BTN_AUTO ($AUTO_TXT)" \
          "uninst"  "$T_BTN_UNINSTALL" \
          "exit"    "$T_BTN_EXIT")

    case $ACT in
        "folders")
             while true; do
                F=$(kdialog --title "$T_BTN_FOLDERS" --icon "folder-blue" --menu "$HEADER\n\n$T_F_TITLE\n\n$T_F_DESC" \
                    "w" "$T_W: $WATCH_DIR" \
                    "v" "$T_V: $VIDEO_DIR" \
                    "p" "$T_P: $PIC_DIR" \
                    "b" "$T_BACK")
                case $F in
                    "w") N=$(kdialog --getexistingdirectory "$WATCH_DIR"); [ "$N" ] && WATCH_DIR="$N" ;;
                    "v") N=$(kdialog --getexistingdirectory "$VIDEO_DIR"); [ "$N" ] && VIDEO_DIR="$N" ;;
                    "p") N=$(kdialog --getexistingdirectory "$PIC_DIR"); [ "$N" ] && PIC_DIR="$N" ;;
                    *) break ;;
                esac
             done ;;
        "mode")
             M=$(kdialog --title "$T_BTN_MODE" --icon "configure" --radiolist "$HEADER\n\n$T_M_TITLE\n\n$T_M_DESC" \
                 "instant" "$T_M1" on \
                 "ask"     "$T_M2" off \
                 "silent"  "$T_M3" off)
             if [ "$M" ]; then MODE_CODE="$M"; case $M in "instant") MODE="Turbo";; "ask") MODE="Interactive";; "silent") MODE="Silent";; esac; fi ;;
        "auto")
             if [ "$AUTO_BOOL" == "true" ]; then AUTO_BOOL="false"; AUTO_TXT="OFF"; else AUTO_BOOL="true"; AUTO_TXT="ON"; fi ;;
        "uninst")
             kdialog --title "Uninstall" --yesno "$HEADER\n\n$T_UNINST_CONFIRM"
             if [ $? -eq 0 ]; then
                 killall inotifywait 2>/dev/null
                 rm -f "$SCRIPT_PATH" "$DESKTOP_PATH" "$AUTO_FILE" "$ICON_DEST"
                 kdialog --msgbox "$HEADER\n\n$T_UNINST_DONE"
                 exit 0
             fi ;;
        "install") break ;;
        *) rm -rf "$TEMP_DIR"; exit 0 ;;
    esac
done

# --- 5. INSTALLATION ---
mkdir -p "$BIN_DIR" "$AUTO_DIR" "$(dirname "$ICON_DEST")"
cp "$ICON" "$ICON_DEST"
killall inotifywait 2>/dev/null

# Safe Write: Configuration
echo "#!/bin/bash" > "$SCRIPT_PATH"
echo "W='$WATCH_DIR'" >> "$SCRIPT_PATH"
echo "V='$VIDEO_DIR'" >> "$SCRIPT_PATH"
echo "P='$PIC_DIR'" >> "$SCRIPT_PATH"
echo "CD='/tmp/kscd'" >> "$SCRIPT_PATH"

# Safe Write: Logic (STRICT FILTER / ANTI-LOOP)
cat << 'EOF_LOGIC' >> "$SCRIPT_PATH"
if [ -z "$W" ] || [ ! -d "$W" ]; then exit 1; fi

inotifywait -m -e close_write -e moved_to --format "%f" "$W" | while read f; do
    # Ignore system/temp files
    if [[ "$f" == .* ]] || [[ "$f" == *.part ]] || [[ "$f" == *.moving ]]; then continue; fi
    
    # --- STRICT FILTER ---
    # Only process media files. Ignore everything else (prevent flac/exe loop).
    case "${f,,}" in 
        *.jpg|*.jpeg|*.png|*.gif|*.webp|*.heic|*.avif) type="pic" ;; 
        *.mp4|*.mkv|*.mov|*.avi|*.webm)                type="vid" ;; 
        *) continue ;; 
    esac

    # File processing
    p="$W/$f"; l="$W/$f.moving"
    [ -f "$p" ] || continue

    if mv "$p" "$l" 2>/dev/null; then
        if [ "$type" == "pic" ]; then target="$P/$f"; else target="$V/$f"; fi
        mkdir -p "$(dirname "$target")"
        
        if mv "$l" "$target"; then
EOF_LOGIC

# Safe Write: Mode Logic
if [ "$MODE_CODE" == "instant" ]; then
    cat << 'EOF_TURBO' >> "$SCRIPT_PATH"
            # Turbo Mode
            if [ ! -f "$CD" ]; then 
                touch "$CD"; (sleep 5; rm -f "$CD") & 
                xdg-open "$target" >/dev/null 2>&1
            fi
EOF_TURBO
elif [ "$MODE_CODE" == "ask" ]; then
    echo "            # Interactive Mode" >> "$SCRIPT_PATH"
    echo "            if [ ! -f \"\$CD\" ]; then" >> "$SCRIPT_PATH"
    echo "                touch \"\$CD\"; (sleep 5; rm -f \"\$CD\") &" >> "$SCRIPT_PATH"
    echo "                kdialog --title 'KDE Sorter' --yesno '$T_Q' && xdg-open \"\$target\"" >> "$SCRIPT_PATH"
    echo "            fi" >> "$SCRIPT_PATH"
fi

echo "        fi" >> "$SCRIPT_PATH"
echo "    fi" >> "$SCRIPT_PATH"
echo "done" >> "$SCRIPT_PATH"
chmod +x "$SCRIPT_PATH"

# --- AUTOSTART (ROBUST) ---
cat << EOF_DESK > "$DESKTOP_PATH"
[Desktop Entry]
Name=KDE Sorter Pro
Exec=$SCRIPT_PATH
Icon=$ICON_DEST
Type=Application
Categories=Utility;
X-GNOME-Autostart-enabled=true
EOF_DESK
chmod +x "$DESKTOP_PATH"

if [ "$AUTO_BOOL" == "true" ]; then
    cp "$DESKTOP_PATH" "$AUTO_FILE"
    chmod +x "$AUTO_FILE" # Critical for some distros
else
    rm -f "$AUTO_FILE"
fi

# Final Launch
nohup "$SCRIPT_PATH" >/dev/null 2>&1 &
kdialog --title "Success" --icon "dialog-ok" --msgbox "$HEADER\n\n$T_DONE"
rm -rf "$TEMP_DIR"

EOF_INNER
)

# ==============================================================================
# FINAL PACKAGING
# ==============================================================================
FINAL_SCRIPT="${INNER_SCRIPT//\#PLACEHOLDER_LOGO_B64/B64_LOGO=\"$WINDOW_B64\"}"
FINAL_SCRIPT="${FINAL_SCRIPT//\#PLACEHOLDER_ICON_B64/B64_ICON=\"$ICON_B64\"}"
PAYLOAD=$(echo "$FINAL_SCRIPT" | base64 -w 0)

OUT_FILE="$HOME/Desktop/KDE_Sorter_Ultimate.desktop"

cat << EOF_OUT > "$OUT_FILE"
[Desktop Entry]
Name=Install KDE Sorter Ultimate
Exec=bash -c "sed '1,/^#PAYLOAD/d' %k | base64 -d | bash"
Icon=$ICON_IMG
Type=Application
Terminal=false
Categories=System;Setup;
#PAYLOAD
$PAYLOAD
EOF_OUT

chmod +x "$OUT_FILE"
echo "✅ ULTIMATE GENERATOR READY: $OUT_FILE"
