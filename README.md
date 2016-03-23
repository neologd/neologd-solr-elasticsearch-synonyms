# neologd-solr-elasticsearch-synonyms : Japanese noun synonyms file for Elasticsearch and Solr

## For Japanese
README.ja.md is written in Japanese.

- https://github.com/neologd/neologd-solr-elasticsearch-synonyms/blob/master/README.ja.md

## Overview
neologd-solr-elasticsearch-synonyms is Japanese noun synonyms file which is written in Solr synonyms format.

This synonyms file includes many orthographic variant strings of nouns, which are common orthographic variant strings with mecab-ipadic-NEologd.

When you want to define synonyms of common nouns, neologisms and Named Entities, to try to apply this synonyms file is one of better choice.

## Pros and Cons
### Pros
- Recorded about 65,500 pairs (mapping from about 0.33 million tokens) of orthographic variant of nouns.
    - One of the largest Japanese OSS synonyms file
- Update process of this synonyms file will semi-automatically run on development server.
    - I'm planning to update this synonyms file at the timing of updating a orthographic variant dictionary of mecab-ipadic-NEologd.
- The location of symbolic link to recent synonyms file is permanent
    - When you will updating synonyms file, it's unnecessary to update a configure file of search server.

### Cons
- Can't distinguish between orthographic variant of nouns and same spelling homonyms.
- Not support other synonyms file format.

## Getting started

### Dependencies
This synonyms file can use with following open source search server.

- Elasticsearch

OR

- Solr

### Preparation of installing
A synonyms file will distribute via GitHub repository.

In first time, you should execute the following command to 'git clone'.

    $ git clone --depth 1 https://github.com/neologd/neologd-solr-elasticsearch-synonyms.git

OR

    $ git clone --depth 1 git@github.com:neologd/neologd-solr-elasticsearch-synonyms.git

If you need all log of mecab-ipadic-neologd.git, you should clone the repository without '--depth 1'

### How to install/use/update neologd-solr-elasticsearch-synonyms
#### Step.1
Move to neologd-solr-elasticsearch-synonyms directory  which was cloned in the above preparation.

    $ cd neologd-solr-elasticsearch-synonyms

#### Step.2
You can install or can update(overwritten) the recent neologd-solr-elasticsearch-synonyms by following command.

    $ ./bin/install-neologd-solr-elasticsearch-synonyms -n

#### Step.3
You should check content of neologd-synonyms.txt.

Default install location is neologd-solr-elasticsearch-synonyms/synonyms directory.

    $ cd neologd-solr-elasticsearch-synonyms
    $ cat synonyms/neologd-synonyms.txt | grep "お好み焼き"
    "おこのみやき", "おこのみヤキ", "おこのみ焼", "おこのみ焼き", "おコノミやき",
    "おコノミヤキ", "お コノミ焼", "おコノミ焼き", "お好みやき", "お好みヤキ", "お好み焼",
    "お好やき", "お好ヤキ", "お好焼", "お好焼き", "オこのみやき", "オこのみヤキ", "オこのみ焼",
    "オこのみ焼き", "オコノミやき", "オコノミヤキ", "オコノミ焼", "オコノミ焼き", "オ好みやき",
    "オ好みヤキ", "オ好み焼", "オ好み焼き", "オ好やき", "オ好ヤキ", "オ好焼", "オ好焼き"
    => "お好み焼き"

Our installer creates a permanent symbolic link to recent synonyms file(neologd-synonyms.YYYYMMDD.txt).

    $ ls -al neologd-solr-elasticsearch-synonyms/synonyms
    合計 5756
    drwxrwxr-x 2 overlast overlast    4096  2月 10 18:26 2016 .
    drwxrwxr-x 8 overlast overlast    4096  2月 10 19:00 2016 ..
    -rw-rw-r-- 1 overlast overlast 5878409  2月 10 18:26 2016 neologd-synonyms.20160209.txt
    lrwxrwxrwx 1 overlast overlast      99  2月 10 18:26 2016 neologd-synonyms.txt -> /any/where/neologd-solr-elasticsearch-synonyms/bin/../synonyms/neologd-synonyms.20160209.txt

If you want to install recent synonyms file to optional location, you can use "-p" option.

    $ ./bin/install-neologd-solr-elasticsearch-synonyms -n -p /absolute/path/where/you/want/to/install

You can check useful command line option using "-h" option.

    $ ./bin/install-mecab-ipadic-neologd -h

### How to use neologd-solr-elasticsearch-synonyms
When you want to use neologd-solr-elasticsearch-synonyms, you should set the path of synonyms file as a value of synonyms_path property of Elasticsearch/Solr.

When you will updating synonyms file, it's unnecessary to update a configure file of search server, because the location of symbolic link to recent synonyms file is permanent.

#### Example of snippet of config of Elasticsearch

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

#### Example of snippet of config of Solr

    <fieldType name="text_ja" class="solr.TextField" positionIncrementGap="100">
        <analyzer>
            <tokenizer class="solr.JapaneseTokenizerFactory"/>
            <filter class="solr.SynonymFilterFactory" synonyms="/absolute/path/of/neologd-synonym.txt" ignoreCase="true" expand="false">
        </analyzer>
    </fieldType>

## Bibtex

Please use the following bibtex, when you refer mecab-ipadic-NEologd from your papers.

    @misc{sato2016neologdsolrelasticsearchsynonym
        title  = {neologd-solr-elasticsearch-synonyms - Japanese noun synonyms file for Elasticsearch and Solr},
        author = {Toshinori, Sato},
        url    = {https://github.com/neologd/neologd-solr-elasticsearch-synonyms},
        year   = {2015}
    }

## Star please !!
Please star this github repository if mecab-ipadic-NEologd is very useful to your project ;)

## NOTICE
This project is depending to other OSS projects. Please check following link.

- https://github.com/neologd/neologd-solr-elasticsearch-synonyms/blob/master/NOTICE.md

## Copyrights
Copyright (c) 2015-2016 Toshinori Sato (@overlast) All rights reserved.

We select the 'Apache License, Version 2.0'. Please check following link.

- https://github.com/neologd/neologd-solr-elasticsearch-synonyms/blob/master/COPYING
