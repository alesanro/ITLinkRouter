//
//  ITLinkActionTests.m
//  ITLinkRouter
//
//  Created by Alex Rudyak on 2/1/16.
//  Copyright © 2016 Alex Rudyak. All rights reserved.
//

#import "ITSupportClassStructure.h"

SpecBegin(ITLinkValueTests);

describe(@"instantiation ", ^{
    it(@"should be proper with valid parameters", ^{
        ITLinkNode *node = [ITLinkNode linkValueWithModuleName:@"Module"];
        expect(node.moduleName).toNot.beEmpty();
        expect(node.moduleName).to.equal(@"Module");
        expect(node.router).to.beNil();
        expect([node debugDescription]).notTo.beEmpty();
    });

    it(@"flatten should return an equal instance", ^{
        ITLinkNode *node = [ITLinkNode linkValueWithModuleName:@"Module"];
        ITLinkNode *flattenNode = [node flatten];
        expect([flattenNode class]).to.equal([node class]);
        expect(node).to.equal(flattenNode);
    });

    it(@"should return nil for module invocation objects without router", ^{
        ITLinkNode *const node = [ITLinkNode linkValueWithModuleName:@"Module"];
        expect([node forwardModuleInvocation]).to.beNil();
        expect([node backwardModuleInvocation]).to.beNil();
    });

    it(@"should return non-nil module invocation object with router", ^{
        _ITRootModuleRouter *const router = [_ITRootModuleRouter new];
        ITLinkNode *node = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass(router.class) router:router];

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

describe(@"function ITModuleNameFromClass", ^{
    it(@"should return module name from class", ^{
        expect(ITModuleNameFromClass([_ITRootModuleRouter class])).to.equal(@"_ITRootModule");
        expect(ITModuleNameFromClass([_ITBasicRouter class])).to.equal(NSStringFromClass([_ITBasicRouter class]));
    });
});

SpecEnd
