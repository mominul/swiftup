build:
	swift build -c release -Xswiftc -static-stdlib
mkdirs: build
	mkdir -p .build/.swiftup/bin
	mkdir -p .build/.swiftup/shims
	mkdir -p .build/.swiftup/versions
package: build mkdirs
	cp .build/release/swiftup .build/.swiftup/bin
	cd .build && tar -czvf swiftup.tar.gz .swiftup/ && cd ..
