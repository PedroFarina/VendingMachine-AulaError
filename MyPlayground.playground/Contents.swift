import Foundation

enum ProductName: String {
    case Minecraft = "Mainecrafti oliginal"
    case Milhopa = "Milhopã"
    case Julio = "Julho"
    case Sorvete = "Sorvetex La Basque"
    case ComputadorRGB = "Computation RGBzation"
}

class VendingMachineProduct {
    var name: ProductName
    var amount: Int
    var price: Double

    init(name: ProductName, amount: Int, price: Double) {
        self.name = name
        self.amount = amount
        self.price = price
    }

    func orderStock() {
        amount += 2
    }

    func buy(with money: inout Double) {
        money -= price
        amount -= 1
    }
}

enum VendingMachineError: Error {
    case productNotFound
    case productUnavailable
    case insufficientFunds
    case productStuck
}

//TODO: Definir os erros

class VendingMachine {
    private var estoque: [VendingMachineProduct]
    private var money: Double
    
    init(products: [VendingMachineProduct]) {
        self.estoque = products
        self.money = 0
    }
    
    func getProduct(named name: ProductName, with money: Double) throws {
        //TODO: receber o dinheiro e salvar em uma variável
        self.money = money
        //TODO: achar o produto que o cliente quer
        guard let product = estoque.first(where: {$0.name == name}) else { throw VendingMachineError.productNotFound }
        //TODO: ver se ainda tem esse produto
        guard product.amount > 0 else {
            product.orderStock()
            throw VendingMachineError.productUnavailable }
        //TODO: ver se o dinheiro é o suficiente pro produto
        guard product.price <= self.money else { throw VendingMachineError.insufficientFunds }
        //TODO: entregar o produto
        product.buy(with: &self.money)
        if Int.random(in: 1...10) == 1 {
            throw VendingMachineError.productStuck
        }
    }
    
    func getTroco() -> Double {
        //TODO: devolver o dinheiro que não foi gasto
        defer {
            self.money = 0
        }
        return money
    }
}

let vendingMachine = VendingMachine(products: [.init(name: .Minecraft, amount: 50, price: 15),
                                               .init(name: .Milhopa, amount: 100, price: 2),
                                               .init(name: .Julio, amount: 1, price: 3000),
                                               .init(name: .Sorvete, amount: 1, price: 38)])

for _ in 0...10 {
    let money = Double(Int.random(in: 10...4000))
    let products: [ProductName] = [.Julio, .Milhopa, .Minecraft, .Sorvete, .ComputadorRGB]
    guard let product = products.randomElement() else {
        print("Algo de errado não deu certo")
        continue
    }

    do {
        print("Quieres comprar un \(product.rawValue)?")
        try vendingMachine.getProduct(named: product, with: money)
        print("Grats, you comprou um \(product.rawValue), take \(vendingMachine.getTroco()) de volte")
    } catch let err as VendingMachineError {
        switch err {
        case .insufficientFunds:
            print("No money bro")
        case .productNotFound:
            print("No producto hombre")
        case  .productStuck:
            print("Instructions unclear, got product stuck and you lost your diñero")
        case .productUnavailable:
            print("Product not found #404")
        }
    } catch {
        print("Erro desconhecido")
    }
}
