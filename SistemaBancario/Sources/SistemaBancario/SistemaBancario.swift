import Foundation

// Conta do Banco
struct ContaCorrente {
    let conta: String
    let titular: String
    let cpf: String
    var senha: String
    var saldo: Double
    var isAdmin: Bool
}




@main
struct SistemaBancario {

    static func menuAdmin(contas: inout [ContaCorrente]) {

    //variavel para segurar o menuAtivo, a opção de sair é o 0 por padrão?
    var menuAtivo = true
    /*  
    
        MENU DO GERENTE
    */
    repeat {
        print("\n--- PAINEL DO GERENTE ---")
        print("1. Listar todas as contas")
        print("2. Remover conta")
        print("0. Logout")
        print("Escolha uma opção: ", terminator: "")
        
        let opcao = readLine() ?? ""
        
        switch opcao {
            case "1":
                print("\n--- RELATÓRIO GERAL ---")
                for c in contas {
                // Eu nao quero imprimir os valores do admin
                    if c.isAdmin {
                        continue
                    }
            
                print("Conta: \(c.conta) | Titular: \(c.titular) | Saldo: R$\(c.saldo)")
            }
            case "2":
                print("\nDigite o número da conta para excluir: ", terminator: "")
                let contaRemove = readLine() ?? ""
                
                // Não pode remover o próprio admin (0000), bom pode não deixar remover outros casos, como devedores...mas isso pode ser implementado quando for crescer o sistema. Bom na vdd acho que nem tinha que listar o adm
                //vou corrigir depois
                if contaRemove == "0000" {
                    print("Não pode remover o adm")
                } else if let index = contas.firstIndex(where: { $0.conta == contaRemove }) {
                    let removida = contas.remove(at: index)
                    print("Conta \(removida.conta) de \(removida.titular) removida!") //  AQUI ELE REMOVE COM SUCESSO UMA CONTA
                } else {
                    print("Conta não encontrada.") //se nao tiver conta vai dar erro
            }
            case "0":
                menuAtivo = false //sai do menu
            default:
                print("Opcao invalida.")
        }
    } while menuAtivo

    }

    //função do menu cliente... muito grande essa transferencia
    static func executarTransferencia(origem: ContaCorrente, banco: inout [ContaCorrente]) {
        
        // Precisa de uma conta de destino para transferir o dinheiro
        print("Digite o número da conta de destino: ", terminator: "")
        let contaDestino = readLine() ?? ""
        
        // Precisa digitar um valor para transferir
        print("Qual valor deseja transferir? R$", terminator: "")
        if let valorValido = Double(readLine() ?? "") {
            if let contaOrigem = banco.firstIndex(where: { $0.conta == origem.conta }),
            let contaDestino = banco.firstIndex(where: { $0.conta == contaDestino }) {
                //a pessoa precisa ter um saldo maior do que vai transferir o dinheiro....
                if valorValido <= banco[contaOrigem].saldo {
                    //dinheiro primeiro sai da origem 
                    banco[contaOrigem].saldo -= valorValido
                    //para ir para o destino
                    banco[contaDestino].saldo += valorValido
                    
                    print("Valor R$\(valorValido) enviado para \(banco[contaDestino].titular).")
                } else {
                    print("Saldo insuficiente. Seu saldo: R$\(banco[contaOrigem].saldo)")
                }
            } else {
                //Enfim outro erro se nao achar a conta do destino... nao vai dar para enviar...
                print("Erro: Conta de destino não encontrada.")
            }
        } else {
            print("Digite apenas numeros") //faltou fazer uma validação melhor
        }
    }

    /*
    
        MENU DO CLIENTE
    */

