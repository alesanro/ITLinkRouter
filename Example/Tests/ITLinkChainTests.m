//
//  ITLinkChainTests.m
//  ITLinkRouter
//
//  Created by Alex Rudyak on 2/1/16.
//  Copyright © 2016 Alex Rudyak. All rights reserved.
//

#import "ITSupportClassStructure.h"

SpecBegin(ITLinkChainTests);

__block ITLinkChain *linkChain;

describe(@"action-typed link chain", ^{
    __block ITLinkNode *entity1, *entity2, *entity3, *entity4, *testEntity1, *testEntity2;

    beforeAll(^{
        entity1 = [[ITLinkAction alloc] initWithModuleName:ITModuleNameFromClass([_ITRootModuleRouter class]) link:@selector(navigateToLogin:) arguments:@[ @"Password" ]];
        entity2 = [[ITLinkAction alloc] initWithModuleName:ITModuleNameFromClass([_ITLoginModuleRouter class]) link:@selector(navigateToSignInWithUser:password:) arguments:@[ @"Alex", @"123" ]];
        entity3 = [[ITLinkAction alloc] initWithModuleName:ITModuleNameFromClass([_ITFeedModuleRouter class]) link:@selector(openProfile) arguments:nil];
        entity4 = [[ITLinkAction alloc] initWithModuleName:ITModuleNameFromClass([_ITProfileModuleRouter class]) link:@selector(editNumber:) arguments:@[ @"375293334455" ]];
        testEntity1 = [[ITLinkAction alloc] initWithModuleName:@"TestModule1" link:@selector(testLinkToModule2) arguments:nil];
        testEntity2 = [[ITLinkAction alloc] initWithModuleName:@"TestModule2" link:@selector(testLinkToModule3) arguments:nil];
    });

    beforeEach(^{
        linkChain = [[ITLinkChain alloc] initWithEntities:@[entity1, entity2, entity3, entity4]];
    });

    it(@"properties will be in valid state", ^{
        expect(linkChain.length).equal(linkChain.entities.count);
        expect(linkChain.rootEntity.moduleName).equal(entity1.moduleName);
    });

    it(@"can append new entities", ^{
        ITLinkNode *entity = testEntity1;
        const NSInteger prevCount = linkChain.length;
        [linkChain appendEntity:entity];
        expect(linkChain.length).equal(prevCount + 1);
        expect(linkChain.lastEntity).equal(entity);

        entity = testEntity2;
        const NSInteger prevPrevCount = linkChain.length;
        [linkChain appendEntity:entity];
        expect(linkChain.length).equal(prevPrevCount + 1);
        expect(linkChain.lastEntity).equal(entity);
    });

    it(@"can pop entities", ^{
        const NSInteger initialMeasurementCount = linkChain.length;
        expect([[linkChain appendEntity:testEntity1] popEntity]).equal(testEntity1);
        expect([linkChain popEntity]).equal(entity4);
        expect(linkChain.entities).haveCount(initialMeasurementCount - 1);
    });

    it(@"can shift entities", ^{
        const NSInteger initialLength = linkChain.length;
        expect(linkChain.rootEntity).equal(entity1);
        expect([linkChain shiftEntity]).equal(entity1);
        expect(linkChain.rootEntity).toNot.equal(entity1);
        expect(linkChain.length).equal(initialLength - 1);
    });

    context(@"can find intersection", ^{
        it(@"with having actual intersection", ^{
            ITLinkChain *otherChain = [[ITLinkChain alloc] initWithEntities:@[entity4, entity1, entity2]];
            const NSRange intersenctionRange = [linkChain intersectionRangeWithChain:otherChain];
            expect([NSValue valueWithRange:intersenctionRange]).equal([NSValue valueWithRange:NSMakeRange(0, 2)]);
            const NSRange reverseIntersectionRange = [otherChain intersectionRangeWithChain:linkChain];
            expect([NSValue valueWithRange:reverseIntersectionRange]).equal([NSValue valueWithRange:NSMakeRange(0, 1)]);
        });

        it(@"with having no intersection", ^{
            ITLinkChain *firstChain = [[ITLinkChain alloc] initWithEntities:@[entity2, entity3]];
            ITLinkChain *secondChain = [[ITLinkChain alloc] initWithEntities:@[entity4, entity1, testEntity1]];
            const NSRange intersectionRange = [firstChain intersectionRangeWithChain:secondChain];
            expect(intersectionRange.location).equal(NSNotFound);
            const NSRange reverseIntersectionRange = [secondChain intersectionRangeWithChain:firstChain];
            expect(reverseIntersectionRange.location).equal(NSNotFound);
        });

        it(@"with having intersection started from the beginning", ^{
            ITLinkChain *otherChain = [[ITLinkChain alloc] initWithEntities:@[entity1, entity2, entity3]];
            const NSRange intersectionRange = [linkChain intersectionRangeWithChain:otherChain];
            const NSRange reverseInteractionRange = [otherChain intersectionRangeWithChain:linkChain];
            expect([NSValue valueWithRange:intersectionRange]).equal([NSValue valueWithRange:reverseInteractionRange]);
            expect(intersectionRange.location).equal(0);
        });
    });

    context(@"while extracting subchain", ^{
        context(@"can extract non-empty subchain", ^{
            it(@"when range is inside the chain", ^{
                const NSRange rightRange = NSMakeRange(0, 2);
                ITLinkChain *const rightChain = [linkChain subchainWithRange:rightRange];
                expect(rightChain).notTo.equal(linkChain);
                expect(rightChain.length).equal(rightRange.length);
                expect(rightChain.rootEntity).equal(linkChain.rootEntity);

                const NSRange leftRange = NSMakeRange(linkChain.length - 1, 1);
                ITLinkChain *const leftChain = [linkChain subchainWithRange:leftRange];
                expect(leftChain.length).equal(leftRange.length);
                expect(leftChain.lastEntity).equal(linkChain.lastEntity);
            });

            it(@"when range exceeds chain borders", ^{
                const NSInteger locationOffset = linkChain.length - 2;
                const NSRange range = NSMakeRange(locationOffset, linkChain.length);
                ITLinkChain *const updatedChain = [linkChain subchainWithRange:range];
                expect(updatedChain).toNot.equal(linkChain);
                expect(updatedChain.length).toNot.equal(range.length);
                expect(updatedChain.lastEntity).equal(linkChain.lastEntity);
            });
        });

        context(@"can extract empty subchain", ^{
            it(@"when range is out of borders of chain", ^{
                const NSRange range = NSMakeRange(15, 4);
                ITLinkChain *const emptyChain = [linkChain subchainWithRange:range];
                expect(emptyChain.length).equal(0);
            });

            it(@"when range is not defined", ^{
                const NSRange range = NSMakeRange(NSNotFound, 2);
                ITLinkChain *const emptyChain = [linkChain subchainWithRange:range];
                expect(emptyChain.length).equal(0);
            });
        });
    });

    context(@"can define intersection starting from the root entity", ^{
        it(@"when no intersection just return empty chain", ^{
            ITLinkChain *const otherChain = [[ITLinkChain alloc] initWithEntities:@[entity2, entity3, entity4, entity1]];
            ITLinkChain *const resultChain = [linkChain intersectionAtStartWithChain:otherChain];
            expect(resultChain.length).equal(0);
        });

        it(@"when there is intersection with non-empty result", ^{
            ITLinkChain *const otherChain = [[ITLinkChain alloc] initWithEntities:@[entity1, entity2]];
            ITLinkChain *const resultChain = [linkChain intersectionAtStartWithChain:otherChain];
            expect(resultChain.length).equal(otherChain.length);
            expect(resultChain.rootEntity).equal(linkChain.rootEntity);
        });
    });

    it(@"should have proper copied instance", ^{
        ITLinkChain *copiedChain = [linkChain copy];
        expect(copiedChain).equal(linkChain);
        expect(linkChain).equal(copiedChain);
    });

});

