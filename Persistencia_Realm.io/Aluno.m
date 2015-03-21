//
//  Aluno.m
//  Persistencia_Realm.io
//
//  Created by joaquim on 16/03/15.
//  Copyright (c) 2015 joaquim. All rights reserved.
//

#import "Aluno.h"

@implementation Aluno

//Sera necessario se precisar dar valores default para nao ter erro com campos vazio no Realm.io
-(instancetype)init{
    self = [super init];
    
    [self setNome:@""];
    [self setTia:@""];
    
   return self;
}

@end
