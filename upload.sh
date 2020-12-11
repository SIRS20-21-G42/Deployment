adb connect <IP>:5555
adb push <PATH> /data/local/tmp/index.png
adb shell <<EOF
su
mv /data/local/tmp/index.png /data/data/com.example.sirsapp/files/qr.png
EOF
