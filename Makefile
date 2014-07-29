LOGFILE=make.log

all: timer
    
timer: info
	@echo "Building Timer.app..."
	@xcodebuild -configuration Release -scheme Timer -project Timer.xcodeproj >> $(LOGFILE)
	@echo "Find the binary at: "
	@egrep "^Touch.*app$$" $(LOGFILE)

no-sig: info
	@echo "Removing signature information..."
	@find . -name "project.pbxproj" -exec sed -i '' "s/.*CODE_SIGN_IDENTITY.*//g" {} \; 

info:
	@echo "Logging output to file '$(LOGFILE)'"
	@echo "" > $(LOGFILE)

clean: info
	@echo "Cleaning up..."
	@xcodebuild -configuration Release -scheme Timer -project Timer.xcodeproj clean >> $(LOGFILE)

