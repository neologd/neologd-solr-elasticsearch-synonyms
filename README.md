# neologd-solr-elasticsearch-synonym : Japanese noun synonyms file for Elasticsearch and Solr

## For Japanese
README.ja.md is written in Japanese.

- https://github.com/neologd/neologd-solr-elasticsearch-synonym/blob/master/README.ja.md

## Overview
neologd-solr-elasticsearch-synonym is Japanese noun synonyms file which is written in Solr synonyms format.

This synonyms file includes many orthographic variant of nouns, which are common orthographic variant strings with mecab-ipadic-NEologd.

When you want to define synonyms of common nouns, neologisms and Named Entities, to begin with this synonyms file is one of better choice.

## Pros and Cons
### Pros
- Recorded about 48,000 pairs (mapping from about 0.3 million tokens) of orthographic variant of nouns.
    - One of the largest OSS synonyms file in Japan
- Update process of this synonyms file will semi-automatically run on development server.
    - I'm planning to update this synonyms file at the timing of updating a orthographic variant dictionary of mecab-ipadic-NEologd.

### Cons
- Can't distinguish between orthographic variant of nouns and same spelling homonyms.
- Not support other synonyms file format.

## Getting started

### Dependencies
This synonyms file is mainly used with following open source search server.

- Elasticsearch

OR

- Solr

### Preparation of installing
A synonyms file will distribute via GitHub repository.

In first time, you should execute the following command to 'git clone'.

    $ git clone --depth 1 https://github.com/neologd/neologd-solr-elasticsearch-synonym.git

OR

    $ git clone --depth 1 git@github.com:neologd/neologd-solr-elasticsearch-synonym.git

If you need all log of mecab-ipadic-neologd.git, you should clone the repository without '--depth 1'

### How to install/use/update neologd-solr-elasticsearch-synonym
#### Step.1
Move to a directory of the repository which was cloned in the above preparation.

    $ cd neologd-solr-elasticsearch-synonym

#### Step.2

You can install or can update(overwritten) the recent neologd-solr-elasticsearch-synonym by following command.

    $ ./bin/install-neologd-solr-elasticsearch-synonym -n

## Bibtex

Please use the following bibtex, when you refer mecab-ipadic-NEologd from your papers.

    @misc{sato2016neologdsolrelasticsearchsynonym
        title  = {neologd-solr-elasticsearch-synonym - Japanese noun synonyms file for Elasticsearch and Solr},
        author = {Toshinori, Sato},
        url    = {https://github.com/neologd/neologd-solr-elasticsearch-synonym},
        year   = {2015}
    }

## Star please !!
Please star this github repository if mecab-ipadic-NEologd is very useful to your project ;)

## Copyrights
Copyright (c) 2015-2016 Toshinori Sato (@overlast) All rights reserved.

We select the 'Apache License, Version 2.0'. Please check following link.

- https://github.com/neologd/neologd-solr-elasticsearch-synonym/blob/master/COPYING
