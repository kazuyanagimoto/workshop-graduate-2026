# Empiricist’s Workflow

コード

実証研究のためのモダンなツールと作法

作者

所属

柳本和春 [](mailto:yanagimoto@econ.kobe-u.ac.jp) [![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMC1jMDYwIDYxLjEzNDc3NywgMjAxMC8wMi8xMi0xNzozMjowMCAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo1N0NEMjA4MDI1MjA2ODExOTk0QzkzNTEzRjZEQTg1NyIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDozM0NDOEJGNEZGNTcxMUUxODdBOEVCODg2RjdCQ0QwOSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDozM0NDOEJGM0ZGNTcxMUUxODdBOEVCODg2RjdCQ0QwOSIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOkZDN0YxMTc0MDcyMDY4MTE5NUZFRDc5MUM2MUUwNEREIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjU3Q0QyMDgwMjUyMDY4MTE5OTRDOTM1MTNGNkRBODU3Ii8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+84NovQAAAR1JREFUeNpiZEADy85ZJgCpeCB2QJM6AMQLo4yOL0AWZETSqACk1gOxAQN+cAGIA4EGPQBxmJA0nwdpjjQ8xqArmczw5tMHXAaALDgP1QMxAGqzAAPxQACqh4ER6uf5MBlkm0X4EGayMfMw/Pr7Bd2gRBZogMFBrv01hisv5jLsv9nLAPIOMnjy8RDDyYctyAbFM2EJbRQw+aAWw/LzVgx7b+cwCHKqMhjJFCBLOzAR6+lXX84xnHjYyqAo5IUizkRCwIENQQckGSDGY4TVgAPEaraQr2a4/24bSuoExcJCfAEJihXkWDj3ZAKy9EJGaEo8T0QSxkjSwORsCAuDQCD+QILmD1A9kECEZgxDaEZhICIzGcIyEyOl2RkgwAAhkmC+eAm0TAAAAABJRU5ErkJggg==)](https://orcid.org/0009-0007-1967-8304)

神戸大学

公開

2026年08月12日

# はじめに

## AI時代のプログラミング知識

このコースでは, AI時代に必要なプログラミング知識を学ぶという目的で作りました. プログラミングコードをAIがある程度の精度で書けるようになった今, プログラミングとはプロンプティングの技術に変わってきています. ここで求められるのは個別のパッケージや関数に関する理解ではなく, AIに適切な指示を与えられるかの能力になってきました.

このコースでは, プログラミングで何ができるのかを理解することに重きを置き, その上でAIに適切な指示を与えるための知識を学んでいきます. そのため, プログラミングの基礎的な知識は必要ですが, 個別のパッケージや関数の使い方については深くは解説しません. 分からなければAIに聞くことを推奨します.

## 環境構築

授業を始める前に次の環境構築を完了させておいてください. また, [sec-git](#sec-git) で用いるため, GitHub のアカウントも作成しておいてください. 後述するように, GitHub の Education アカウントに登録することをお勧めします.

このコースではMacまたはLinux環境での実行を想定しています. Windowsユーザーには, Windows Subsystem for Linux (WSL) 上での実行を推奨します. 以下では, エディタ (VSCode), 文献管理ソフト (Zotero), Rのバージョン管理ツール (rig), Quarto, バージョン管理システムの git のインストール手順をOS別にまとめます.

### Mac

まず, パッケージマネージャの [Homebrew](https://brew.sh/ja/) を導入します. ターミナルで以下を実行し, 画面の指示に従ってください (インストール後に表示される `brew shellenv` の設定コマンドも忘れずに実行します).

``` sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

なお, バージョン管理の git は, Homebrew を入れるときに一緒に導入される Xcode Command Line Tools に含まれているため, 別途インストールする必要はありません. `git --version` でバージョンが表示されれば導入済みです (まだなら `xcode-select --install` で入ります).

Homebrewが入れば, 必要なソフトウェアはすべて `brew` でインストールできます.

``` sh
brew install --cask visual-studio-code zotero

# rig is distributed as a cask in the r-lib/rig tap
brew tap r-lib/rig
brew install --cask rig

brew install quarto
```

R本体は rig を通じてインストールします. `rig add release` で最新の安定版が入ります.

``` sh
rig add release
```

アップデートも Homebrew 経由で行います. 以下のコマンドで, brew でインストールしたソフトウェア (VSCode, Zotero, Quarto など) がまとめて最新版になります.

``` sh
brew update && brew upgrade
```

Rの新しいバージョンがリリースされたときは, `rig add release` を再実行すれば追加されます. インストール済みのバージョンは `rig list` で確認でき, `rig default 4.5.1` のように切り替えられます (不要になった古いバージョンは `rig rm` で削除できます).

### Windows

VSCodeとZoteroはWindows側にインストールします. Windows標準のパッケージマネージャ [winget](https://learn.microsoft.com/ja-jp/windows/package-manager/winget/) を使い, PowerShellで以下を実行してください.

``` powershell
winget install Microsoft.VisualStudioCode
winget install DigitalScholar.Zotero
```

次に, WSLを導入します. 管理者権限のPowerShellで以下を実行し, 再起動後にUbuntuのユーザー名とパスワードを設定してください.

``` powershell
wsl --install
```

VSCodeには拡張機能 [WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) をインストールしておくと, WSL内のファイルをVSCodeから直接編集できます.

WSLのUbuntuでは, ソフトウェアの管理に標準のパッケージマネージャ [apt](https://ubuntu.com/server/docs/package-management) を使います. Macにおける Homebrew に相当するもので, 基本のコマンドは次の3つです.

``` sh
# refresh the package catalog and upgrade all installed packages
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl # install a package (here: curl)
```

先頭の `sudo` は, システムを変更する操作を管理者権限で実行するための命令で, 実行時にはWSLセットアップ時に設定したパスワードを聞かれます (詳しくは [sec-permission](#sec-permission) で説明します). `apt update` はパッケージの「カタログ」を最新にするだけで, 何もインストールしません. インストールやアップグレードの前には, まず `apt update` を実行するのが作法です. `-y` は, インストールやアップグレードの途中で聞かれる「続行しますか?」という質問に自動で「はい」と答えるオプションです.

この後の手順で使うダウンロードツール (curl, wget), Rのパッケージをソースコードからビルドするときに必要になるコンパイラ類 (build-essential), そしてバージョン管理の git を, ここでまとめて入れておきます.

``` sh
sudo apt update
sudo apt install -y build-essential git
```

rigとQuartoは, apt ではなく公式の配布物からWSL (Ubuntu) 側にインストールします. WSLのターミナルで以下を実行してください.

``` sh
# rig (R installation manager)
curl -Ls https://github.com/r-lib/rig/releases/download/latest/rig-linux-$(arch)-latest.tar.gz |
  sudo tar xz -C /usr/local
rig add release
```

Quartoは, バージョン番号を変数に入れて .deb パッケージをダウンロードし, インストールします.

``` sh
# Latest release as of this page's build; see https://quarto.org/docs/download/
QUARTO_VERSION=1.10.18
wget "https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb"
sudo dpkg -i "quarto-${QUARTO_VERSION}-linux-amd64.deb"
```

アップデートするときは, `QUARTO_VERSION` を新しいバージョン番号に変えて同じコマンドを再実行するだけです. Rのアップデートは Mac と同様で, `rig add release` を再実行します. apt で入れたソフトウェアは `sudo apt update && sudo apt upgrade` で, Windows側のソフトウェアは `winget upgrade --all` でまとめて更新できます.

## AI Coding Tools

私は AI coding tools として, Claude Code を主に用いますが, この授業を学ぶ上では [sec-ai-research](#sec-ai-research) 以外では必要ありません. また, [sec-ai-research](#sec-ai-research) で紹介するワークフローは, Claude Code 以外の GitHub Copilot や Codex でも同じように使えます. AI coding tools を試す, という意味では無料で始められる GitHub Copilot から始めるのがいいでしょう. しかし, 研究で本格的に使うにはある程度お金を払う必要があります.

### GitHub Copilot

GitHub Copilot は, GitHub が提供する AI コーディングアシスタントです. Visual Studio Code の拡張機能として提供されており, コードの補完や生成を支援します. Copilot は OpenAI の Codex モデルを基盤としており, プログラミング言語やフレームワークに関する知識を持っています. また, Claude や Gemini などの他のモデルも利用可能です.

学生や教員の場合は, GitHub Education のアカウントを作成することで, GitHub Pro の機能を無料で利用できます. これにより, Copilot の使用上限が無料アカウントと比べて拡大します. 教育機関の認証はやや厳しくなっていると言われており, 大学の構内からのアクセスが必要と言われています.
