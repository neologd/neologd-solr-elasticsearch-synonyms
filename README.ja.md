# neologd-solr-elasticsearch-synonym : Elasticsearch と Solr 用の日本語名詞のシノニムファイル

## Overview
neologd-solr-elasticsearch-synonym は Solr synonyms フォーマットな日本語名詞のシノニムファイルです。

このシノニムファイルは mecab-ipadic-NEologd と共通な大量の名詞の表記ゆれ文字列を含んでいます。

もしも名詞や新語、固有表現のシノニム(同義語)を定義したいと思った場合、このシノニムファイルを適用することを試すのは良い選択のひとつです。

## 利点と欠点
### 利点
- 約 48,000 組(約30万種類のトークンと対応付けられている)の名詞の表記ゆれを採録している
    - 最も大きい OSS な日本語のシノニムファイルのひとつ
- シノニムファイルの更新処理がサーバ上で半自動化されている
    - mecab-ipadic-NEologd の表記ゆれ辞書が更新された時に、シノニムファイルを更新する予定
- 最新のシノニムファイルに対するシンボリックリンクの位置が固定
    - 更新する際に検索サーバーの設定ファィルの更新が不要

### 欠点
- 表記ゆれと同表記異義語の区別をつけることはできない
    - 文字列の表層のみに基づいて文字列をまとめるから
- 他のシノニムファイルの形式に対応していない

## 使用開始

### 動作に必要なもの
おもに以下のオープンソースな検索サーバーで使えます

- Elasticsearch

または

- Solr

### インストールする準備
シノニムファイルの配布と更新は GitHub 経由で行います。

初回は以下のコマンドでgit cloneしてください。

    $ git clone --depth 1 https://github.com/neologd/neologd-solr-elasticsearch-synonym.git

または

    $ git clone --depth 1 git@github.com:neologd/neologd-solr-elasticsearch-synonym.git

もしも、リポジトリの全変更履歴を入手したい方は「--depth 1」を消してcloneして下さい。

### neologd-solr-elasticsearch-synonym のインストール/更新
#### Step.1
上記の準備でcloneしたリポジトリに移動します。

    $ cd neologd-solr-elasticsearch-synonym

#### Step.2
以下のコマンドを実行するとインストール、または、上書きによる最新版への更新ができます。

    $ ./bin/install-neologd-solr-elasticsearch-synonym -n

#### Step.3
インストールがうまくいったら neologd-synonyms.txt の中身を確認しておきましょう。

インストール先はオプション未指定の場合 neologd-solr-elasticsearch-synonym/synonyms ディレクトリです。

    $ cd neologd-solr-elasticsearch-synonym
    $ cat synonyms/neologd-synonyms.txt | grep "お好み焼き"
    "おこのみやき", "おこのみヤキ", "おこのみ焼", "おこのみ焼き", "おコノミやき",
    "おコノミヤキ", "お コノミ焼", "おコノミ焼き", "お好みやき", "お好みヤキ", "お好み焼",
    "お好やき", "お好ヤキ", "お好焼", "お好焼き", "オこのみやき", "オこのみヤキ", "オこのみ焼",
    "オこのみ焼き", "オコノミやき", "オコノミヤキ", "オコノミ焼", "オコノミ焼き", "オ好みやき",
    "オ好みヤキ", "オ好み焼", "オ好み焼き", "オ好やき", "オ好ヤキ", "オ好焼", "オ好焼き"
    => "お好み焼き"

インストーラーは最新のシノニムファイル(neologd-synonyms.YYYYMMDD.txt)に対する固定のシンボリックリンクを作成します。

    $ ls -al neologd-solr-elasticsearch-synonym/synonyms
    合計 5756
    drwxrwxr-x 2 overlast overlast    4096  2月 10 18:26 2016 .
    drwxrwxr-x 8 overlast overlast    4096  2月 10 19:00 2016 ..
    -rw-rw-r-- 1 overlast overlast 5878409  2月 10 18:26 2016 neologd-synonyms.20160209.txt
    lrwxrwxrwx 1 overlast overlast      99  2月 10 18:26 2016 neologd-synonyms.txt -> /any/where/neologd-solr-elasticsearch-synonym/bin/../synonyms/neologd-synonyms.20160209.txt

もしも最新のシノニムファイルを任意の場所にインストールしたい場合は "-p" オプションを使ってください。

    $ ./bin/install-neologd-solr-elasticsearch-synonym -n -p /absolute/path/where/you/want/to/install

便利なコマンドラインオプションは "-h" オプションを使うと確認できます。

    $ ./bin/install-mecab-ipadic-neologd -h

### neologd-solr-elasticsearch-synonym の使い方
neologd-solr-elasticsearch-synonym を使いたい時は、シノニムファイルの絶対パスを Elasticsearch/Solr の synonyms_path 属性などの値として設定してください。

最新のシノニムファイルに対するシンボリックリンクの位置は固定なので、シノニムファイルを更新する際に検索サーバーの設定ファィルを更新する必要はありません。

#### 例: Elasticsearch の config の一部

    {
        "index" : {
            "analysis" : {
                "analyzer" : {
                    "synonym" : {
                        "tokenizer" : "kuromoji_neologd_tokenizer",
                        "filter" : ["synonym"]
                    }
                },
                "filter" : {
                    "synonym" : {
                        "type" : "synonym",
                        "synonyms_path" : "/absolute/path/of/neologd-synonym.txt"
                    }
                }
            }
        }
    }

#### 例: Solr の schema.xml の一部

    <fieldType name="text_ja" class="solr.TextField" positionIncrementGap="100">
        <analyzer>
            <tokenizer class="solr.JapaneseTokenizerFactory"/>
            <filter class="solr.SynonymFilterFactory" synonyms="/absolute/path/of/neologd-synonym.txt" ignoreCase="true" expand="false">
        </analyzer>
    </fieldType>

## Bibtex
もしも neologd-solr-elasticsearch-synonym を論文や書籍、アプリ、サービスから参照して下さる場合は、以下の bibtex をご利用ください。

    @misc{sato2016neologdsolrelasticsearchsynonym
        title  = {neologd-solr-elasticsearch-synonym - Japanese noun synonyms file for Elasticsearch and Solr},
        author = {Toshinori, Sato},
        url    = {https://github.com/neologd/neologd-solr-elasticsearch-synonym},
        year   = {2015}
    }

## Star please !!
neologd-solr-elasticsearch-synonym を使ってみて良い結果が得られた時は、ぜひこのリポジトリの Star ボタンを押して下さい。

とても大きな励みになります。

## NOTICE
このプロジェクトは他のOSSプロジェクトに依存しています。下記をご参照下さい。

- https://github.com/neologd/neologd-solr-elasticsearch-synonym/blob/master/NOTICE.md

## Copyrights
Copyright (c) 2015-2016 Toshinori Sato (@overlast) All rights reserved.

ライセンスは Apache License, Version 2.0 です。下記をご参照下さい。

- https://github.com/neologd/neologd-solr-elasticsearch-synonym/blob/master/COPYING
