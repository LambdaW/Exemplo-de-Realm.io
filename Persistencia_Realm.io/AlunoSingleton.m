//
//  AlunoSingleton.m
//  Persistencia_Realm.io
//
//  Created by joaquim on 16/03/15.
//  Copyright (c) 2015 joaquim. All rights reserved.
//

#import "AlunoSingleton.h"
#import <Realm/Realm.h>
#import "Aluno.h"

@implementation AlunoSingleton

static AlunoSingleton *SINGLETON = nil;

static bool isFirstAccess = YES;

#pragma mark - Public Method

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];    
    });
    
    return SINGLETON;
}


- (void)salvar:(Aluno *)aluno {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:aluno];
    [realm commitWriteTransaction];
}



- (NSMutableArray *)todosAlunos {
    RLMResults *resultados = [Aluno allObjects];
    NSMutableArray *alunos = [[NSMutableArray alloc] initWithCapacity:[resultados count]];
    
    for (Aluno *a in resultados) {
        [alunos addObject:a];
    }
    
    return alunos;
}

-(void)deletarAluno:(Aluno *)Aluno{
    RLMRealm *realm = [Aluno realm];
    [realm beginWriteTransaction];
    [realm deleteObject:Aluno];
    [realm commitWriteTransaction];
}

- (Aluno *)alunoComTIA:(NSString *)tia {
#warning Implementar - (Aluno *)alunoComTIA:(NSString *)tia
    return nil;
}

- (NSArray *)alunoComNome:(NSString *)nome {
#warning Implementar - (NSArray *)alunoComNome:(NSString *)nome
    return  nil;
}



#pragma mark - Life Cycle

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return [[AlunoSingleton alloc] init];
}

- (id)mutableCopy
{
    return [[AlunoSingleton alloc] init];
}

- (id) init
{
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    return self;
}


@end