    static func menuUsuario(usuarioLogado: ContaCorrente, banco: inout [ContaCorrente]) {
    //nao vou usar menuAtivo vai que da ruim 
    var menuUser = true 
    
    repeat {
        // Buscamos o saldo atualizado direto do banco (array) 
        // Vai buscar minha conta de acordo com o que eu digitei e ficou no contalogada
        let saldoAtual = banco.first(where: { $0.conta == usuarioLogado.conta })?.saldo ?? 0.0
        
        print("\n--- ÁREA DO CLIENTE ---")
        print("Olá, \(usuarioLogado.titular)!")
        print("Saldo: R$\(saldoAtual)")
        print("--------------------------")
        print("1. Depositar")
        print("2. Transferir ")
        print("3. Imprimi extrato")
        print("0. Sair (Logout)")
        print("Escolha uma opcao: ", terminator: "")
        
        let opcao = readLine() ?? ""
        
        switch opcao {
        case "1":
            // Depositar
            print("\nDigite o valor para depósito: R$", terminator: "")
            if let valor = Double(readLine() ?? ""), valor > 0 {
                if let index = banco.firstIndex(where: { $0.conta == usuarioLogado.conta }) {
                    banco[index].saldo += valor
                    print("Depósito de R$\(valor) realizado!")
                }
            } else {
                print("Valor inválido.")// acho dificil ter valor invalido de deposito... mas enfim, acho que poderia ter um verificador
            }
            
        case "2":
            //função muito grande.... deixei separada
            executarTransferencia(origem: usuarioLogado, banco: &banco)
            
        case "3":
            if let index = banco.firstIndex(where: { $0.conta == usuarioLogado.conta }) {
            print("\n--- EXTRATO SIMPLIFICADO ---") // aqui eu poderia criar uma funcao para ter o historico de transação do sistema bancario... mas também vai ficar para implementar o sistema para um outro momento..
            print("Titular: \(banco[index].titular)")
            print("Conta:   \(banco[index].conta)")
            print("Saldo:   R$\(banco[index].saldo)")
            print("IMPRIMINDO ------------------------------")
            }

        case "0":
            print("Encerrando sessao... ")
            menuUser = false
        default:
            print("Opcao invalida")
        }
        
    } while menuUser // O loop continua enquanto menuUser for true
}





    static func main() {
        // 1. O array deve estar aqui dentro
        var sistemaContas: [ContaCorrente] = [
            ContaCorrente(conta: "0000", titular: "Administrador", cpf: "000", senha: "admin", saldo: 0.0, isAdmin: true),
            ContaCorrente(conta: "1001", titular: "Julia", cpf: "111.222.333-44", senha: "111", saldo: 500.0, isAdmin: false),
            ContaCorrente(conta: "1002", titular: "Mariana", cpf: "555.666.777-88", senha: "222", saldo: 1200.50, isAdmin: false)
        ]

        var contaLogada: ContaCorrente? = nil

        //Vou fazer a pessoa logar até digitar uma conta que exista no sistemaContas
        repeat {
            print("\n--- ACESSO AO SISTEMA ---")
            print("Digite o número da conta: ", terminator: "")
            let numeroDigitado = readLine() ?? ""
            
            print("Digite a senha: ", terminator: "")
            let senhaDigitada = readLine() ?? ""

            //Ok digitou a conta e a senha, ai vai ter que buscar a primeira conta que bater o resultado. Bom aqui é mais simples que um banco
            //pq o certo seria validar a conta separada da senha...aqui vai simplificado mesmo
            if let contaEncontrada = sistemaContas.first(where: { $0.conta == numeroDigitado && $0.senha == senhaDigitada }) {
                contaLogada = contaEncontrada
                print("\n Bem-vindo(a), \(contaEncontrada.titular).")
            } else {
                print("\n Conta ou senha incorretas. Tente novamente.")
            }

        } while contaLogada == nil

        // usuario
        if let usuario = contaLogada {
            if usuario.isAdmin {
                // user admin vai ter as funções
                print("Você entrou como Admin.")
                menuAdmin(contas: &sistemaContas)
            } else {
                // usuario comum vai ter as funções dele
                print("Você entrou como Cliente")
                menuUsuario(usuarioLogado: usuario, banco: &sistemaContas)
            }
        }



    }
    
    
}