describe(@"value-typed link chain", ^{
    __block ITLinkNode *entity1, *entity2, *entity3, *entity4, *testEntity1, *testEntity2;

    beforeAll(^{
        entity1 = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass([_ITRootModuleRouter class])];
        entity2 = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass([_ITLoginModuleRouter class])];
        entity3 = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass([_ITFeedModuleRouter class])];
        entity4 = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass([_ITProfileModuleRouter class])];
        testEntity1 = [ITLinkNode linkValueWithModuleName:@"TestModule1"];
        testEntity2 = [ITLinkNode linkValueWithModuleName:@"TestModule2"];
    });

    beforeEach(^{
        linkChain = [[ITLinkChain alloc] initWithEntities:@[entity1, entity2, entity3, entity4]];
    });

    it(@"properties will be in valid state", ^{
        expect(linkChain.length).equal(linkChain.entities.count);
        expect(linkChain.rootEntity.moduleName).equal(entity1.moduleName);
    });

    it(@"can append new entities", ^{
        ITLinkNode *entity = testEntity1;
        const NSInteger prevCount = linkChain.length;
        [linkChain appendEntity:entity];
        expect(linkChain.length).equal(prevCount + 1);
        expect(linkChain.lastEntity).equal(entity);

        entity = testEntity2;
        const NSInteger prevPrevCount = linkChain.length;
        [linkChain appendEntity:entity];
        expect(linkChain.length).equal(prevPrevCount + 1);
        expect(linkChain.lastEntity).equal(entity);
    });

    it(@"can pop entities", ^{
        const NSInteger initialMeasurementCount = linkChain.length;
        expect([[linkChain appendEntity:testEntity1] popEntity]).equal(testEntity1);
        expect([linkChain popEntity]).equal(entity4);
        expect(linkChain.entities).haveCount(initialMeasurementCount - 1);
    });

    it(@"can shift entities", ^{
        const NSInteger initialLength = linkChain.length;
        expect(linkChain.rootEntity).equal(entity1);
        expect([linkChain shiftEntity]).equal(entity1);
        expect(linkChain.rootEntity).toNot.equal(entity1);
        expect(linkChain.length).equal(initialLength - 1);
    });

    context(@"can find intersection", ^{
        it(@"with having actual intersection", ^{
            ITLinkChain *otherChain = [[ITLinkChain alloc] initWithEntities:@[entity4, entity1, entity2]];
            const NSRange intersenctionRange = [linkChain intersectionRangeWithChain:otherChain];
            expect([NSValue valueWithRange:intersenctionRange]).equal([NSValue valueWithRange:NSMakeRange(0, 2)]);
            const NSRange reverseIntersectionRange = [otherChain intersectionRangeWithChain:linkChain];
            expect([NSValue valueWithRange:reverseIntersectionRange]).equal([NSValue valueWithRange:NSMakeRange(0, 1)]);
        });

        it(@"with having no intersection", ^{
            ITLinkChain *firstChain = [[ITLinkChain alloc] initWithEntities:@[entity2, entity3]];
            ITLinkChain *secondChain = [[ITLinkChain alloc] initWithEntities:@[entity4, entity1, testEntity1]];
            const NSRange intersectionRange = [firstChain intersectionRangeWithChain:secondChain];
            expect(intersectionRange.location).equal(NSNotFound);
            const NSRange reverseIntersectionRange = [secondChain intersectionRangeWithChain:firstChain];
            expect(reverseIntersectionRange.location).equal(NSNotFound);
        });

        it(@"with having intersection started from the beginning", ^{
            ITLinkChain *otherChain = [[ITLinkChain alloc] initWithEntities:@[entity1, entity2, entity3]];
            const NSRange intersectionRange = [linkChain intersectionRangeWithChain:otherChain];
            const NSRange reverseInteractionRange = [otherChain intersectionRangeWithChain:linkChain];
            expect([NSValue valueWithRange:intersectionRange]).equal([NSValue valueWithRange:reverseInteractionRange]);
            expect(intersectionRange.location).equal(0);
        });
    });

    context(@"while extracting subchain", ^{
        context(@"can extract non-empty subchain", ^{
            it(@"when range is inside the chain", ^{
                const NSRange rightRange = NSMakeRange(0, 2);
                ITLinkChain *const rightChain = [linkChain subchainWithRange:rightRange];
                expect(rightChain).notTo.equal(linkChain);
                expect(rightChain.length).equal(rightRange.length);
                expect(rightChain.rootEntity).equal(linkChain.rootEntity);

                const NSRange leftRange = NSMakeRange(linkChain.length - 1, 1);
                ITLinkChain *const leftChain = [linkChain subchainWithRange:leftRange];
                expect(leftChain.length).equal(leftRange.length);
                expect(leftChain.lastEntity).equal(linkChain.lastEntity);
            });

            it(@"when range exceeds chain borders", ^{
                const NSInteger locationOffset = linkChain.length - 2;
                const NSRange range = NSMakeRange(locationOffset, linkChain.length);
                ITLinkChain *const updatedChain = [linkChain subchainWithRange:range];
                expect(updatedChain).toNot.equal(linkChain);
                expect(updatedChain.length).toNot.equal(range.length);
                expect(updatedChain.lastEntity).equal(linkChain.lastEntity);
            });
        });

        context(@"can extract empty subchain", ^{
            it(@"when range is out of borders of chain", ^{
                const NSRange range = NSMakeRange(15, 4);
                ITLinkChain *const emptyChain = [linkChain subchainWithRange:range];
                expect(emptyChain.length).equal(0);
            });

            it(@"when range is not defined", ^{
                const NSRange range = NSMakeRange(NSNotFound, 2);
                ITLinkChain *const emptyChain = [linkChain subchainWithRange:range];
                expect(emptyChain.length).equal(0);
            });
        });
    });

    context(@"can define intersection starting from the root entity", ^{
        it(@"when no intersection just return empty chain", ^{
            ITLinkChain *const otherChain = [[ITLinkChain alloc] initWithEntities:@[entity2, entity3, entity4, entity1]];
            ITLinkChain *const resultChain = [linkChain intersectionAtStartWithChain:otherChain];
            expect(resultChain.length).equal(0);
        });

        it(@"when there is intersection with non-empty result", ^{
            ITLinkChain *const otherChain = [[ITLinkChain alloc] initWithEntities:@[entity1, entity2]];
            ITLinkChain *const resultChain = [linkChain intersectionAtStartWithChain:otherChain];
            expect(resultChain.length).equal(otherChain.length);
            expect(resultChain.rootEntity).equal(linkChain.rootEntity);
        });
    });

    it(@"should have proper copied instance", ^{
        ITLinkChain *copiedChain = [linkChain copy];
        expect(copiedChain).equal(linkChain);
        expect(linkChain).equal(copiedChain);
    });

});

