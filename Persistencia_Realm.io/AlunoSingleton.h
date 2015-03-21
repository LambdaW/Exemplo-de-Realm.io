//
//  AlunoSingleton.h
//  Persistencia_Realm.io
//
//  Created by joaquim on 16/03/15.
//  Copyright (c) 2015 joaquim. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Aluno;

@interface AlunoSingleton : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (AlunoSingleton*)sharedInstance;

- (void)salvar:(Aluno *)aluno;
- (NSMutableArray *)todosAlunos;
- (Aluno *)alunoComTIA:(NSString *)tia;
- (NSArray *)alunoComNome:(NSString *)nome;
-(void)deletarAluno:(Aluno *)Aluno;
@end
