all: compile

compile:
	xcodebuild -project externalFw/BGHUDAppKit/BGHUDAppKit.xcodeproj -target BGHUDAppKit -configuration Release build
	xcodebuild -project externalFw/BGHUDAppKit/BGHUDAppKit.xcodeproj -target BGHUDAppKitPlugin -configuration Release build
	xcodebuild -project externalFw/OAuthConsumer/OAuthConsumer.xcodeproj -target OAuthConsumer -configuration Release build
	open externalFw/shortcutrecorder/ShortcutRecorder.ibplugin
	open externalFw/BGHUDAppKit//build/Release/BGHUDAppKit.framework/Versions/A/Resources/BGHUDAppKitPlugin.ibplugin
	xcodebuild -project Pomodoro.xcodeproj -target Pomodoro -configuration Debug build

install: compile
	rm -fr /Applications/Pomodoro.app; mv build/Debug/Pomodoro.app /Applications/
