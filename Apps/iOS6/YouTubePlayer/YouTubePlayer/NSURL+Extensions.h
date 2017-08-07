//
//  NSURL+Extensions.h
//  YouTubePlayer
//
//  Created by Clemens Wagner on 08.06.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL(Extensions)

- (NSDictionary *)queryParametersWithEncoding:(NSStringEncoding)inEncoding;

@end
