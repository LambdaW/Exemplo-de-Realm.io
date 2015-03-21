//
//  ViewController.m
//  Persistencia_Realm.io
//
//  Created by joaquim on 16/03/15.
//  Copyright (c) 2015 joaquim. All rights reserved.
//

#import "ViewController.h"
#import "Aluno.h"
#import "AlunoSingleton.h"
#import "FotoSingleton.h"
#import <AVFoundation/AVFoundation.h>


@interface ViewController ()
{
    AlunoSingleton *alunoSingleton;
    NSMutableArray *alunos;
    Aluno *alunoSelecionado;
    UIToolbar *fotoToolBar;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    alunoSelecionado = nil;
    alunoSingleton = [AlunoSingleton sharedInstance];
    alunos = [alunoSingleton todosAlunos];
    
    CGFloat posicaoY = self.view.bounds.size.height-44;
    CGFloat posicaoX = 0;
    CGFloat width = _tableView.bounds.size.width;
    CGFloat height = 44;
    
    fotoToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(posicaoX, posicaoY, width, height)];
    [fotoToolBar setBackgroundColor:[UIColor blackColor]];
    
    UIBarButtonItem *addFotoItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(vincularFoto)];
    UIBarButtonItem *cancelarEdicao = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelarEdicao)];
    
    UIBarButtonItem *removerFoto = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(rmFoto)];
    
    
#warning Implementar botao de remocao
    
    
    NSArray *itens = @[addFotoItem,cancelarEdicao, removerFoto];
    [fotoToolBar setItems:itens];
    
#warning Captura evento de rotacao de tela para recalcular posicao da toolbar
    [[NSNotificationCenter defaultCenter] addObserver: self selector:   @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
    
}

-(void)rmFoto{
   // [_nomeTextField resignFirstResponder];
    //[_tiaTextField resignFirstResponder];
    
    alunoSingleton = [AlunoSingleton sharedInstance];
 //   [alunoSingleton deletarAluno:alunoSelecionado];
    if (alunoSelecionado) {
        [alunoSingleton deletarAluno:alunoSelecionado];
       alunos = [alunoSingleton todosAlunos];
    
    
        
   } else {
        Aluno *novoAluno = [[Aluno alloc] init];
        [novoAluno setNome:_nomeTextField.text];
        [novoAluno setTia:_tiaTextField.text];
        
        [alunoSingleton salvar:novoAluno];
        alunos = [alunoSingleton todosAlunos];
                  }
    
    
   [self cancelarEdicao];
    
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 }

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

#pragma mark - Metodos privados

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    //Obter a orientacao corrente (nao necessario neste projeto
//    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    CGFloat posicaoY = self.view.bounds.size.height-44;
    CGFloat posicaoX = 0;
    CGFloat width = _tableView.bounds.size.width;
    CGFloat height = 44;
    [fotoToolBar setFrame:CGRectMake(posicaoX, posicaoY, width, height)];
}

-(void)vincularFoto {
    if (!alunoSelecionado) {
        return;
    }
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    // Add inputs and outputs.
    
    [session startRunning];
    
    UIImage *foto = [UIImage imageNamed:@"smile"];
    [[FotoSingleton sharedInstance] salvarFoto:foto comNome:alunoSelecionado.tia];
    [_tableView reloadData];
}

- (void)cancelarEdicao {
    [_nomeTextField setText:@""];
    [_tiaTextField setText:@""];
    alunoSelecionado = nil;
    [_botaoSalvar setTitle:@"Salvar" forState:UIControlStateNormal];
    [_tiaTextField setEnabled:YES];
          [fotoToolBar removeFromSuperview];
    [_tableView deselectRowAtIndexPath:[_tableView
                                              indexPathForSelectedRow] animated: YES];
}


#pragma mark - Metodos publicos

- (IBAction)salvar:(id)sender {
    [_nomeTextField resignFirstResponder];
    [_tiaTextField resignFirstResponder];
    
    if (alunoSelecionado) {
        RLMRealm *realm = [alunoSelecionado realm];
        [realm beginWriteTransaction];
        [alunoSelecionado setNome:_nomeTextField.text];
        [alunoSelecionado setTia:_tiaTextField.text];
        [realm commitWriteTransaction];
        
    } else {
        Aluno *novoAluno = [[Aluno alloc] init];
        [novoAluno setNome:_nomeTextField.text];
        [novoAluno setTia:_tiaTextField.text];
        
        [alunoSingleton salvar:novoAluno];
        alunos = [alunoSingleton todosAlunos];
    }
    
    
    [self cancelarEdicao];
    [_tableView reloadData];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_nomeTextField resignFirstResponder];
    [_tiaTextField resignFirstResponder];
}


#pragma mark - TableViewDataSource Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [alunos count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"alunoCell"];
    Aluno *aluno = [alunos objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:aluno.nome];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"TIA: %@",aluno.tia ]];

    UIImage *foto = [[FotoSingleton sharedInstance] recuperarFotoComNome:aluno.tia];
    
    if (foto) {
        [cell.imageView setImage:foto];
    }
    
    
    return cell;
}

#pragma mark - TableViewDelegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    alunoSelecionado = [alunos objectAtIndex:indexPath.row];
    [_nomeTextField setText:alunoSelecionado.nome];
    [_tiaTextField setText:alunoSelecionado.tia];
    [_tiaTextField setEnabled:NO];
    [_botaoSalvar setTitle:@"Alterar" forState:UIControlStateNormal];
    [self.view addSubview:fotoToolBar];
}

@end
