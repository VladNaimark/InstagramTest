//
//  Macro.h
//  MediaData
//
//  Created by Vlad Naimark on 9/5/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#ifdef DEBUG
#define LOCALIZE(STRING, TABLE) [[NSBundle mainBundle] localizedStringForKey:STRING value:@"UNLOCALIZED STRING" table:TABLE]
#else
#define LOCALIZE(STRING, TABLE) [[NSBundle mainBundle] localizedStringForKey:STRING value:STRING table:TABLE]
#endif

#endif /* Macro_h */
