PROJECT = benchmark
INSTANCE = my-instance
DB = benchdb
HOST = localhost:9010

export SPANNER_PROJECT_ID=$(PROJECT)
export SPANNER_INSTANCE_ID=$(INSTANCE)
export SPANNER_DATABASE_ID=$(DB)
export SPANNER_EMULATOR_HOST=$(HOST)

spanner:
	docker run -p 9010:9010 -p 9020:9020 \
	--env SPANNER_PROJECT_ID=$(PROJECT) \
	--env SPANNER_INSTANCE_ID=$(INSTANCE) \
	--env SPANNER_DATABASE_ID=$(DB) \
	--rm roryq/spanner-emulator:latest

schema:
	wrench apply --ddl ./database/baseline_schema.sql

dataload:
	spanner-cli -p $(PROJECT) \
	-i $(INSTANCE) \
	-d $(DB) \
	-f ./seed/data01.sql

.PHONY: run
run:
	go run ./main.go

connect:
	spanner-cli