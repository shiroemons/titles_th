# titles_th

titles_thとは、曲目ファイルを生成するスクリプトです。

## 動作環境

- OS: Windows 10
- 言語: Ruby 2.7以上が実行できること
  - [RubyInstaller](https://rubyinstaller.org/)でインストールできます。

## 準備するもの

- [Brightmoon](https://wikiwiki.jp/thtools/Brightmoon)を利用して以下をファイルを、`titles_th.rb`と同じ場所に配置する。
  - 製品版
    - thbgm.fmt
    - musiccmt.txt
  - 体験版
    - thbgm_tr.fmt
    - musiccmt_tr.txt

## 使い方

1. 以下のコマンドを実行する
  ```sh
  ruby titles_th.rb
  ```
2. `titles_th.txt`または、`titles_th_tr.txt`が生成される
  - 出力ファイルには、以下の情報が含まれています。
    - 開始位置[Bytes]、イントロ部の長さ[Bytes]、ループ部の長さ[Bytes]、曲名

## License

MIT