# tpersist-examples

Each numbered example is a complete Tcl script. The database examples use
in-memory SQLite and require `tpersist-sqlite`. The query-composition example
only needs `tpersist`. The JSON schema example also requires `tjson 1.0.27`
or newer and reads its schema from `sql/`.

Examples use the concise `-expr` syntax, with the previous dictionary-builder
form preserved beside it as comments. Both forms produce the same statement
structures; named parameters in strings use the default `auto` type.

From the package checkout:

```sh
ttrek install
ttrek run -- tclsh 01_crud.tcl
```

After installing the package as a dependency, `package require tpersist-examples`
sets `::tpersist_examples::directory` to the directory containing the scripts.

| Example | Demonstrates |
|---|---|
| [01_crud.tcl](01_crud.tcl) | Table metadata, inserts, reusable parameters, pagination, arithmetic updates, RETURNING, deletes |
| [02_query_composition.tcl](02_query_composition.tcl) | Query branching, AND/OR, LIKE, IN, NULL predicates, three dialects, offline compilation |
| [03_joins_and_schema.tcl](03_joins_and_schema.tcl) | TclOO queries, foreign keys, indexes, left joins, aliases, grouping, aggregates, HAVING, row iteration |
| [04_transactions.tcl](04_transactions.tcl) | TclOO transactions, atomic updates, nested scopes, error recovery, explicit savepoints via a borrowed connection |
| [05_types_and_nulls.tcl](05_types_and_nulls.tcl) | Wide integers, Unicode, byte arrays, exact text, NULL versus empty strings |
| [06_optional_oo.tcl](06_optional_oo.tcl) | Separate TclOO package, query methods, forks, procedural interoperability, automatic cleanup |
| [07_json_schema.tcl](07_json_schema.tcl) | Apply a versioned schema file repeatedly, preserving existing data |

For PostgreSQL or MySQL, use the same statement builders with a connection:

```tcl
set db [db_connect -dialect postgresql -host localhost \
    -database example -user app -password $password]
# Or: -dialect mysql
try {
    db_transaction $db {
        # Builder form: db_where [db_select users -columns {id name}] \
        #     [db_eq [db_col name] [db_param name -type text]]
        set query [db_where [db_select users -expr {id, name}] -expr {name = :name}]
        set result [db_execute $db $query -params [dict create name Alice]]
    }
    puts [dict get $result rows]
} finally {
    db_disconnect $db
}
```

Use a dedicated test database for experiments. MySQL does not support
`db_returning`; schema commands must run outside active MySQL transactions.
