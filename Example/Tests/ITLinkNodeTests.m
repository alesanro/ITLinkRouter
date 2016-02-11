//
//  ITLinkNodeTests.m
//  ITLinkRouter
//
//  Created by Alex Rudyak on 2/9/16.
//  Copyright © 2016 Alex Rudyak. All rights reserved.
//

SpecBegin(ITLinkNodeTests);

describe(@"instance methods", ^{
         });

describe(@"cluster methods", ^{
    it(@"should create proper instances", ^{
        __block ITLinkNode *node;
        node = [ITLinkNode linkActionWithModuleName:@"Module" link:nil arguments:nil];
        expect(node).to.beMemberOf([ITLinkAction class]);

        node = [ITLinkNode linkActionWithModuleName:@"Module" link:nil arguments:nil router:nil];
        expect(node).to.beMemberOf([ITLinkAction class]);

        node = [ITLinkNode linkValueWithModuleName:@"Module"];
        expect(node).to.beMemberOf([ITLinkValue class]);

        node = [ITLinkNode linkValueWithModuleName:@"Module" router:nil];
        expect(node).to.beMemberOf([ITLinkValue class]);
    });

    it(@"should define proper types", ^{
        ITLinkNode *node;
        node = [ITLinkNode linkValueWithModuleName:@"Module"];
        expect([ITLinkNode isValue:node]).to.beTruthy();
        expect([ITLinkNode isAction:node]).to.beFalsy();

        node = [ITLinkNode linkActionWithNode:node link:nil arguments:nil];
        expect([ITLinkNode isAction:node]).to.beTruthy();
        expect([ITLinkNode isValue:node]).to.beFalsy();
    });

    it(@"should not be similar with other classes except ITLinkNode hierarchy", ^{
        ITLinkNode *const node = [ITLinkNode linkValueWithModuleName:@"Module"];
        expect([node isSimilar:(id)[NSDictionary dictionary]]).to.beFalsy();
    });
});

SpecEnd
