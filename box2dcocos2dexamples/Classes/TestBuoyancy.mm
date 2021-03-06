//
//  TestBuoyancy.m
//  Box2DCocos2DExamples
//
//  Created by Yannick LORIOT on 29/06/11.
//  Copyright 2011 Yannick Loriot. All rights reserved.
//  http://yannickloriot.com
//

#import "TestBuoyancy.h"

#import "Box2DExamples.h"

#define BUOYANCYOFFSET 140.0f
#define BOXNUMBERS 2

@interface TestBuoyancy ()
/** Box2d buoyancy controller. */
@property (assign) b2BuoyancyController *bc;

@end

@implementation TestBuoyancy
@synthesize bc;

- (void)dealloc
{
	[super dealloc];
}

- (id)init
{
	if ((self = [super init]))
    {
        // Get the screen size
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        // Define the buoyancy controller
        b2BuoyancyControllerDef bcd;
        
        bcd.normal.Set(0.0f, 1.0f);
        bcd.offset = ptm(BUOYANCYOFFSET);
        bcd.density = 2.0f;
        bcd.linearDrag = 7.0f;
        bcd.angularDrag = 10.0f;
        bcd.useWorldGravity = true;
    
        bc = (b2BuoyancyController *)world->CreateController(&bcd);

        // Add boxes
        for (int i = 0; i < BOXNUMBERS; i++)
        {
            b2BodyDef bd;
            bd.type = b2_dynamicBody;
            bd.position.Set(ptm(screenSize.width / 4 + random() % (int)(screenSize.width / 2)), ptm(screenSize.height / 2));
            
            b2PolygonShape boxDef;
            boxDef.SetAsBox(ptm(20), ptm(20));
            
            b2FixtureDef fd;
            fd.shape = &boxDef;
            fd.density = 1.0f;
            fd.friction = 0.3f;
            fd.restitution = 0.1f;
            
            b2Body *body = world->CreateBody(&bd);
            body->CreateFixture(&fd);
            
            bc->AddBody(body);
        }
    }
    return self;
}

- (void)accelerometer:(UIAccelerometer *)_accelerometer didAccelerate:(UIAcceleration *)_acceleration
{	
    [super accelerometer:_accelerometer didAccelerate:_acceleration];
	
    // To improve
    float accelerationX = [[NSString stringWithFormat:@"%.1f",(_acceleration.x * 1.0f)] floatValue];
    float accelerationY = [[NSString stringWithFormat:@"%.1f",(_acceleration.y * 1.0f)] floatValue];
    
    // Change the buoyancy normal
    bc->normal.Set(accelerationY, -accelerationX);
    bc->offset = ptm(BUOYANCYOFFSET * (accelerationY - accelerationX)); // TOFIX when accelerationX = -accelerationY
}

#pragma mark -
#pragma mark TestBuoyancy Public Methods

#pragma mark TestBuoyancy Private Methods

@end
