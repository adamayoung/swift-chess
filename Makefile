TARGET = SwiftChess
TEST_TARGET = SwiftChessTests

IOS_DESTINATION = 'platform=iOS Simulator,name=iPhone 15,OS=18.0'
WATCHOS_DESINTATION = 'platform=watchOS Simulator,name=Apple Watch Series 9 (45mm),OS=11.0'
TVOS_DESTINATION = 'platform=tvOS Simulator,name=Apple TV 4K (3rd generation),OS=18.0'
VISIONOS_DESTINATION = 'platform=visionOS Simulator,name=Apple Vision Pro,OS=2.0'

.PHONY: clean
clean:
	swift package clean
	rm -rf docs

.PHONY: format
format:
	swiftlint --fix
	swiftformat .

.PHONY: lint
lint:
	swiftlint --strict
	swiftformat --lint .

.PHONY: lint-markdown
lint-markdown:
	markdownlint "README.md"

.PHONY: build
build:
	swift build -Xswiftc -warnings-as-errors

.PHONY: build-tests
build-tests:
	swift build --build-tests -Xswiftc -warnings-as-errors

.PHONY: build-release
build-release:
	swift build -c release -Xswiftc -warnings-as-errors

.PHONY: test
test:
	swift build --build-tests -Xswiftc -warnings-as-errors
	swift test --skip-build --filter $(TEST_TARGET)

.PHONY: test-ios
test-ios:
	set -o pipefail && NSUnbufferedIO=YES xcodebuild clean build-for-testing -scheme $(TARGET) -only-testing $(TEST_TARGET) -destination $(IOS_DESTINATION)
	set -o pipefail && NSUnbufferedIO=YES xcodebuild test-without-building -scheme $(TARGET) -only-testing $(TEST_TARGET) -destination $(IOS_DESTINATION)

.PHONY: test-watchos
test-watchos:
	set -o pipefail && NSUnbufferedIO=YES xcodebuild build-for-testing -scheme $(TARGET) -only-testing $(TEST_TARGET) -destination $(WATCHOS_DESINTATION)
	set -o pipefail && NSUnbufferedIO=YES xcodebuild test-without-building -scheme $(TARGET) -only-testing $(TEST_TARGET) -destination $(WATCHOS_DESINTATION)

.PHONY: test-tvos
test-tvos:
	set -o pipefail && NSUnbufferedIO=YES xcodebuild build-for-testing -scheme $(TARGET) -only-testing $(TEST_TARGET) -destination $(TVOS_DESTINATION)
	set -o pipefail && NSUnbufferedIO=YES xcodebuild test-without-building -scheme $(TARGET) -only-testing $(TEST_TARGET) -destination $(TVOS_DESTINATION)

.PHONY: test-visionos
test-visionos:
	set -o pipefail && NSUnbufferedIO=YES xcodebuild build-for-testing -scheme $(TARGET) -only-testing $(TEST_TARGET) -destination $(VISIONOS_DESTINATION)
	set -o pipefail && NSUnbufferedIO=YES xcodebuild test-without-building -scheme $(TARGET) -only-testing $(TEST_TARGET) -destination $(VISIONOS_DESTINATION)

.PHONY: ci
ci: lint lint-markdown test test-ios test-watchos test-tvos test-visionos build-release
