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
        _TestArrayModuleNameBuilder *const namesBuilder = [_TestArrayModuleNameBuilder builderWithNames:@[@"RootModule", @"LoginModule", @"FeedModule", @"ProfileModule", @"Test1Module", @"Test2Module"]];
        entity1 = [[ITLinkAction alloc] initWithModuleName:[namesBuilder getNextName] link:@selector(navigateToA:) arguments:@[ @"Password" ]];
        entity2 = [[ITLinkAction alloc] initWithModuleName:[namesBuilder getNextName] link:@selector(navigateToB:) arguments:@[ @"Bob" ]];
        entity3 = [[ITLinkAction alloc] initWithModuleName:[namesBuilder getNextName] link:@selector(navigateToC) arguments:nil];
        entity4 = [[ITLinkAction alloc] initWithModuleName:[namesBuilder getNextName] link:@selector(navigateToB:) arguments:@[ @"375293334455" ]];
        testEntity1 = [[ITLinkAction alloc] initWithModuleName:[namesBuilder getNextName] link:@selector(navigateToB) arguments:nil];
        testEntity2 = [[ITLinkAction alloc] initWithModuleName:[namesBuilder getNextName] link:@selector(navigateToC) arguments:nil];
    });

    beforeEach(^{
        linkChain = [[ITLinkChain alloc] initWithEntities:@[entity1, entity2, entity3, entity4]];
    });

    it(@"properties will be in valid state", ^{
        expect(linkChain.length).equal(linkChain.entities.count);
        expect(linkChain.rootEntity.moduleName).equal(entity1.moduleName);
        expect([linkChain debugDescription]).notTo.beEmpty();
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
            ITLinkChain *const otherChain = [[ITLinkChain alloc] initWithEntities:@[entity4, entity1, entity2]];
            const NSRange intersenctionRange = [linkChain intersectionRangeWithChain:otherChain];
            expect([NSValue valueWithRange:intersenctionRange]).equal([NSValue valueWithRange:NSMakeRange(0, 2)]);
            const NSRange reverseIntersectionRange = [otherChain intersectionRangeWithChain:linkChain];
            expect([NSValue valueWithRange:reverseIntersectionRange]).equal([NSValue valueWithRange:NSMakeRange(0, 1)]);
        });

        it(@"with having no intersection", ^{
            ITLinkChain *const firstChain = [[ITLinkChain alloc] initWithEntities:@[entity2, entity3]];
            ITLinkChain *const secondChain = [[ITLinkChain alloc] initWithEntities:@[entity4, entity1, testEntity1]];
            const NSRange intersectionRange = [firstChain intersectionRangeWithChain:secondChain];
            expect(intersectionRange.location).equal(NSNotFound);
            const NSRange reverseIntersectionRange = [secondChain intersectionRangeWithChain:firstChain];
            expect(reverseIntersectionRange.location).equal(NSNotFound);

            ITLinkChain *const emptyChain = [[ITLinkChain alloc] initWithEntities:nil];
            NSRange emptyIntersection = [firstChain intersectionRangeWithChain:emptyChain];
            expect(emptyIntersection.location).equal(NSNotFound);
            emptyIntersection = [emptyChain intersectionRangeWithChain:firstChain];
            expect(emptyIntersection.location).equal(NSNotFound);
        });

        it(@"with having intersection started from the beginning", ^{
            ITLinkChain *const otherChain = [[ITLinkChain alloc] initWithEntities:@[entity1, entity2, entity3]];
            const NSRange intersectionRange = [linkChain intersectionRangeWithChain:otherChain];
            const NSRange reverseInteractionRange = [otherChain intersectionRangeWithChain:linkChain];
            expect([NSValue valueWithRange:intersectionRange]).equal([NSValue valueWithRange:reverseInteractionRange]);
            expect(intersectionRange.location).equal(0);
        });

        it(@"and return chain object", ^{
            ITLinkChain *const otherChain = [[ITLinkChain alloc] initWithEntities:@[entity2, entity4]];
            ITLinkChain *const foundIntersectedChain = [otherChain intersectionWithChain:linkChain];
            const NSRange foundIntersectionRange = [otherChain intersectionRangeWithChain:linkChain];
            expect(foundIntersectedChain.length).to.equal(foundIntersectionRange.length);

            ITLinkChain *const revertIntersectedChain = [linkChain intersectionWithChain:otherChain];
            const NSRange revertIntersectedRange = [linkChain intersectionRangeWithChain:otherChain];
            expect(revertIntersectedChain.length).to.equal(revertIntersectedRange.length);
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

    context(@"can subtract chain from each other", ^{
        it(@"with non-emtpy resulted chain for found intersection at the beginning", ^{
            ITLinkChain *const otherChain = [[ITLinkChain alloc] initWithEntities:@[entity1, entity2, entity4, entity3]];
            ITLinkChain *const subtractedChain = [linkChain subtractIntersectedChain:otherChain];
            expect(subtractedChain).notTo.beNil();
            expect(subtractedChain).toNot.equal(linkChain);
            expect(subtractedChain.length).equal(linkChain.length - 2);
            expect(linkChain.rootEntity).notTo.equal(subtractedChain.rootEntity);
            expect(linkChain.lastEntity).to.equal(subtractedChain.lastEntity);
        });

        it(@"with non-emtpy resulted chain for found intersection in the middle", ^{
            ITLinkChain *const otherChain = [[ITLinkChain alloc] initWithEntities:@[entity2, entity3]];
            ITLinkChain *const subtractedChain = [linkChain subtractIntersectedChain:otherChain];
            expect(subtractedChain).notTo.beNil();
            expect(subtractedChain).toNot.equal(linkChain);
            expect(subtractedChain.length).equal(linkChain.length - 2);
            expect(linkChain.rootEntity).to.equal(subtractedChain.rootEntity);
            expect(linkChain.lastEntity).to.equal(subtractedChain.lastEntity);
        });

        it(@"with non-emtpy resulted chain for found intersection at the end", ^{
            ITLinkChain *const otherChain = [[ITLinkChain alloc] initWithEntities:@[entity4, testEntity1]];
            ITLinkChain *const subtractedChain = [linkChain subtractIntersectedChain:otherChain];
            expect(subtractedChain).notTo.beNil();
            expect(subtractedChain).toNot.equal(linkChain);
            expect(subtractedChain.length).equal(linkChain.length - 1);
            expect(linkChain.rootEntity).to.equal(subtractedChain.rootEntity);
            expect(linkChain.lastEntity).notTo.equal(subtractedChain.lastEntity);
        });

        it(@"with the equal chain for not found intersection", ^{
            ITLinkChain *const otherChain = [[ITLinkChain alloc] initWithEntities:@[testEntity1, testEntity2]];
            ITLinkChain *const subtractedChain = [linkChain subtractIntersectedChain:otherChain];
            expect(subtractedChain).notTo.beNil();
            expect(subtractedChain).to.equal(linkChain);
        });

        it(@"with the empty chain when itself copy was passed", ^{
            ITLinkChain *const otherChain = [linkChain copy];
            ITLinkChain *const subtractedChain = [linkChain subtractIntersectedChain:otherChain];
            expect(subtractedChain).notTo.beNil();
            expect(subtractedChain).notTo.equal(linkChain);
            expect(subtractedChain.length).to.equal(0);
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
        _TestArrayModuleNameBuilder *const builder = [_TestArrayModuleNameBuilder builderWithNames:@[@"RootModule", @"LoginModule", @"Feed1Module", @"Feed2Module", @"ProfileModule", @"Test1Module", @"Test2Module"]];
        entity1 = [ITLinkNode linkValueWithModuleName:[builder getNextName]];
        entity2 = [ITLinkNode linkValueWithModuleName:[builder getNextName]];
        entity3 = [ITLinkNode linkValueWithModuleName:[builder getNextName]];
        entity4 = [ITLinkNode linkValueWithModuleName:[builder getNextName]];
        testEntity1 = [ITLinkNode linkValueWithModuleName:[builder getNextName]];
        testEntity2 = [ITLinkNode linkValueWithModuleName:[builder getNextName]];
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

            ITLinkChain *emptyChain = [[ITLinkChain alloc] initWithEntities:nil];
            NSRange emptyIntersection = [firstChain intersectionRangeWithChain:emptyChain];
            expect(emptyIntersection.location).equal(NSNotFound);
            emptyIntersection = [emptyChain intersectionRangeWithChain:firstChain];
            expect(emptyIntersection.location).equal(NSNotFound);
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

    context(@"can subtract chain from each other", ^{
        it(@"with non-emtpy resulted chain for found intersection at the beginning", ^{
            ITLinkChain *const otherChain = [[ITLinkChain alloc] initWithEntities:@[entity1, entity2, entity4, entity3]];
            ITLinkChain *const subtractedChain = [linkChain subtractIntersectedChain:otherChain];
            expect(subtractedChain).notTo.beNil();
            expect(subtractedChain).toNot.equal(linkChain);
            expect(subtractedChain.length).equal(linkChain.length - 2);
            expect(linkChain.rootEntity).notTo.equal(subtractedChain.rootEntity);
            expect(linkChain.lastEntity).to.equal(subtractedChain.lastEntity);
        });

        it(@"with non-emtpy resulted chain for found intersection in the middle", ^{
            ITLinkChain *const otherChain = [[ITLinkChain alloc] initWithEntities:@[entity2, entity3]];
            ITLinkChain *const subtractedChain = [linkChain subtractIntersectedChain:otherChain];
            expect(subtractedChain).notTo.beNil();
            expect(subtractedChain).toNot.equal(linkChain);
            expect(subtractedChain.length).equal(linkChain.length - 2);
            expect(linkChain.rootEntity).to.equal(subtractedChain.rootEntity);
            expect(linkChain.lastEntity).to.equal(subtractedChain.lastEntity);
        });

        it(@"with non-emtpy resulted chain for found intersection at the end", ^{
            ITLinkChain *const otherChain = [[ITLinkChain alloc] initWithEntities:@[entity4, testEntity1]];
            ITLinkChain *const subtractedChain = [linkChain subtractIntersectedChain:otherChain];
            expect(subtractedChain).notTo.beNil();
            expect(subtractedChain).toNot.equal(linkChain);
            expect(subtractedChain.length).equal(linkChain.length - 1);
            expect(linkChain.rootEntity).to.equal(subtractedChain.rootEntity);
            expect(linkChain.lastEntity).notTo.equal(subtractedChain.lastEntity);
        });

        it(@"with the equal chain for not found intersection", ^{
            ITLinkChain *const otherChain = [[ITLinkChain alloc] initWithEntities:@[testEntity1, testEntity2]];
            ITLinkChain *const subtractedChain = [linkChain subtractIntersectedChain:otherChain];
            expect(subtractedChain).notTo.beNil();
            expect(subtractedChain).to.equal(linkChain);
        });

        it(@"with the empty chain when itself copy was passed", ^{
            ITLinkChain *const otherChain = [linkChain copy];
            ITLinkChain *const subtractedChain = [linkChain subtractIntersectedChain:otherChain];
            expect(subtractedChain).notTo.beNil();
            expect(subtractedChain).notTo.equal(linkChain);
            expect(subtractedChain.length).to.equal(0);
        });
    });

    it(@"should have proper copied instance", ^{
        ITLinkChain *copiedChain = [linkChain copy];
        expect(copiedChain).equal(linkChain);
        expect(linkChain).equal(copiedChain);
    });

    it(@"should not be comparable with any other classes except itself", ^{
        NSDictionary *otherObject = [NSDictionary dictionary];
        expect(otherObject).toNot.equal(linkChain);
        expect(linkChain).toNot.equal(otherObject);
    });

    it(@"should be equal to itself", ^{
        expect([linkChain isEqual:linkChain]).to.beTruthy();
    });

});

describe(@"mixed-typed link chain", ^{
    __block ITLinkNode *entity1, *entity2, *entity3, *entity4, *testEntity1, *testEntity2;
    __block ITLinkNode *valueEntity1, *valueEntity2;

    beforeAll(^{
        _TestArrayModuleNameBuilder *const builder = [_TestArrayModuleNameBuilder builderWithNames:@[@"RootModule", @"LoginModule", @"FeedModule", @"FeedModule", @"ProfileModule", @"Test1Module", @"Test2Module", @"FeedModule", @"ProfileModule"]];
        entity1 = [ITLinkNode linkActionWithModuleName:[builder getNextName] link:@selector(navigateToA:) arguments:@[ @"Password" ]];
        entity2 = [ITLinkNode linkActionWithModuleName:[builder getNextName] link:@selector(navigateToB:) arguments:@[ @"Bob" ]];
        entity3 = [ITLinkNode linkActionWithModuleName:[builder getNextName] link:@selector(navigateToC) arguments:nil];
        entity4 = [ITLinkNode linkActionWithModuleName:[builder getNextName] link:@selector(navigateToA:) arguments:@[ @"375293334455" ]];
        testEntity1 = [ITLinkNode linkValueWithModuleName:[builder getNextName]];
        testEntity2 = [ITLinkNode linkValueWithModuleName:[builder getNextName]];
        valueEntity1 = [ITLinkNode linkValueWithModuleName:[builder getNextName]];
        valueEntity2 = [ITLinkNode linkValueWithModuleName:[builder getNextName]];
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
            ITLinkChain *secondChain = [[ITLinkChain alloc] initWithEntities:@[entity4, entity1, testEntity1]];
            const NSRange intersectionRange = [firstChain intersectionRangeWithChain:secondChain];
            expect(intersectionRange.location).equal(NSNotFound);
            const NSRange reverseIntersectionRange = [secondChain intersectionRangeWithChain:firstChain];
            expect(reverseIntersectionRange.location).equal(NSNotFound);

            ITLinkChain *emptyChain = [[ITLinkChain alloc] initWithEntities:nil];
            NSRange emptyIntersection = [firstChain intersectionRangeWithChain:emptyChain];
            expect(emptyIntersection.location).equal(NSNotFound);
            emptyIntersection = [emptyChain intersectionRangeWithChain:firstChain];
            expect(emptyIntersection.location).equal(NSNotFound);
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

    context(@"can subtract chain from each other", ^{
        it(@"with non-emtpy resulted chain for found intersection at the beginning", ^{
            ITLinkChain *const otherChain = [[ITLinkChain alloc] initWithEntities:@[valueEntity1, entity1, entity4, entity3]];
            ITLinkChain *const subtractedChain = [linkChain subtractIntersectedChain:otherChain];
            expect(subtractedChain).notTo.beNil();
            expect(subtractedChain).toNot.equal(linkChain);
            expect(subtractedChain.length).equal(linkChain.length - 2);
            expect(linkChain.rootEntity).notTo.equal(subtractedChain.rootEntity);
            expect(linkChain.lastEntity).to.equal(subtractedChain.lastEntity);
        });

        it(@"with non-emtpy resulted chain for found intersection in the middle", ^{
            ITLinkChain *const otherChain = [[ITLinkChain alloc] initWithEntities:@[entity1]];
            ITLinkChain *const subtractedChain = [linkChain subtractIntersectedChain:otherChain];
            expect(subtractedChain).notTo.beNil();
            expect(subtractedChain).toNot.equal(linkChain);
            expect(subtractedChain.length).equal(linkChain.length - 1);
            expect(linkChain.rootEntity).to.equal(subtractedChain.rootEntity);
            expect(linkChain.lastEntity).to.equal(subtractedChain.lastEntity);
        });

        it(@"with non-emtpy resulted chain for found intersection at the end", ^{
            ITLinkChain *const otherChain = [[ITLinkChain alloc] initWithEntities:@[entity2, testEntity1]];
            ITLinkChain *const subtractedChain = [linkChain subtractIntersectedChain:otherChain];
            expect(subtractedChain).notTo.beNil();
            expect(subtractedChain).toNot.equal(linkChain);
            expect(subtractedChain.length).equal(linkChain.length - 1);
            expect(linkChain.rootEntity).to.equal(subtractedChain.rootEntity);
            expect(linkChain.lastEntity).notTo.equal(subtractedChain.lastEntity);
        });

        it(@"with the equal chain for not found intersection", ^{
            ITLinkChain *const otherChain = [[ITLinkChain alloc] initWithEntities:@[testEntity1, testEntity2]];
            ITLinkChain *const subtractedChain = [linkChain subtractIntersectedChain:otherChain];
            expect(subtractedChain).notTo.beNil();
            expect(subtractedChain).to.equal(linkChain);
        });

        it(@"with the empty chain when itself copy was passed", ^{
            ITLinkChain *const otherChain = [linkChain copy];
            ITLinkChain *const subtractedChain = [linkChain subtractIntersectedChain:otherChain];
            expect(subtractedChain).notTo.beNil();
            expect(subtractedChain).notTo.equal(linkChain);
            expect(subtractedChain.length).to.equal(0);
        });
    });
});

SpecEnd
