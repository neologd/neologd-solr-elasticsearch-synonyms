# neologd-solr-elasticsearch-synonyms : Elasticsearch と Solr 用の日本語名詞のシノニムファイル

## Overview
neologd-solr-elasticsearch-synonyms は Solr synonyms フォーマットな日本語名詞のシノニムファイルです。

このシノニムファイルは mecab-ipadic-NEologd と共通な大量の名詞の表記ゆれ文字列を含んでいます。

もしも名詞や新語、固有表現のシノニム(同義語)を定義したいと思った場合は、まずこのシノニムファイルを試すのがベターな選択のひとつです。

## 利点と欠点
### 利点
- 約 65,500 組(約 33 万種類のトークンと対応付けられている)の名詞の表記ゆれを採録している
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

    $ git clone --depth 1 https://github.com/neologd/neologd-solr-elasticsearch-synonyms.git

または

    $ git clone --depth 1 git@github.com:neologd/neologd-solr-elasticsearch-synonyms.git

もしも、リポジトリの全変更履歴を入手したい方は「--depth 1」を消してcloneして下さい。

### neologd-solr-elasticsearch-synonyms のインストール/更新
#### Step.1
上記の準備でcloneしたリポジトリに移動します。

    $ cd neologd-solr-elasticsearch-synonyms

#### Step.2
以下のコマンドを実行するとインストール、または、上書きによる最新版への更新ができます。

    $ ./bin/install-neologd-solr-elasticsearch-synonyms -n

#### Step.3
インストールがうまくいったら neologd-synonyms.txt の中身を確認しておきましょう。

インストール先はオプション未指定の場合 neologd-solr-elasticsearch-synonyms/synonyms ディレクトリです。

    $ cd neologd-solr-elasticsearch-synonyms
    $ cat synonyms/neologd-synonyms.txt | grep "お好み焼き"
    お好み焼き, おこのみやき, おこのみ焼, おこのみ焼き, お好みやき, お好み焼, お好やき, お好焼,\
    お好焼き, オコノミヤキ, オコノミ焼, オコノミ焼キ, オ好ミヤキ, オ好ミ焼, オ好ミ焼キ,\
    オ好ヤキ, オ好焼, オ好焼キ

インストーラーは最新のシノニムファイル(neologd-synonyms.YYYYMMDD.txt)に対する固定のシンボリックリンクを作成します。

    $ ls -al neologd-solr-elasticsearch-synonyms/synonyms
    合計 5756
    drwxrwxr-x 2 overlast overlast    4096  2月 10 18:26 2016 .
    drwxrwxr-x 8 overlast overlast    4096  2月 10 19:00 2016 ..
    -rw-rw-r-- 1 overlast overlast 5878409  2月 10 18:26 2016 neologd-synonyms.20160209.txt
    lrwxrwxrwx 1 overlast overlast      99  2月 10 18:26 2016 neologd-synonyms.txt -> /any/where/neologd-solr-elasticsearch-synonyms/bin/../synonyms/neologd-synonyms.20160209.txt

もしも最新のシノニムファイルを任意の場所にインストールしたい場合は "-p" オプションを使ってください。

    $ ./bin/install-neologd-solr-elasticsearch-synonyms -n -p /absolute/path/where/you/want/to/install

便利なコマンドラインオプションは "-h" オプションを使うと確認できます。

    $ ./bin/install-mecab-ipadic-neologd -h

### neologd-solr-elasticsearch-synonyms の使い方
neologd-solr-elasticsearch-synonyms を使いたい時は、シノニムファイルの絶対パスを Elasticsearch/Solr の synonyms_path 属性などの値として設定してください。

最新のシノニムファイルに対するシンボリックリンクの位置は固定なので、シノニムファイルを更新する際に検索サーバーの設定ファィルを更新する必要はありません。

また、expand 属性の値は true か false の boolean 値を明記してください。

### expand 属性の値の役割について
Elasticsearch と Solr はシノニムファイルが CSV 形式かつ format 属性が未指定の場合に、Lucene の SolrSynonymParser の [addInternal()](https://apache.googlesource.com/lucene-solr/+/trunk/lucene/analysis/common/src/java/org/apache/lucene/analysis/synonym/SolrSynonymParser.java#80) を使ってシノニム中の各文字列の組み合わせを生成します。

その際の組み合わせ方が2種類あるので、用途に応じて expand 属性の値を明示的に選択してください。

以下に「お好み焼き,お好み焼,お好焼」というシノニムファイルのエントリを登録した場合に生成される組み合わせを示します。

expand 属性の値 | シノニムファイルのエントリ(CSV) | 生成される組み合わせ
--- | --- | ---
true | お好み焼き,お好み焼,お好焼 | [お好み焼き=>お好み焼き, お好み焼き=>お好み焼, お好み焼き=>お好焼, お好み焼=>お好み焼き, お好み焼=>お好み焼, お好み焼=>お好焼, お好焼=>お好み焼き, お好焼=>お好み焼, お好焼=>お好焼]
false | お好み焼き,お好み焼,お好焼 | [お好み焼=>お好み焼き, お好焼=>お好み焼き]

「expand = true」の場合に、addInternal()は全カラムの文字列の全組み合わせを生成します。

「expand = false」の場合には、1カラム目の文字列と2カラム目以降の各文字列との組み合わせを生成します。

neologd-solr-elasticsearch-synonyms はおもに「expand = false」で使うことを想定して開発しています。

### 設定ファイルの記述例
Elasticseach と Solr で Solr で読み込み可能なシノニムファイルを「expand = false」で読み込む際の設定ファイルの記述例を示します。

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
                        "expand": "false",
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
もしも neologd-solr-elasticsearch-synonyms を論文や書籍、アプリ、サービスから参照して下さる場合は、以下の bibtex をご利用ください。

    @misc{sato2016neologdsolrelasticsearchsynonym
        title  = {neologd-solr-elasticsearch-synonyms - Japanese noun synonyms file for Elasticsearch and Solr},
        author = {Toshinori, Sato},
        url    = {https://github.com/neologd/neologd-solr-elasticsearch-synonyms},
        year   = {2015}
    }

## Star please !!
neologd-solr-elasticsearch-synonyms を使ってみて良い結果が得られた時は、ぜひこのリポジトリの Star ボタンを押して下さい。

とても大きな励みになります。

## NOTICE
このプロジェクトは他のOSSプロジェクトに依存しています。下記をご参照下さい。

- https://github.com/neologd/neologd-solr-elasticsearch-synonyms/blob/master/NOTICE.md

## Copyrights
Copyright (c) 2015-2016 Toshinori Sato (@overlast) All rights reserved.

ライセンスは Apache License, Version 2.0 です。下記をご参照下さい。

- https://github.com/neologd/neologd-solr-elasticsearch-synonyms/blob/master/COPYING
