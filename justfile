# Export env variables needed by recipes
export PASS := env_var('PASS')
export SRC_DIR := env_var_or_default('SRC_DIR', '')

default:
    @just --list

build:
    cd ./build && ninja

clangd-index: build
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -n "${SRC_DIR}" ]; then
        ./build/bin/clangd-indexer ${SRC_DIR}/compile_commands.json --executor=all-TUs --format=yaml > index.yaml
    else
        echo "Please provide source directory path in SRC_DIR env var"
        exit 1
    fi

index: clangd-index
    #!/usr/bin/env bash
    set -euo pipefail
    # Truncate and insert into index_symbols
    clickhouse-client --password="${PASS}" --query="TRUNCATE TABLE index_symbols"
    clickhouse-client --password="${PASS}" --query="INSERT INTO index_symbols FORMAT TabSeparated" < symbols.tsv

    # Truncate and insert into index_relations
    clickhouse-client --password="${PASS}" --query="TRUNCATE TABLE index_relations"
    clickhouse-client --password="${PASS}" --query="INSERT INTO index_relations FORMAT TabSeparated" < relations.tsv

    # Truncate and insert into index_refs
    clickhouse-client --password="${PASS}" --query="TRUNCATE TABLE index_refs"
    clickhouse-client --password="${PASS}" --query="INSERT INTO index_refs FORMAT TabSeparated" < refs.tsv

test:
    clickhouse-client --password="${PASS}" --query="SELECT name, full_start_line, full_start_col, full_end_line, full_end_col, body FROM index_symbols FORMAT Vertical"
