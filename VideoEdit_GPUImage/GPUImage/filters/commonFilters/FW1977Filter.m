//
//  FW1977Filter.m
//  FWMeituApp
//
//  Created by hzkmn on 16/1/11.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
//

#import "FW1977Filter.h"

NSString *const kFW1977ShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     texel = vec3(
                  texture2D(inputImageTexture2, vec2(texel.r, .16666)).r,
                  texture2D(inputImageTexture2, vec2(texel.g, .5)).g,
                  texture2D(inputImageTexture2, vec2(texel.b, .83333)).b);
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation FWFilter9

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kFW1977ShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end

@implementation FW1977Filter

- (id)init
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    FWFilter9 *filter = [[FWFilter9 alloc] init];
    [self addFilter:filter];
    
    UIImage *image = [UIImage imageNamed:@"1977map"];
    imageSource1 = [[GPUImagePicture alloc] initWithImage:image];
    [imageSource1 addTarget:filter atTextureLocation:1];
    [imageSource1 processImage];
    
    UIImage *image1 = [UIImage imageNamed:@"1977blowout"];
    imageSource2 = [[GPUImagePicture alloc] initWithImage:image1];
    [imageSource2 addTarget:filter atTextureLocation:2];
    [imageSource2 processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:filter, nil];
    self.terminalFilter = filter;
    
    return self;
}

@end
