//
//  FireWorksView.m
//  CardFit
//
//  Created by Braden Gray on 8/17/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "FireWorksView.h"
#import "QuartzCore/QuartzCore.h"

@interface FireWorksView ()

@property (nonatomic, strong) CAEmitterLayer *particleEmitter;
@property (nonatomic) BOOL emitting;

@end

@implementation FireWorksView

- (void)fireWorks {
    UIImage *image = [UIImage imageNamed:@"tspark.png"];
    
    self.emitting = YES;
    self.particleEmitter = (CAEmitterLayer *)self.layer;
    self.particleEmitter.emitterPosition = CGPointMake((self.frame.size.width - (image.size.width / 2.0)) / 2.0, self.frame.size.height);
    self.particleEmitter.emitterSize = CGSizeMake(10.0, 10.0);
    self.particleEmitter.renderMode = kCAEmitterLayerAdditive;
    
    
    CAEmitterCell *rocket = [CAEmitterCell emitterCell];
    rocket.emissionLongitude = -M_PI_2;
    rocket.emissionLatitude = 0;
    rocket.lifetime = 2.4;
    rocket.birthRate = 0.7;
    rocket.velocity = 100;
    rocket.velocityRange = 40;
    rocket.yAcceleration = -80;
    rocket.emissionRange = -M_PI / 5;
    rocket.color = [[UIColor colorWithRed:0.6 green:0.6 blue:0.9 alpha:1.0] CGColor];
    rocket.redRange = 1.0;
    rocket.greenRange = 1.0;
    rocket.blueRange = 1.0;
    rocket.contents = (id) [image CGImage];
    [rocket setName:@"rocket"];
    
    //Flare particles emitted from the rocket as it flys
    CAEmitterCell *flare = [CAEmitterCell emitterCell];
    flare.contents = (id)[image CGImage];
    flare.emissionLongitude = -(4 * M_PI) / 2;
    flare.scale = 0.4;
    flare.velocity = 200;
    flare.birthRate = 35;
    flare.lifetime = 0.55;
    flare.yAcceleration = 350;
    flare.emissionRange = -M_PI / 12;
    flare.alphaSpeed = -0.7;
    flare.scaleSpeed = -0.1;
    flare.scaleRange = 0.1;
    flare.beginTime = 0.01;
    flare.duration = 1.7;
    
    //The particles that make up the explosion
    CAEmitterCell *firework = [CAEmitterCell emitterCell];
    firework.contents = (id) [image CGImage];
    firework.birthRate = 2500;
    firework.scale = 0.65;
    firework.velocity = 100;
    firework.lifetime = 2;
    firework.alphaSpeed = -0.2;
    firework.yAcceleration = 10;
    firework.beginTime = 2.3;
    firework.duration = 0.1;
    firework.emissionRange = 2 * M_PI;
    firework.scaleSpeed = -0.1;
    firework.spin = 2;
    
    //Name the cell so that it can be animated later using keypath
    firework.name = @"firework";
    
    //preSpark is an invisible particle used to later emit the spark
    CAEmitterCell *preSpark = [CAEmitterCell emitterCell];
    preSpark.birthRate = 80;
    preSpark.velocity = firework.velocity * 0.70;
    preSpark.lifetime = 1.7;
    preSpark.yAcceleration = firework.yAcceleration * 0.85;
    preSpark.beginTime = firework.beginTime - 0.05;
    preSpark.emissionRange = firework.emissionRange;
    preSpark.greenSpeed = 100;
    preSpark.blueSpeed = 100;
    preSpark.redSpeed = 100;
    
    //Name the cell so that it can be animated later using keypath
    preSpark.name = @"preSpark";
    
    //The 'sparkle' at the end of a firework
    CAEmitterCell *spark = [CAEmitterCell emitterCell];
    spark.contents = (id) [image CGImage];
    spark.lifetime = 0.05;
    spark.yAcceleration = 10;
    spark.beginTime = 0.3;
    spark.scale = 0.3;
    spark.birthRate = 8;
    
    preSpark.emitterCells = @[spark];
    rocket.emitterCells = @[firework, preSpark, flare];
    self.particleEmitter.emitterCells = @[rocket];
}

-(void)rain {
    UIImage *image = [UIImage imageNamed:@"Rain.png"];
    
    self.emitting = YES;
    self.particleEmitter = (CAEmitterLayer *)self.layer;
    self.particleEmitter.emitterPosition = CGPointMake((self.frame.size.width - (image.size.width / 2.0)) / 2.0, 0);
    self.particleEmitter.emitterSize = CGSizeMake(self.frame.size.width, 10);
    self.particleEmitter.zPosition = 1;
    self.particleEmitter.emitterDepth = 2;
    
    self.particleEmitter.emitterShape = kCAEmitterLayerLine;
//    self.particleEmitter.emitterSize = CGSizeMake(10.0, 10.0);
    self.particleEmitter.renderMode = kCAEmitterLayerAdditive;
    
    
    CAEmitterCell *drop = [CAEmitterCell emitterCell];
    drop.emissionLongitude = M_PI;
//    drop.emissionLatitude = 0;
    drop.lifetime = 2.4;
    drop.birthRate = 100;
    drop.velocity = 100;
//    drop.velocityRange = 40;
    drop.yAcceleration = 80;
//    drop.emissionRange = -M_PI / 5;
    drop.color = [[UIColor colorWithRed:0.2 green:0.2 blue:0.7 alpha:1.0] CGColor];
//    drop.redRange = 1.0;
//    drop.greenRange = 1.0;
//    drop.blueRange = 1.0;
    drop.contents = (id) [image CGImage];
    [drop setName:@"drop"];
    
    self.particleEmitter.emitterCells = @[drop];
}

+ (Class) layerClass {
    return [CAEmitterLayer class];
}

- (void)startEmittingFireworks:(BOOL)fireworks {
//    [self.fireWorksEmitter setValue:[NSNumber numberWithFloat:.7] forKeyPath:@"emitterCells.rocket.birthRate"];
    if (!self.emitting) {
        if (fireworks) {
            [self fireWorks];
        } else {
            [self rain];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
