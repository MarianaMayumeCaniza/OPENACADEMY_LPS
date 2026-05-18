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

        // 3. Verificação do usuario
        if let usuario = contaLogada {
            if usuario.isAdmin {
                // user admin vai ter as funções
                print("Você entrou como Admin.")
            } else {
                // usuario comum vai ter as funções dele
                print("Você entrou como Usuário Comum.")
            }
        }
    }
    
    
}
