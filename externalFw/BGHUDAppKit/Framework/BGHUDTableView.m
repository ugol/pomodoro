//
//  BGHUDTableView.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/17/08.
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

#import "BGHUDTableView.h"

@interface NSTableView (private)
- (void)_sendDelegateWillDisplayCell:(id)cell forColumn:(id)column row:(NSInteger)row;
@end

@implementation BGHUDTableView

#pragma mark Drawing Functions

@synthesize themeKey;

-(id)init {
	NSLog(@"Init");
	self = [super init];
	
	if(self) {
		
		self.themeKey = @"gradientTheme";
		
		[self setBackgroundColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] tableBackgroundColor]];
		[self setFocusRingType: NSFocusRingTypeNone];
		
		//Setup Header Cells		
		for (NSTableColumn* aColumn in [self tableColumns]) {
			
			if([[aColumn headerCell] class] == [NSTableHeaderCell class]) {
				
				BGHUDTableViewHeaderCell *newHeader = [[BGHUDTableViewHeaderCell alloc] initTextCell: @""];
				[newHeader setThemeKey: [self themeKey]];
				[newHeader setFont: [[aColumn headerCell] font]];
				[aColumn setHeaderCell: newHeader];
				[newHeader release];
			} else {
				
				[[aColumn headerCell] setThemeKey: [self themeKey]];
			}
		}
	}
	
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
		
	self = [super initWithCoder: aDecoder]; 
	
	if(self) {
		
		if([aDecoder containsValueForKey: @"themeKey"]) {
			
			self.themeKey = [aDecoder decodeObjectForKey: @"themeKey"];
		} else {
			self.themeKey = @"gradientTheme";
		}
		
		[self setBackgroundColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] tableBackgroundColor]];
		[self setFocusRingType: NSFocusRingTypeNone];
		
		//Setup Header Cells
		for (NSTableColumn* aColumn in [self tableColumns]) {
			
			if([[aColumn headerCell] class] == [NSTableHeaderCell class]) {
				
				BGHUDTableViewHeaderCell *newHeader = [[BGHUDTableViewHeaderCell alloc] initTextCell: @""];
				[newHeader setThemeKey: [self themeKey]];
				[newHeader setFont: [[aColumn headerCell] font]];
				[aColumn setHeaderCell: newHeader];
				[newHeader release];
			} else {
				
				[[aColumn headerCell] setThemeKey: [self themeKey]];
			}
		}
	}
	
	return self;
}

-(void)encodeWithCoder: (NSCoder *)coder {
	
	[super encodeWithCoder: coder];
	
	[coder encodeObject: self.themeKey forKey: @"themeKey"];
}

- (id)_alternatingRowBackgroundColors {
	
	return [[[BGThemeManager keyedManager] themeForKey: self.themeKey] cellAlternatingRowColors];
}

- (id)_highlightColorForCell:(id)cell {

	if([self selectionHighlightStyle] == 1) {
		
		return nil;
	} else {
		
		return [[[BGThemeManager keyedManager] themeForKey: self.themeKey] cellHighlightColor];
	}
}

- (void)_sendDelegateWillDisplayCell:(id)cell forColumn:(id)column row:(NSInteger)row {
	
    [super _sendDelegateWillDisplayCell: cell forColumn: column row: row];
	
	[[self currentEditor] setBackgroundColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] cellEditingFillColor]];
	[[self currentEditor] setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor]];
	
	if([[self selectedRowIndexes] containsIndex: row]) {
		
		if([cell respondsToSelector: @selector(setTextColor:)]) {
			[cell setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] cellSelectedTextColor]];
		}
	} else {
		
		if ([cell respondsToSelector:@selector(setTextColor:)]) {
			[cell setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor]];
		}
	}
}

- (void)_manuallyDrawSourceListHighlightInRect:(NSRect)rect isButtedUpRow:(BOOL)flag {

	if ([NSApp isActive]) {

		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] highlightGradient] drawInRect: rect angle: 90];
    } else {

		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] normalGradient] drawInRect: rect angle: 90];
    }
	
	[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
	
	rect = NSInsetRect(rect, 0.5f, 0.5f);
	[NSBezierPath strokeLineFromPoint: NSMakePoint(NSMinX(rect), NSMaxY(rect)) toPoint: NSMakePoint(NSMaxX(rect), NSMaxY(rect))];
}

- (BOOL)_manuallyDrawSourceListHighlight {
	
	return YES;
}

-(void)awakeFromNib {
	
	[self setCornerView: [[BGHUDTableCornerView alloc] initWithThemeKey: self.themeKey]];
}

#pragma mark -
#pragma mark Helper Methods

-(void)dealloc {
	
	[themeKey release];
	[super dealloc];
}

#pragma mark -

@end
