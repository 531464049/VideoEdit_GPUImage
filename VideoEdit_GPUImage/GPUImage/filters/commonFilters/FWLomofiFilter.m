//
//  FWLomofiFilter.m
//  FWMeituApp
//
//  Created by hzkmn on 16/1/11.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
//

#import "FWLomofiFilter.h"

NSString *const kFWLomofiShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3;
 
 void main()
 {
     
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     vec2 red = vec2(texel.r, 0.16666);
     vec2 green = vec2(texel.g, 0.5);
     vec2 blue = vec2(texel.b, 0.83333);
     
     texel.rgb = vec3(
                      texture2D(inputImageTexture2, red).r,
                      texture2D(inputImageTexture2, green).g,
                      texture2D(inputImageTexture2, blue).b);
     
     vec2 tc = (2.0 * textureCoordinate) - 1.0;
     float d = dot(tc, tc);
     vec2 lookup = vec2(d, texel.r);
     texel.r = texture2D(inputImageTexture3, lookup).r;
     lookup.y = texel.g;
     texel.g = texture2D(inputImageTexture3, lookup).g;
     lookup.y = texel.b;
     texel.b	= texture2D(inputImageTexture3, lookup).b;
     
     gl_FragColor = vec4(texel,1.0);
 }
 );

@implementation FWFilter6

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kFWLomofiShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end

@implementation FWLomofiFilter

- (id)init
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    FWFilter6 *filter = [[FWFilter6 alloc] init];
    [self addFilter:filter];
    
    UIImage *image = [UIImage imageNamed:@"lomoMap"];
    imageSource1 = [[GPUImagePicture alloc] initWithImage:image];
    [imageSource1 addTarget:filter atTextureLocation:1];
    [imageSource1 processImage];
    
    UIImage *image1 = [UIImage imageNamed:@"vignetteMap"];
    imageSource2 = [[GPUImagePicture alloc] initWithImage:image1];
    [imageSource2 addTarget:filter atTextureLocation:2];
    [imageSource2 processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:filter, nil];
    self.terminalFilter = filter;
    
    return self;
}

@end
