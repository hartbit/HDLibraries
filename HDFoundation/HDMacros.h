//
//  HDMacros.h
//  HDLibraries
//
//  Created by David Hart on 6/9/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//


#define __NSStringFromMacro(f) @#f
#define NSStringFromMacro(f) __NSStringFromMacro(f)