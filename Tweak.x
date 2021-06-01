#import <UIKit/UIKit.h>

static float enlargementFactor = 1.368200836820084;
static BOOL sizeSet = NO;
static float size;
static Class nowPlayingContentViewClass;

%hook ArtworkComponentImageView
- (void)setFrame:(CGRect)arg1 {
	if ([[self superview] isKindOfClass:nowPlayingContentViewClass] && arg1.origin.x != 0) {
		if (!sizeSet) {
			size = arg1.size.width * enlargementFactor;
			sizeSet = YES;
		}
		
		arg1.origin.x = 0;
		arg1.origin.y = 0;
		arg1.size.width = size;
		arg1.size.height = size;
	}

	%orig(arg1);
}
%end

%hook CALayer
- (void)setShadowOpacity:(float)arg1 {
	if ([[self delegate] isKindOfClass:nowPlayingContentViewClass]) {
		%orig(0.45f);
	} else {
		%orig;
	}
}

- (void)setShadowRadius:(double)arg1 {
	if ([[self delegate] isKindOfClass:nowPlayingContentViewClass]) {
		%orig(24);
	} else {
		%orig;
	}
}

- (void)setShadowOffset:(CGSize)arg1 {
	if (![[self delegate] isKindOfClass:nowPlayingContentViewClass]) {
		%orig;
	}
}

- (void)setShadowPath:(CGPathRef)arg1 {
	if (![[self delegate] isKindOfClass:nowPlayingContentViewClass]) {
		%orig;
	}
}
%end

%ctor {
	nowPlayingContentViewClass = NSClassFromString(@"MusicApplication.NowPlayingContentView");
	%init(ArtworkComponentImageView = NSClassFromString(@"MusicApplication.ArtworkComponentImageView"));
}