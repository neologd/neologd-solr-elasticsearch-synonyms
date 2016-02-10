#!/usr/bin/env bash

# Copyright (C) 2015-2016 Toshinori Sato (@overlast)
#
#       https://github.com/neologd/neologd-solr-elasticsearch-synonym
#
# Licensed under the Apache License, Version 2.0 (the &quot;License&quot;);
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an &quot;AS IS&quot; BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

BASEDIR=$(cd $(dirname $0);pwd)
ECHO_PREFIX="[install-neologd-solr-elasticsearch-synonym] :"

echo "$ECHO_PREFIX Start.."

INSTALL_AS_SUDOER=0
INSTALL_DIR_PATH=${BASEDIR}/../synonyms

while getopts p:u: OPT
do
  case $OPT in
    "p" ) INSTALL_DIR_PATH=$OPTARG ;;
    "s" ) INSTALL_AS_SUDOER=$OPTARG ;;
  esac
done

YMD=`ls -ltr \`find ${BASEDIR}/../archive/neologd-synonyms.*.txt.xz\` | egrep -o '[0-9]{8}' | tail -1`
SYNONYM_FILE_NAME=neologd-synonyms.${YMD}.txt
LATEST_SYNONYM_FILE_NAME=neologd-synonyms.txt

if [ ! -e ${INSTALL_DIR_PATH} ]; then
    echo "${ECHO_PREFIX} ${INSTALL_DIR_PATH} isn't there."
    echo "${ECHO_PREFIX} You should execute bin/install-neologd-solr-elasticsearch-synonym first."
    exit 1
fi

COMMAND_PREFIX=""
if [ ${INSTALL_AS_SUDOER} -eq 1 ]; then
    echo "$ECHO_PREFIX Install to ${INSTALL_DIR_PATH} as sudoer"
    COMMAND_PREFIX="sudo"
else
    echo "$ECHO_PREFIX Install archive/${SYNONYM_FILE_NAME}.xz to ${INSTALL_DIR_PATH}"
fi

if [ -f ${INSTALL_DIR_PATH}/${SYNONYM_FILE_NAME}.xz ]; then
    ${COMMAND_PREFIX} rm -f ${INSTALL_DIR_PATH}/${SYNONYM_FILE_NAME}.xz
fi
${COMMAND_PREFIX} cp ${BASEDIR}/../archive/${SYNONYM_FILE_NAME}.xz ${INSTALL_DIR_PATH}

if [ -f ${INSTALL_DIR_PATH}/${SYNONYM_FILE_NAME} ]; then
    ${COMMAND_PREFIX} rm ${INSTALL_DIR_PATH}/${SYNONYM_FILE_NAME}
fi
${COMMAND_PREFIX} unxz ${INSTALL_DIR_PATH}/${SYNONYM_FILE_NAME}.xz

if [ -f ${INSTALL_DIR_PATH}/${LATEST_SYNONYM_FILE_NAME} ]; then
    ${COMMAND_PREFIX} rm ${INSTALL_DIR_PATH}/${LATEST_SYNONYM_FILE_NAME}
fi
${COMMAND_PREFIX} ln -s ${INSTALL_DIR_PATH}/${SYNONYM_FILE_NAME} ${INSTALL_DIR_PATH}/${LATEST_SYNONYM_FILE_NAME}

if [ -f ${INSTALL_DIR_PATH}/${LATEST_SYNONYM_FILE_NAME} ]; then
    echo ""
    echo "${ECHO_PREFIX} Install completed."
    echo ""
    echo "    Please check ${INSTALL_DIR_PATH}/${LATEST_SYNONYM_FILE_NAME}"
    echo ""
    echo "${ECHO_PREFIX} When you use Solr, you can set ${LATEST_SYNONYM_FILE_NAME} as a value of synonyms property of solr.SynonymFilterFactory class."
    echo "    Reference: https://wiki.apache.org/solr/AnalyzersTokenizersTokenFilters#solr.SynonymFilterFactory"
    echo ""
    echo "${ECHO_PREFIX} When you use Elasticsearch, you can set ${LATEST_SYNONYM_FILE_NAME} as a value of synonyms_path property of Synonym Token Filter."
    echo "    Reference: https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-synonym-tokenfilter.html"
    echo ""
    echo "${ECHO_PREFIX} Usage of neologd-solr-elasticsearch-synonym is here."
    echo "Usage:"
    echo "    Example of snippet of config of Elasticsearch:"
    echo "        {"
    echo '            "index" : {'
    echo '                "analysis" : {'
    echo '                    "analyzer" : {'
    echo '                        "synonym" : {'
    echo '                            "tokenizer" : "kuromoji_neologd_tokenizer",'
    echo '                            "filter" : ["synonym"]'
    echo '                        }'
    echo '                    },'
    echo '                    "filter" : {'
    echo '                        "synonym" : {'
    echo '                            "type" : "synonym",'
    echo "                            \"synonyms_path\" : \"${INSTALL_DIR_PATH}/${LATEST_SYNONYM_FILE_NAME}\""
    echo '                        }'
    echo '                    }'
    echo '                }'
    echo '            }'
    echo '        }'
    echo ""
    echo "    Example of snippet of schema.xml of Solr"
    echo '        <fieldType name="text_ja" class="solr.TextField" positionIncrementGap="100">'
    echo '            <analyzer>'
    echo '                <tokenizer class="solr.JapaneseTokenizerFactory"/>'
    echo "                <filter class="solr.SynonymFilterFactory" synonyms=\"${INSTALL_DIR_PATH}/${LATEST_SYNONYM_FILE_NAME}\" ignoreCase=\"true\" expand=\"false\">"
    echo '            </analyzer>'
    echo '        </fieldType>'
    echo ""
else
    echo "${ECHO_PREFIX} ${INSTALL_DIR_PATH} can't be found. Install Failed."
fi

echo "$ECHO_PREFIX Finish.."
