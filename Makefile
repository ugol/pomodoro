all: compile

compile:
	#xcodebuild -project externalFw/BGHUDAppKit/BGHUDAppKit.xcodeproj -target BGHUDAppKit -configuration Release build
	#xcodebuild -project externalFw/BGHUDAppKit/BGHUDAppKit.xcodeproj -target BGHUDAppKitPlugin -configuration Release build
	#xcodebuild -project externalFw/OAuthConsumer/OAuthConsumer.xcodeproj -target OAuthConsumer -configuration Release build
	#xcodebuild -project externalFw/shortcutrecorder/ShortcutRecorder.xcodeproj -target "ShortcutRecorder.framework - with embedded ibplugin" -configuration Release build
	xcodebuild -project Pomodoro.xcodeproj -target Pomodoro -configuration Debug build

install: compile
	rm -fr /Applications/Pomodoro.app; mv build/Debug/Pomodoro.app /Applications/
