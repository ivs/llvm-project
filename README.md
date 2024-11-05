# C++ Codebase Indexer for RAG

## 🚀 Purpose

Codebase Indexer is a research project aimed at extracting detailed C++ code, including symbols, references, and relations, into a database for building Retrieval-Augmented Generation (RAG) systems. The extracted data, such as references and relations, is well-suited for constructing knowledge graphs to support GraphRAG-like systems, enabling advanced code search and contextual AI applications.

**Note**: This project is built on top of `clangd` and involves a small patch to enhance its capabilities. It does not attribute or modify the entirety of the `clangd` codebase but rather extends its functionality for specialized data extraction.

## ⚠️ Notice

This project is in its early stages and should be considered a draft for research purposes. Features and functionality are subject to change as development and experimentation continue.

## ⚙️ How It Works

- **🔍 Extraction**: Collects C++ symbols, references, and relations as provided by `clangd`. Each symbol is exported with its associated documentation (if available), expanded macros, namespaces, and the actual code of the symbol (e.g., function or class declarations/definitions).
- **📄 TSV Export**: Outputs the extracted data into `symbols.tsv`, `refs.tsv`, and `relations.tsv` files for easy database import.
- **💾 Database Integration**: Data is imported into ClickHouse for building a knowledge graph and enabling RAG capabilities.

## 🛠️ How to Use

### 1. Build and Run
- Build the tool using LLVM build commands. `ninja`, `cmake` and `lld`(for faster linking) should be installed. Build commands and scripts are available in the [`justfile`](https://github.com/casey/just).
```bash
mkdir build && cd build
cmake -G "Ninja" -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra" -DCMAKE_BUILD_TYPE=Debug -DLLVM_USE_LINKER=lld -DBUILD_SHARED_LIBS=ON ../llvm
ninja
```
 - Generate `compile_commands.json` for your project using [`cmake`](https://cmake.org/cmake/help/latest/variable/CMAKE_EXPORT_COMPILE_COMMANDS.html) or [`bear`](https://github.com/rizsotto/Bear).
- Run `clangd-indexer` with your `compile_commands.json` to extract symbol data. `index.yaml` is for debug purposes only; actual data is exported to `.tsv` files in the current working directory.
```bash
./build/bin/clangd-indexer path/to/compile_commands.json --executor=all-TUs --format=yaml > index.yaml
```

### 2. Import to ClickHouse
- Apply schema from `schema.sql`
- Load the generated TSV files into ClickHouse:
```bash
clickhouse-client --password="${PASS}" --query="TRUNCATE TABLE index_symbols"
clickhouse-client --password="${PASS}" --query="INSERT INTO index_symbols FORMAT TabSeparated" < symbols.tsv

clickhouse-client --password="${PASS}" --query="TRUNCATE TABLE index_relations"
clickhouse-client --password="${PASS}" --query="INSERT INTO index_relations FORMAT TabSeparated" < relations.tsv

clickhouse-client --password="${PASS}" --query="TRUNCATE TABLE index_refs"
clickhouse-client --password="${PASS}" --query="INSERT INTO index_refs FORMAT TabSeparated" < refs.tsv
```

## 🔮 Future Work
- **✅ Extraction**: Precise extraction of C++ codebase using `clangd`, with detailed symbols, references, and relations exported to ClickHouse for structured data storage.

- **⚙️ Embedding**: Work in progress. The extracted code snippets will be embedded to support classical RAG systems, enabling effective retrieval-augmented generation.

- **🔬 GraphRAG Research**: The data, including references and relations, will be used for further research into knowledge graph construction to build advanced GraphRAG systems, supporting enhanced contextual search and AI-driven code analysis.

# The LLVM Compiler Infrastructure

[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/llvm/llvm-project/badge)](https://securityscorecards.dev/viewer/?uri=github.com/llvm/llvm-project)
[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/8273/badge)](https://www.bestpractices.dev/projects/8273)
[![libc++](https://github.com/llvm/llvm-project/actions/workflows/libcxx-build-and-test.yaml/badge.svg?branch=main&event=schedule)](https://github.com/llvm/llvm-project/actions/workflows/libcxx-build-and-test.yaml?query=event%3Aschedule)

Welcome to the LLVM project!

This repository contains the source code for LLVM, a toolkit for the
construction of highly optimized compilers, optimizers, and run-time
environments.

The LLVM project has multiple components. The core of the project is
itself called "LLVM". This contains all of the tools, libraries, and header
files needed to process intermediate representations and convert them into
object files. Tools include an assembler, disassembler, bitcode analyzer, and
bitcode optimizer.

C-like languages use the [Clang](https://clang.llvm.org/) frontend. This
component compiles C, C++, Objective-C, and Objective-C++ code into LLVM bitcode
-- and from there into object files, using LLVM.

Other components include:
the [libc++ C++ standard library](https://libcxx.llvm.org),
the [LLD linker](https://lld.llvm.org), and more.

## Getting the Source Code and Building LLVM

Consult the
[Getting Started with LLVM](https://llvm.org/docs/GettingStarted.html#getting-the-source-code-and-building-llvm)
page for information on building and running LLVM.

For information on how to contribute to the LLVM project, please take a look at
the [Contributing to LLVM](https://llvm.org/docs/Contributing.html) guide.

## Getting in touch

Join the [LLVM Discourse forums](https://discourse.llvm.org/), [Discord
chat](https://discord.gg/xS7Z362),
[LLVM Office Hours](https://llvm.org/docs/GettingInvolved.html#office-hours) or
[Regular sync-ups](https://llvm.org/docs/GettingInvolved.html#online-sync-ups).

The LLVM project has adopted a [code of conduct](https://llvm.org/docs/CodeOfConduct.html) for
participants to all modes of communication within the project.
