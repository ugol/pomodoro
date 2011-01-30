//
//  BGHUDStepperCell.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 4/6/09.
//
//  Copyright 2009 Tyler Bunnell and Steve Audette
//	All rights reserved.
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

#import "BGHUDStepperCell.h"
#import "BGHUDGeometry.h"

@interface BGHUDStepperCell (Private)
-(void)drawRoundRectButtonInFrame:(NSRect)frame;
-(void)drawArrowsInRect:(NSRect)frame;
-(NSRect)adjustFrame:(NSRect)frame;
@end

@implementation BGHUDStepperCell

@synthesize themeKey;

-(void)drawWithFrame:(NSRect) frame inView:(NSView *) controlView {	
	[self drawRoundRectButtonInFrame:frame];
	[self drawArrowsInRect:frame];
}

-(NSRect)adjustFrame:(NSRect)frame
{
	frame.origin.x += 3.5f;
	frame.origin.y += 2.0f;
	frame.size.width -= 7.0f;
	frame.size.height -= 4.0f;
	return frame;
}

-(BOOL)startTrackingAt:(NSPoint)startPoint inView:(NSView *)controlView
{
	NSRect frame = [controlView bounds];
	
	NSRect bottomRect = NSMakeRect(frame.origin.x,frame.origin.y,frame.size.width,frame.size.height/2);
	NSRect topRect = NSMakeRect(frame.origin.x,frame.origin.y+(frame.size.height/2),frame.size.width,frame.size.height/2);
	
	if(NSPointInRect(startPoint,topRect))
	{
		topPressed = isTopDown = YES;    
	}
	if(NSPointInRect(startPoint,bottomRect))
	{
		bottomPressed = isBottomDown = YES;
	}
	[[self controlView] setNeedsDisplay:YES];
	
	return [super startTrackingAt:startPoint inView:controlView];
}
-(BOOL)continueTracking:(NSPoint)lastPoint at:(NSPoint)currentPoint inView:(NSView *)controlView
{
	NSRect frame = [controlView bounds];
	
	NSRect bottomRect = NSMakeRect(frame.origin.x,frame.origin.y,frame.size.width,frame.size.height/2);
	NSRect topRect = NSMakeRect(frame.origin.x,frame.origin.y+(frame.size.height/2),frame.size.width,frame.size.height/2);
	
	if(isTopDown && topPressed && !NSPointInRect(currentPoint,topRect))
	{
		isTopDown = NO;
		[[self controlView] setNeedsDisplay:YES];
	}
	if(!isTopDown && topPressed && NSPointInRect(currentPoint,topRect))
	{
		isTopDown = YES;
		[[self controlView] setNeedsDisplay:YES];
	}
	if(isBottomDown && bottomPressed && !NSPointInRect(currentPoint,bottomRect))
	{
		isBottomDown = NO;
		[[self controlView] setNeedsDisplay:YES];
	}
	if(!isBottomDown && bottomPressed && NSPointInRect(currentPoint,bottomRect))
	{
		isBottomDown = YES;
		[[self controlView] setNeedsDisplay:YES];
	}
	
	return [super continueTracking:lastPoint at:currentPoint inView:controlView];
}
-(void)stopTracking:(NSPoint)lastPoint at:(NSPoint)stopPoint inView:(NSView *)controlView mouseIsUp:(BOOL)flag
{
	isTopDown = isBottomDown = topPressed = bottomPressed = NO;
	[[self controlView] setNeedsDisplay:YES];
	[super stopTracking:lastPoint at:stopPoint inView:controlView mouseIsUp:flag];
}

