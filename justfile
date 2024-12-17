[private]
watch-swift dir cmd ignore1="•" ignore2="•" ignore3="•":
  @watchexec --project-origin . --clear --restart --watch {{dir}} --exts swift \
  --ignore '**/.build/*/**' --ignore '{{ignore1}}' --ignore '{{ignore2}}' --ignore '{{ignore3}}' \
  {{cmd}}

swift-watch-build dir:
  @just watch-swift {{dir}} '"cd {{dir}} && swift build"'

swift-watch-test dir isolate="":
  @just watch-swift {{dir}} '"cd {{dir}} && \
  SWIFT_DETERMINISTIC_HASHING=1 swift test \
  {{ if isolate != "" { "--filter " + isolate } else { "" } }} "'

watch-api:
  @just watch-swift api/Sources 'swift run --package-path api'

migrate:
  psql -d flashcards -f db.sql

tail-db:
  tail -f '/Users/tabitha/Library/Application Support/Postgres/var-17/postgresql.log'