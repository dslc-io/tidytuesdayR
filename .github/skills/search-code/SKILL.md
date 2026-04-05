---
name: search-code
trigger: search / rewrite code
description: Search and rewrite R source code by syntax using astgrepr. Use when asked to find patterns in code, search for function calls, identify usage of specific arguments, locate structural patterns across R files, or perform find-and-replace on code structure.
---

# Search and rewrite code with astgrepr

`{astgrepr}` enables AST-based code search — structural queries that regex can't express cleanly. If not installed: `install.packages("astgrepr")`

```r
library(astgrepr)

src <- "
add    <- function(x, y)                x + y
greet  <- function(name, greeting, sep) paste0(greeting, sep, name)
square <- function(x)                   x^2
"
root <- src |> tree_new() |> tree_root()  # or tree_new(file = "R/my_file.R")

# µNAME/µA/µB capture matched nodes; only `add` matches (2 params)
matches <- node_find_all(root,
  ast_rule(id = "two_arg", pattern = "µNAME <- function(µA, µB) µBODY")
)
matches                   #> <List of 1 rule>  |--two_arg: 1 nodes
node_text_all(matches)    # source text of each match
lapply(matches$two_arg, \(n) node_get_match(n, "NAME") |> node_text())  #> "add"
```

## Reference

Metavariables: `µVAR` captures one node (uppercase only); `µµµ` captures zero or more (ellipsis). In *replacement* strings, refer to captures as `~~VAR~~`.

`ast_rule()` — see `?ast_rule`. Key args:

- `pattern` — code pattern with metavariables
- `kind` — tree-sitter node kind; see the [R grammar](https://github.com/r-lib/tree-sitter-r/blob/main/src/grammar.json)
- `regex` — match node text with a Rust regex
- `id` — names the rule; results accessible as `matches$id`
- `inside`, `has`, `precedes`, `follows` — relational rules, each takes another `ast_rule()`
- `all`, `any`, `not` — boolean combinators, each takes a list of `ast_rule()`s

For advanced pattern syntax: [ast-grep pattern docs](https://ast-grep.github.io/guide/pattern-syntax.html).

## Searching across files

```r
lapply(list.files("R", pattern = "\\.R$", full.names = TRUE), \(f) {
  root  <- tree_root(tree_new(file = f))
  texts <- node_find_all(root, ast_rule(id = "r", pattern = "YOUR_PATTERN")) |>
    node_text_all() |> _$r
  if (length(texts) > 0) list(file = basename(f), matches = texts)
}) |> Filter(Negate(is.null), x = _)
```

## Patterns

```r
ast_rule(pattern = "if (µµµ) { return(µµµ) } else µµµ")   # if-else with return()
ast_rule(pattern = "util_fun(debug = µµµ)")                 # named argument
ast_rule(kind    = "while_statement")                       # by node kind
ast_rule(pattern = "df$µCOL")                              # df$col, any column
ast_rule(pattern = "print(µA)",                            # relational: inside loop
         inside  = ast_rule(any = ast_rule(kind = c("for_statement", "while_statement"))))
ast_rule(any = list(ast_rule(pattern = "any(is.na(µµµ))"), # boolean OR
                    ast_rule(pattern = "any(duplicated(µµµ))")))
```

## Find and replace

See `?node_replace_all`, `?tree_rewrite`.

```r
root  <- tree_root(tree_new(file = "R/my_file.R"))
fixes <- root |>
  node_find_all(
    ast_rule(id = "any_na",  pattern = "any(is.na(µVAR))"),
    ast_rule(id = "any_dup", pattern = "any(duplicated(µVAR))")
  ) |>
  node_replace_all(any_na  = "anyNA(~~VAR~~)",
                   any_dup = "anyDuplicated(~~VAR~~) > 0")
tree_rewrite(root, fixes)                                  # preview
writeLines(tree_rewrite(root, fixes), con = "R/my_file.R") # write back
```
