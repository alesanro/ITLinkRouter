//
//  ITLinkNodeTests.m
//  ITLinkRouter
//
//  Created by Alex Rudyak on 2/9/16.
//  Copyright © 2016 Alex Rudyak. All rights reserved.
//

@interface ITLinkNodeChild : ITLinkNode
@end

@implementation ITLinkNodeChild
@end

SpecBegin(ITLinkNodeTests);

describe(@"instance methods", ^{
    context(@"which haven't provide its implementation should raise exception", ^{
        __block ITLinkNodeChild *childNode;

        beforeEach(^{
            childNode = [[ITLinkNodeChild alloc] initWithModuleName:@"ChildModule" router:nil];
        });

        it(@"for flatten method", ^{
            expect(^{
                __unused id<ITLinkNode> flatteNode = [childNode flatten];
            }).to.raise(ITUnimplementedMethod);
        });

        it(@"for forward module invocation method", ^{
            expect(^{
                __unused NSInvocation *invocation = [childNode forwardModuleInvocation];
            }).to.raise(ITUnimplementedMethod);
        });

        it(@"for backward module invocation method", ^{
            expect(^{
                __unused NSInvocation *invocation = [childNode backwardModuleInvocation];
            }).to.raise(ITUnimplementedMethod);
        });

        it(@"for copy method", ^{
            expect(^{
                __unused id<ITLinkNode> copiedNode = [childNode copy];
            }).to.raise(ITUnimplementedMethod);
        });
    });
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

    it(@"should not be similar with other classes except ITLinkNode hierarchy", ^{
        ITLinkNode *const node = [ITLinkNode linkValueWithModuleName:@"Module"];
        expect([node isSimilar:(id)[NSDictionary dictionary]]).to.beFalsy();
    });
});

SpecEnd
