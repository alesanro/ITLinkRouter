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
    });

    it(@"flatten should return an equal instance", ^{
        ITLinkNode *node = [ITLinkNode linkValueWithModuleName:@"Module"];
        ITLinkNode *flattenNode = [node flatten];
        expect([flattenNode class]).to.equal([node class]);
        expect(node).to.equal(flattenNode);
    });
});

describe(@"function ITModuleNameFromClass", ^{
    it(@"should return module name from class", ^{
        expect(ITModuleNameFromClass([_ITRootModuleRouter class])).to.equal(@"_ITRootModule");
        expect(ITModuleNameFromClass([_ITBasicRouter class])).to.equal(NSStringFromClass([_ITBasicRouter class]));
    });
});

SpecEnd
