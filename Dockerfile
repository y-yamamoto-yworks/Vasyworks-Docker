FROM python:3.12

# Pythonの出力をバッファリングしない設定
ENV PYTHONUNBUFFERED=1

# ==========================================
# 1. OSレベルの必須パッケージと日本語環境の構築
# ==========================================
RUN apt-get update && apt-get install -y \
    locales \
    fonts-ipafont \
    gettext \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 日本語ロケール（言語）の設定
RUN sed -i -e 's/# ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8

# Vasyworksプログラムが探しているパスにフォントのリンクを作成
RUN mkdir -p /usr/share/fonts/ipa-gothic && \
    ln -s /usr/share/fonts/opentype/ipafont-gothic/ipag.ttf /usr/share/fonts/ipa-gothic/ipag.ttf

# ==========================================
# 2. Pythonプロジェクトの構築
# ==========================================
# コンテナ内の作業ディレクトリ
WORKDIR /home/web/html

# ライブラリを一括インストール
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt
