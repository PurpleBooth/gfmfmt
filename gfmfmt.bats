#!/usr/bin/env bats

@test "can format a file" {
  TEMP_DIR="$(mktemp -d)"
  MD_FILE="$TEMP_DIR/file.md"
  cat <<EOC >"$MD_FILE"
Hello World
===========
EOC

  run ./gfmfmt "$TEMP_DIR/file.md"

  [ "$status" -eq 0 ]
  [ "$(cat "$MD_FILE")" = "# Hello World" ]
}

@test "can format multiple files" {
  TEMP_DIR="$(mktemp -d)"
  MD_FILE1="$TEMP_DIR/file1.md"
  cat <<EOC >"$MD_FILE1"
Hello World
===========
EOC
  MD_FILE2="$TEMP_DIR/file2.md"
  cat <<EOC >"$MD_FILE2"
Goodbye World
===========
EOC

  run ./gfmfmt "$MD_FILE1" "$MD_FILE2"

  [ "$status" -eq 0 ]
  [ "$(cat "$MD_FILE1")" = "# Hello World" ]
  [ "$(cat "$MD_FILE2")" = "# Goodbye World" ]
}

@test "can format a directory of files" {
  TEMP_DIR="$(mktemp -d)"
  MD_FILE="$TEMP_DIR/file.md"
  cat <<EOC >"$MD_FILE"
Hello World
===========
EOC

  run ./gfmfmt "$TEMP_DIR"

  [ "$status" -eq 0 ]
  [ "$(cat "$MD_FILE")" = "# Hello World" ]
}

@test "prints help without any files" {
  TEMP_DIR="$(mktemp -d)"
  MD_FILE="$TEMP_DIR/file.md"

  run ./gfmfmt

  [ "$status" -eq 0 ]

  EXPECTED="$(
    cat <<EOC
gfmfmt
Billie Thompson <billie+gfmfmt@billiecodes.com>
Format GitHub flavour markdown

USAGE:
  gfmfmt <markdown-files>...

ARGS:
  <markdown-files>...    Markdown files or folders containing markdown
EOC
  )"
  [ "$output" = "$EXPECTED" ]
}
