//
//  ITLinkChainTests.m
//  ITLinkRouter
//
//  Created by Alex Rudyak on 2/1/16.
//  Copyright © 2016 Alex Rudyak. All rights reserved.
//
// MARK: Formatter Exempt

@import ITLinkRouter;

SpecBegin(ITLinkEntityTests);

__block ITLinkChain *linkChain;

context(@"Sign in module chain",
        ^{
          beforeEach(^{
            linkChain = [[ITLinkChain alloc] initWithEntities:@[
                [[ITLinkEntity alloc] initWithModule:@"RootModule"
                                                link:@selector(navigateToLogin:)
                                           arguments:@[ @"Password" ]],
                [[ITLinkEntity alloc] initWithModule:@"LoginModule"
                                                link:@selector(navigateSignInWithUser:password:)
                                           arguments:@[ @"Alex", @"123" ]],
                [[ITLinkEntity alloc] initWithModule:@"FeedModule" link:@selector(openProfile) arguments:nil],
                [[ITLinkEntity alloc] initWithModule:@"ProfileModule"
                                                link:@selector(editNumber:)
                                           arguments:@[ @"375293334455" ]]
            ]];
          });

          describe(@"", ^{

                   });

        });

SpecEnd