-(void)drawRoundRectButtonInFrame:(NSRect)frame {
	
	frame = [self adjustFrame:frame];
	
	float cornerRadius = 4.0f;
	
	//Draw the complete button
	
	//Create Path
	NSBezierPath *path = [[NSBezierPath alloc] init];
	
	//Bottom Right Corner
	[path moveToPoint:NSMakePoint(NSMaxX(frame), NSMinY(frame) + cornerRadius)];
	
	//Right Edge
	[path lineToPoint:NSMakePoint(NSMaxX(frame), NSMaxY(frame) - cornerRadius)];
	
	//Top Right Curve
	[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(frame) - cornerRadius, NSMaxY(frame) - cornerRadius)
									 radius: cornerRadius
								 startAngle: 0
								   endAngle: 90];
	
	//Top Edge
	[path lineToPoint:NSMakePoint(NSMinX(frame) + cornerRadius, NSMaxY(frame))];
	
	//Top Left Curve
	[path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(frame) + cornerRadius, NSMaxY(frame) - cornerRadius)
									 radius: cornerRadius
								 startAngle: 90
								   endAngle: 180];
	
	//Left Edge
	[path lineToPoint:NSMakePoint(NSMinX(frame), NSMinY(frame) + cornerRadius)];
	
	//Left Bottom Curve
	[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(frame) + cornerRadius, NSMinY(frame) + cornerRadius)
									 radius: cornerRadius
								 startAngle: 180
								   endAngle: 270];
	
	//Bottom Edge
	[path lineToPoint:NSMakePoint(NSMaxX(frame) - cornerRadius, NSMinY(frame))];
	
	//Right Bottom Curve
	[path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(frame) - cornerRadius, NSMinY(frame) + cornerRadius)
									 radius: cornerRadius
								 startAngle: 270
								   endAngle: 0];
	
 	[path closePath];
	
	
	if([self isEnabled]) {		
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] normalGradient] drawInBezierPath:path
																			   relativeCenterPosition:NSZeroPoint];
		
	} else {
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledNormalComplexGradient] drawInBezierPath:path
																							  relativeCenterPosition:NSZeroPoint];
	}
	
	
	
	//Check for anything being pushed
	if([self isEnabled])
	{
		if(isTopDown)
		{
			NSRect topRect = NSMakeRect(frame.origin.x,frame.origin.y+(frame.size.height/2),frame.size.width,frame.size.height/2);
			NSBezierPath *path = [[NSBezierPath alloc] init];
			[path moveToPoint:NSMakePoint(NSMaxX(topRect), NSMinY(topRect))];
			[path lineToPoint:NSMakePoint(NSMaxX(topRect), NSMaxY(topRect) - cornerRadius)];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(topRect) - cornerRadius, NSMaxY(topRect) - cornerRadius)
											 radius: cornerRadius
										 startAngle: 0
										   endAngle: 90];
			[path lineToPoint:NSMakePoint(NSMinX(topRect) + cornerRadius, NSMaxY(topRect))];
			[path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(topRect) + cornerRadius, NSMaxY(topRect) - cornerRadius)
											 radius: cornerRadius
										 startAngle: 90
										   endAngle: 180];
			[path lineToPoint:NSMakePoint(NSMinX(topRect), NSMinY(topRect))];
			
			[path closePath];
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] pushedSolidFill] set];
			[path fill];
			
			[path release];
		}
		else if(isBottomDown)
		{
			NSRect bottomRect = NSMakeRect(frame.origin.x,frame.origin.y,frame.size.width,frame.size.height/2);
			NSBezierPath* path = [[NSBezierPath alloc] init];      
			
			[path moveToPoint:NSMakePoint(NSMinX(bottomRect), NSMaxY(bottomRect))];
			[path lineToPoint:NSMakePoint(NSMinX(bottomRect), NSMinY(bottomRect) + cornerRadius)];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(bottomRect) + cornerRadius, NSMinY(bottomRect) + cornerRadius)
											 radius: cornerRadius
										 startAngle: 180
										   endAngle: 270];
			[path lineToPoint:NSMakePoint(NSMaxX(bottomRect) - cornerRadius, NSMinY(bottomRect))];
			[path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(bottomRect) - cornerRadius, NSMinY(bottomRect) + cornerRadius)
											 radius: cornerRadius
										 startAngle: 270
										   endAngle: 0];
			[path lineToPoint:NSMakePoint(NSMaxX(bottomRect), NSMaxY(bottomRect))];
			
			[path closePath];
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] pushedSolidFill] set];
			[path fill];
			
			[path release];
		}
	}
	
	[NSGraphicsContext saveGraphicsState];  
	
	//Draw dark border color
	if([self isEnabled]) {
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] dropShadow] set];
	}
	[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] darkStrokeColor] set];
	[path stroke];
	
	[NSGraphicsContext restoreGraphicsState];
	
	if([self isEnabled]) {
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
	} else {
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledStrokeColor] set];
	}
	
	[path setLineWidth: 1.0f];
	[path stroke];
	
	[path release];
	
	
}

-(void)drawArrowsInRect:(NSRect) frame { 
	
	CGFloat arrowWidth = 2.5f;
	CGFloat arrowHeight = 2.0f;
	
	frame = [self adjustFrame:frame];
	
	NSRect bottomRect = NSMakeRect(frame.origin.x,frame.origin.y,frame.size.width,frame.size.height/2);
	NSRect topRect = NSMakeRect(frame.origin.x,frame.origin.y+(frame.size.height/2),frame.size.width,frame.size.height/2);
	
	NSBezierPath *arrow = [[NSBezierPath alloc] init];
	
	NSPoint points[3];
	
	points[0] = NSMakePoint(topRect.origin.x + (topRect.size.width /2), topRect.origin.y + ((topRect.size.height /2) + arrowHeight));
	points[1] = NSMakePoint(topRect.origin.x + ((topRect.size.width /2) - arrowWidth), topRect.origin.y + ((topRect.size.height /2)-arrowHeight));
	points[2] = NSMakePoint(topRect.origin.x + ((topRect.size.width /2) + arrowWidth), topRect.origin.y + ((topRect.size.height /2)-arrowHeight));
	
	
	[arrow appendBezierPathWithPoints: points count: 3];
	
	if([self isEnabled]) {
		if(isTopDown)
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] darkStrokeColor] set];
		else
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
	} else {
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledStrokeColor] set];
	}
	
	
	[arrow fill];
	
	[arrow release];
	
	
	arrow = [[NSBezierPath alloc] init];
	
	points[0] = NSMakePoint(bottomRect.origin.x + ((bottomRect.size.width /2) - arrowWidth), bottomRect.origin.y + ((bottomRect.size.height /2)+arrowHeight));
	points[1] = NSMakePoint(bottomRect.origin.x + ((bottomRect.size.width /2) + arrowWidth), bottomRect.origin.y + ((bottomRect.size.height /2)+arrowHeight));
	points[2] = NSMakePoint(bottomRect.origin.x + (bottomRect.size.width /2), frame.origin.y + ((bottomRect.size.height /2) - arrowHeight));
	
	[arrow appendBezierPathWithPoints: points count: 3];
	
	if([self isEnabled]) {
		if(isBottomDown)
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] darkStrokeColor] set];
		else
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
	} else {
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledStrokeColor] set];
	}
	
	[arrow fill];
	
	[arrow release];
}

@end
