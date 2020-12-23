.NOTPARALLEL: build build-windows build-macos
all: build build-windows build-macos

vendors:
	go mod vendor

.PHONY: clean
go-bindata-download:
	@go get -u github.com/go-bindata/go-bindata/...

bind-html: go-bindata-download
	@echo "bindata html"
	@go-bindata -o pkg/core/assets.go data/html/
	@sed -i "" "s/package\ main/package\ core/" pkg/core/assets.go

bind-rclone: go-bindata-download
	@echo "download rclone linux"
	@mkdir -p data/linux
	@wget -q -L --show-progress -O data/linux/rclone https://github.com/dciangot/rclone/releases/download/v1.51.1-patch-s3/rclone
	@echo "bindata rclone linux"
	@go-bindata -o pkg/rclone/rclone_linux.go -prefix data/linux/ data/linux/
	@sed -i "" "s/package\ main/package\ rclone/" pkg/rclone/rclone_linux.go

bind-rclone-windows: go-bindata-download
	@echo "download rclone windows"
	@mkdir -p data/windows
	@wget -q -L --show-progress -O data/windows/rclone https://github.com/dciangot/rclone/releases/download/v1.51.1-patch-s3/rclone.exe
	@echo "bindata rclone windows"
	@go-bindata -o pkg/rclone/rclone_windows.go -prefix data/windows/ data/windows/
	@sed -i "" "s/package\ main/package\ rclone/" pkg/rclone/rclone_windows.go

bind-rclone-macos: go-bindata-download
	@echo "download rclone macos"
	@mkdir -p data/darwin
	@wget -q -L --show-progress -O data/darwin/rclone https://github.com/dciangot/rclone/releases/download/v1.51.1-patch-s3/rclone_osx
	@echo "bindata rclone macos"
	@go-bindata -o pkg/rclone/rclone_darwin.go -prefix "data/darwin/" data/darwin/
	@sed -i "" "s/package\ main/package\ rclone/" pkg/rclone/rclone_darwin.go

build: bind-html bind-rclone vendors
	@echo "build sts-wire linux"
	@go build -ldflags "-s -w" -mod vendor -v -o sts-wire_linux

build-windows: bind-html bind-rclone-windows vendors
	@echo "build sts-wire windows"
	@env GOOS=windows CGO_ENABLED=0 go build -ldflags "-s -w" -mod vendor -v -o sts-wire_windows.exe

build-macos: bind-html bind-rclone-macos vendors
	@echo "build sts-wire macOs"
	@env GOOS=darwin CGO_ENABLED=0 go build -ldflags "-s -w" -mod vendor -v -o sts-wire_osx
	ls -l .