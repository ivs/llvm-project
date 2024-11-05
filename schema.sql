CREATE TABLE default.index_symbols
(
    `id` String,
    `name` String,
    `scope` String,
    `kind` String,
    `language` String,
    `decl_location_uri` String,
    `decl_start_line` UInt32,
    `decl_start_col` UInt32,
    `decl_end_line` UInt32,
    `decl_end_col` UInt32,
    `def_location_uri` String,
    `def_start_line` UInt32,
    `def_start_col` UInt32,
    `def_end_line` UInt32,
    `def_end_col` UInt32,
    `full_location_uri` String,
    `full_start_line` UInt32,
    `full_start_col` UInt32,
    `full_end_line` UInt32,
    `full_end_col` UInt32,
    `body` String
)
ENGINE = MergeTree
ORDER BY (id, name)
SETTINGS index_granularity = 8192

CREATE TABLE default.index_refs
(
    `symbol_id` String,
    `kind` String,
    `location_uri` String,
    `start_line` UInt32,
    `start_col` UInt32,
    `end_line` UInt32,
    `end_col` UInt32,
    `container_id` String
)
ENGINE = MergeTree
ORDER BY (symbol_id, location_uri, start_line)
SETTINGS index_granularity = 8192

CREATE TABLE default.index_relations
(
    `subject_id` String,
    `predicate` String,
    `object_id` String
)
ENGINE = MergeTree
ORDER BY (subject_id, object_id)
SETTINGS index_granularity = 8192