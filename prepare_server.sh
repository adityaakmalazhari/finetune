#!/bin/bash

# Pastikan script dijalankan dengan hak akses root (sudo)
if [ "$(id -u)" -ne 0 ]; then
    echo "Harap jalankan dengan sudo."
    exit 1
fi

# Update dan upgrade paket sistem
echo "Melakukan update dan upgrade sistem..."
apt-get update -y && apt-get upgrade -y

apt-get install zip

# Instalasi python3 dan pip (jika belum terpasang)
echo "Memastikan Python3 dan pip terpasang..."
apt-get install python3 python3-pip python3-dev -y

# Install virtualenv jika belum terpasang
echo "Memasang virtualenv..."
pip3 install virtualenv

# Membuat virtual environment
echo "Membuat virtual environment..."
python3 -m venv venv

# Mengaktifkan virtual environment
echo "Mengaktifkan virtual environment..."
source venv/bin/activate

# Memastikan pip terbaru
echo "Memperbarui pip..."
pip install --upgrade pip

# Install CUDA Toolkit (hanya untuk server dengan GPU NVIDIA)
echo "Memasang CUDA toolkit (pastikan NVIDIA GPU dan CUDA driver sudah terpasang)..."
apt-get install nvidia-cuda-toolkit -y

# Install PyTorch dengan dukungan CUDA (untuk GPU)
echo "Memasang PyTorch dengan dukungan CUDA..."
pip install torch torchvision torchaudio

# Install dependensi lain yang diperlukan oleh proyek
echo "Memasang dependensi tambahan..."
pip install -r requirements.txt

# Clone repositori dari GitHub
echo "Cloning source code dari GitHub..."
git clone https://github.com/adityaakmalazhari/finetune.git

# Pindah ke folder proyek
cd finetune

# Install requirement python
pip install -r requirements.txt

# Download dataset
wget -O datasets-1.zip https://www.dropbox.com/scl/fi/thia3ie23faixc5wl6r2p/mozilla-common-voice-20.zip?rlkey=azearu8c1m3t38lm6dcs98zam&st=yesanmgw&dl=0

# Unzip dataset
unzip datasets-1.zip -d ./

# Download checkpoint
python download_checkpoint.py --output_path checkpoints/

# Extend vocab
python extend_vocab_config.py --output_path=checkpoints/ --metadata_path datasets-1/metadata_train.csv --language id --extended_vocab_size 2000

echo "Persiapan environment selesai. Anda siap untuk mulai training!"
