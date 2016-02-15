//
//  ITLinkActionTests.m
//  ITLinkRouter
//
//  Created by Alex Rudyak on 2/1/16.
//  Copyright © 2016 Alex Rudyak. All rights reserved.
//

#import "ITSupportClassStructure.h"

@interface _ITRootModuleRouter : NSObject
@end

@implementation _ITRootModuleRouter
@end

@interface _ITBasicRouter : NSObject
@end

@implementation _ITBasicRouter
@end

SpecBegin(ITLinkValueTests);

describe(@"instantiation ", ^{
    it(@"should be proper with valid parameters", ^{
        ITLinkNode *const node = [ITLinkNode linkValueWithModuleName:@"Module"];
        expect(node.moduleName).toNot.beEmpty();
        expect(node.moduleName).to.equal(@"Module");
        expect(node.router).to.beNil();
        expect([node debugDescription]).notTo.beEmpty();
    });

    it(@"flatten should return an equal instance", ^{
        ITLinkNode *const node = [ITLinkNode linkValueWithModuleName:@"Module"];
        ITLinkNode *const flattenNode = [node flatten];
        expect([flattenNode class]).to.equal([node class]);
        expect(node).to.equal(flattenNode);
    });

    it(@"should return nil for module invocation objects without router", ^{
        ITLinkNode *const node = [ITLinkNode linkValueWithModuleName:@"Module"];
        expect([node forwardModuleInvocation]).to.beNil();
        expect([node backwardModuleInvocation]).to.beNil();
    });

    it(@"should return non-nil module invocation object with router", ^{
        _TestArrayModuleNameBuilder *const builder = [_TestArrayModuleNameBuilder builderWithNames:@[@"RootModule"]];
        _TestModuleRouter *const router = [[_TestModuleRouter alloc] initWithBuildable:builder completion:nil];
        ITLinkNode *const node = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass(router.class) router:router];

        NSInvocation *const forwardInvocation = [node forwardModuleInvocation];
        expect(forwardInvocation).to.beNil();

        NSInvocation *const backInvocation = [node backwardModuleInvocation];
        expect(backInvocation).notTo.beNil();
        expect(backInvocation.target).to.equal(router);
        expect(backInvocation.selector).toNot.beNil();
        [backInvocation invoke];
        OCMVerify([router unwind]);
    });
});

describe(@"equality and hash", ^{
    it(@"should be valid for equal objects", ^{
        ITLinkNode *const node = [ITLinkNode linkValueWithModuleName:@"Module"];
        ITLinkNode *const otherNode = [ITLinkNode linkValueWithModuleName:@"OtherModule"];
        expect([node hash]).toNot.equal([otherNode hash]);
        expect(node).toNot.equal(otherNode);
        expect(otherNode).toNot.equal(node);

        ITLinkNode *const copiedNode = [node copy];
        expect([node hash]).to.equal([copiedNode hash]);
        expect(node).to.equal(copiedNode);
        expect(copiedNode).to.equal(node);
    });
});

describe(@"function ITModuleNameFromClass", ^{
    it(@"should return module name from class", ^{
        expect(ITModuleNameFromClass([_ITRootModuleRouter class])).to.equal(@"_ITRootModule");
        expect(ITModuleNameFromClass([_ITBasicRouter class])).to.equal(NSStringFromClass([_ITBasicRouter class]));
    });
});

SpecEnd
