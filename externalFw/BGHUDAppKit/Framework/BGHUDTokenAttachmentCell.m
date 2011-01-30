//
//  BGHUDTokenAttachmentCell.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/11/08.
//
//  Copyright (c) 2008, Tim Davis (BinaryMethod.com, binary.god@gmail.com)
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification,
//  are permitted provided that the following conditions are met:
//
//		Redistributions of source code must retain the above copyright notice, this
//	list of conditions and the following disclaimer.
//
//		Redistributions in binary form must reproduce the above copyright notice,
//	this list of conditions and the following disclaimer in the documentation and/or
//	other materials provided with the distribution.
//
//		Neither the name of the BinaryMethod.com nor the names of its contributors
//	may be used to endorse or promote products derived from this software without
//	specific prior written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS AS IS AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//	IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//	INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
//	BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
//	OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
//	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
//	POSSIBILITY OF SUCH DAMAGE.

#import "BGHUDTokenAttachmentCell.h"


@implementation BGHUDTokenAttachmentCell

@synthesize tokenFillNormal;
@synthesize tokenFillHighlight;
@synthesize tokenBorder;

- (id)tokenForegroundColor {

	if(![self isHighlighted]) {
		
		return [self tokenFillHighlight];
	} else {
		
		return [self tokenFillNormal];
	}
}

- (id)tokenBackgroundColor {
	
	return [self tokenBorder];
}

- (void)drawWithFrame:(NSRect)fp8 inView:(id)fp24 {
	
	NSMutableAttributedString *newTitle = [[NSMutableAttributedString alloc] initWithAttributedString: [self attributedStringValue]];
	NSRect textRect = fp8;
	
	if(![self isHighlighted]) {
		
		[newTitle beginEditing];
		[newTitle addAttribute: NSForegroundColorAttributeName
						 value: [self textColor]
						 range: NSMakeRange(0, [newTitle length])];
		[newTitle endEditing];
		
		[self setAttributedStringValue: newTitle];
	}
	
	switch ([self controlSize]) {
		
		case NSSmallControlSize:
			
			fp8.size.height = 14;
			
			[newTitle beginEditing];
			[newTitle addAttribute: NSFontAttributeName
							 value: [NSFont controlContentFontOfSize: 10.0f]
							 range: NSMakeRange(0, [newTitle length])];
			[newTitle endEditing];
			
			textRect.origin.y -= 2;
			
			break;
			
		case NSMiniControlSize:

			fp8.size.height = 12;
			
			[newTitle beginEditing];
			[newTitle addAttribute: NSFontAttributeName
							 value: [NSFont controlContentFontOfSize: 8.0f]
							 range: NSMakeRange(0, [newTitle length])];
			[newTitle endEditing];
			
			textRect.origin.y -= 3;
			
			break;
	}
	
	[super drawTokenWithFrame: fp8 inView: fp24];
	
	if([self controlSize] == NSRegularControlSize) {
		
		[super drawInteriorWithFrame: fp8 inView: fp24];
	} else {
		
		[newTitle drawInRect: textRect];
	}
	
	[newTitle release];
}

@end
