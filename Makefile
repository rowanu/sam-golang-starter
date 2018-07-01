OUTPUT = main
ZIPFILE = lambda.zip

.PHONY: test
test:
	go test ./...

.PHONY: clean
clean:
	rm -f $(OUTPUT) $(ZIPFILE)

.PHONY: install
install:
	go get -t ./...

main: ./function/main.go
	go build -o $(OUTPUT) ./function/main.go

# compile the code to run in Lambda (local or real)
.PHONY: lambda
lambda:
	GOOS=linux GOARCH=amd64 $(MAKE) main

# create a lambda deployment package
zip: clean lambda
	zip -9 -r $(ZIPFILE) $(OUTPUT)

.PHONY: run-local
local: zip
	sam local start-api &

.PHONY: build
build: clean lambda
