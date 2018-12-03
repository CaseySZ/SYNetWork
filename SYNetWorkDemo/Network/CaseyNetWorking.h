//
//  CaseyNetWorking.h
//  OpenPlatformGame
//
//  Created by Casey on 29/11/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

#ifndef CaseyNetWorking_h
#define CaseyNetWorking_h


#import "NetRequestInfo.h"
#import "NetMananger+MultipleTask.h"
#import "NetMananger.h"
#import "NSDictionary+ConvertObject.h"
#import "NetMananger+DownFile.h"


typedef void (^NetFinishBlock)(NSError* _Nullable errror, NSDictionary* result);



#endif /* CaseyNetWorking_h */