describe(@"mixed-typed link chain", ^{
    __block ITLinkNode *entity1, *entity2, *entity3, *entity4, *testEntity1, *testEntity2;
    __block ITLinkNode *valueEntity1, *valueEntity2;

    beforeAll(^{
        entity1 = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_ITRootModuleRouter class]) link:@selector(navigateToLogin:) arguments:@[ @"Password" ]];
        entity2 = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_ITLoginModuleRouter class]) link:@selector(navigateToSignInWithUser:password:) arguments:@[ @"Alex", @"123" ]];
        entity3 = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_ITFeedModuleRouter class]) link:@selector(openProfile) arguments:nil];
        entity4 = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_ITProfileModuleRouter class]) link:@selector(editNumber:) arguments:@[ @"375293334455" ]];
        testEntity1 = [ITLinkNode linkValueWithModuleName:@"TestModule1"];
        testEntity2 = [ITLinkNode linkValueWithModuleName:@"TestModule2"];
        valueEntity1 = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass([_ITFeedModuleRouter class])];
        valueEntity2 = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass([_ITProfileModuleRouter class])];
    });

    beforeEach(^{
        linkChain = [[ITLinkChain alloc] initWithEntities:@[valueEntity1, entity1, entity2]];
    });

    context(@"can find intersection", ^{
        it(@"with having actual intersection", ^{
            ITLinkChain *otherChain = [[ITLinkChain alloc] initWithEntities:@[valueEntity2, valueEntity1, entity1]];
            const NSRange intersenctionRange = [linkChain intersectionRangeWithChain:otherChain];
            expect([NSValue valueWithRange:intersenctionRange]).equal([NSValue valueWithRange:NSMakeRange(0, 2)]);
            const NSRange reverseIntersectionRange = [otherChain intersectionRangeWithChain:linkChain];
            expect([NSValue valueWithRange:reverseIntersectionRange]).equal([NSValue valueWithRange:NSMakeRange(1, 2)]);
        });

        it(@"with having no intersection", ^{
            ITLinkChain *firstChain = [[ITLinkChain alloc] initWithEntities:@[entity2, entity3]];
            ITLinkChain *secondChain = [[ITLinkChain alloc] initWithEntities:@[entity4, valueEntity1, valueEntity2]];
            const NSRange intersectionRange = [firstChain intersectionRangeWithChain:secondChain];
            expect(intersectionRange.location).equal(NSNotFound);
            const NSRange reverseIntersectionRange = [secondChain intersectionRangeWithChain:firstChain];
            expect(reverseIntersectionRange.location).equal(NSNotFound);
        });

        it(@"with having intersection started from the beginning", ^{
            ITLinkChain *otherChain = [[ITLinkChain alloc] initWithEntities:@[valueEntity1, entity1, entity3]];
            const NSRange intersectionRange = [linkChain intersectionRangeWithChain:otherChain];
            const NSRange reverseInteractionRange = [otherChain intersectionRangeWithChain:linkChain];
            expect([NSValue valueWithRange:intersectionRange]).equal([NSValue valueWithRange:reverseInteractionRange]);
            expect(intersectionRange.location).equal(0);
        });
    });

    context(@"can define intersection starting from the root entity", ^{
        it(@"when no intersection just return empty chain", ^{
            ITLinkChain *const otherChain = [[ITLinkChain alloc] initWithEntities:@[valueEntity2, valueEntity1, entity1]];
            ITLinkChain *const resultChain = [linkChain intersectionAtStartWithChain:otherChain];
            expect(resultChain.length).equal(0);
        });

        it(@"when there is intersection with non-empty result", ^{
            ITLinkChain *const otherChain = [[ITLinkChain alloc] initWithEntities:@[valueEntity1, entity1]];
            ITLinkChain *const resultChain = [linkChain intersectionAtStartWithChain:otherChain];
            expect(resultChain.length).equal(otherChain.length);
            expect(resultChain.rootEntity).equal(linkChain.rootEntity);
        });
    });
});

SpecEnd
