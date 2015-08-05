//
//  WC2VoiceEventSnapshot.h
//  wc2-sdk
//
//  Created by Morgan Davis on 4/3/15.
//  Copyright (c) 2015 Plantronics. All rights reserved.
//

#import "WC2ServiceSnapshot.h"


typedef NS_ENUM(NSUInteger, WC2Phrase) {
	WC2PhraseDistance =         1,
	WC2PhraseWhatTimeIsIt =     2,
	WC2PhrasePairMode =         3,
	WC2PhraseTalkToCortana =    4,
	WC2PhraseLaunchIt =         5,
	WC2PhraseRedial =           6,
	WC2PhraseVoiceMemo =        7,
	WC2PhraseSecure =           8,
	WC2PhraseTalkToSiri =       9,
	WC2PhraseStepCount =        10,
	WC2PhraseUnlock =           11,
	WC2PhraseTalkToGoogle =     12,
	WC2PhraseHelpMe =           13,
	WC2PhraseCall =             14,
	WC2PhraseReturnCall =       15
};


NSString *NSStringFromWC2Phrase(WC2Phrase phrase);


@interface WC2VoiceEventSnapshot : WC2ServiceSnapshot

@property(nonatomic,readonly)	WC2Phrase	phrase;

@end
