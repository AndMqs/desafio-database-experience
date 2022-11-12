
-- -----------------------------------------------------
-- CRIAÇÃO DO BD PARA O CENÁRIO DE E-commerce
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS Ecommerce;
USE Ecommerce ;

-- -----------------------------------------------------
-- CRIAR TABELA Cliente
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Cliente(
  idCliente INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
  Nome VARCHAR(20) NOT NULL,
  Sobrenome VARCHAR(45) NOT NULL,
  Endereco VARCHAR(300) NOT NULL,
  Telefone VARCHAR(15) NOT NULL,
  Email VARCHAR(100),
  CPF VARCHAR(11),
  CNPJ VARCHAR(14) 
  );

-- -----------------------------------------------------
-- CRIANDO TABELA Produto
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Produto(
  idProduto INT NOT NULL,
  Nome VARCHAR(50) NOT NULL,
  Categoria ENUM('Aminoácidos', 'Roupas', 'Vitaminas', 'Proteína', 'Acessórios', 'Termogênicos') NOT NULL,
  Descrição VARCHAR(500) NOT NULL,
  Valor FLOAT NOT NULL,
  Avaliacao FLOAT NULL,
  PRIMARY KEY (idProduto)
  );

-- -----------------------------------------------------
-- CRIANDO TABELA Estoque
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Estoque(
  idEstoque INT NOT NULL,
  idEstoqueProd INT NOT NULL,
  Nome VARCHAR(50) NULL,
  Local_Estoque VARCHAR(300) NULL,
  Qtd_Produto INT NULL DEFAULT 0,
  PRIMARY KEY (idEstoque, idEstoqueProd)
  
);

-- -----------------------------------------------------
-- CRIANDO TABELA PEDIDO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Pedido(
  idPedido INT NOT NULL,
  idPedidoCliente INT,
  descricao_pedido VARCHAR(300),
  status_pedido ENUM('Cancelado', 'Confirmado', 'Em processamento') NULL DEFAULT 'Em processamento',
  valor_frete FLOAT NULL DEFAULT 10,
  pagamento TINYINT NULL DEFAULT 0,
  Cliente_idCliente INT NOT NULL,
  PRIMARY KEY (idPedido, Cliente_idCliente),
  CONSTRAINT fk_Pedido_Cliente1  FOREIGN KEY (Cliente_idCliente)  REFERENCES Cliente(idCliente)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- -----------------------------------------------------
-- CRIANDO A TABELA Pagamento
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Pagamento(
  id_Pagamento INT NOT NULL,
  id_Cliente INT NOT NULL,
  FormaPagamento ENUM('Boleto', 'Cartão de crédito1', 'Cartão de crédito 2', 'PIX') NOT NULL,
  LimiteDisponivel FLOAT NULL,
  PRIMARY KEY (id_Pagamento, id_Cliente)
);


-- -----------------------------------------------------
-- CRIANDO TABELA 	Pedido tem Produto
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Pedido_tem_Produto (
  Pedido_idPedido INT NOT NULL,
  Produto_idProduto INT NOT NULL,
  Quantidade VARCHAR(45),
  ProdutoStatus ENUM ('Disponível', 'Sem estoque') DEFAULT 'Disponível',
  PRIMARY KEY (Pedido_idPedido, Produto_idProduto),
  CONSTRAINT fk_Pedido_has_Produto_Pedido1 FOREIGN KEY (Pedido_idPedido) REFERENCES Pedido(idPedido)
    ON DELETE CASCADE 
    ON UPDATE CASCADE,
  CONSTRAINT fk_Pedido_has_Produto_Produto1 FOREIGN KEY (Produto_idProduto) REFERENCES Produto(idProduto)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- CRIANDO TABELA Vendedor
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Terceiro_Vendedor(
  idVendedor INT NOT NULL,
  Razão_Social VARCHAR(150) NULL,
  Nome_Fantasia VARCHAR(150) NULL,
  CNPJ CHAR(15) NOT NULL,
  Endereco VARCHAR(300) NOT NULL,
  Telefone VARCHAR(11) NOT NULL,
  PRIMARY KEY (idVendedor),
  CONSTRAINT UNIQUE_CNPJ_VENDEDOR UNIQUE (CNPJ)

);

-- -----------------------------------------------------
-- CRIANDO TABELA Produto_tem_Terceiro_Vendedor
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Produto_tem_Terceiro_Vendedor(
  Produto_idProduto INT NOT NULL,
  Terceiro_idVendedor INT NOT NULL,
  PRIMARY KEY (Produto_idProduto, Terceiro_idVendedor),
  CONSTRAINT fk_Produto_has_Terceiro_Vendedor_Produto1 FOREIGN KEY (Produto_idProduto) REFERENCES Produto (idProduto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Produto_has_Terceiro_Vendedor_Vendedor1 FOREIGN KEY (Terceiro_idVendedor) REFERENCES Terceiro_Vendedor (idVendedor)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- -----------------------------------------------------
-- CRIANDO TABELA Fornecedor
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Fornecedor(
  idFornecedor INT,
  Estoque_idEstoque INT,
  Razão_Social VARCHAR(45) NOT NULL,
  CNPJ VARCHAR(45) NOT NULL,
  Telefone VARCHAR(11) NOT NULL,
  Email VARCHAR(50),
  PRIMARY KEY (idFornecedor, Estoque_idEstoque),
  CONSTRAINT UNIQUE_CNPJ_FORNECEDOR UNIQUE (CNPJ),
  CONSTRAINT fk_Fornecedor_Estoque1 FOREIGN KEY (Estoque_idEstoque) REFERENCES Estoque (idEstoque)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- CRIANDO TABELA Pedido_has_Pagamento
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Pedido_tem_Pagamento(
  Pedido_idPedido INT,
  Pedido_Cliente_idCliente INT,
  Pagamento_id_Pagamento INT,
  Pagamento_id_Cliente INT ,
  PRIMARY KEY (Pedido_idPedido, Pedido_Cliente_idCliente, Pagamento_id_Pagamento, Pagamento_id_Cliente),
  CONSTRAINT fk_Pedido_has_Pagamento_Pedido1 FOREIGN KEY (Pedido_idPedido , Pedido_Cliente_idCliente) REFERENCES Pedido (idPedido , Cliente_idCliente)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_Pedido_has_Pagamento_Pagamento1 FOREIGN KEY (Pagamento_id_Pagamento , Pagamento_id_Cliente) REFERENCES Pagamento (id_Pagamento , id_Cliente)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- CRIANDO TABELA Entrega
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Entrega (
  idEntrega INT NOT NULL,
  idPedido INT NOT NULL,
  idCliente INT NOT NULL,
  StatusEntrega ENUM('Em Processamento', 'Cancelada', 'Encaminhada', 'Entregue') NULL DEFAULT 'Em Processamento',
  DataAtualizacao DATE NULL,
  PRIMARY KEY (idEntrega, idPedido, idCliente),
  CONSTRAINT fk_Entrega_Pedido FOREIGN KEY (idPedido , IdCliente) REFERENCES Pedido (idPedido, Cliente_idCliente)
);

-- -----------------------------------------------------
-- CRIANDO TABELA Devolução
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Devolução(
  idDevolucao INT,
  idEntrega INT,
  Identificação_Produto VARCHAR(45) NULL,
  Descricao_defeito VARCHAR(200) NULL,
  Forma_Devolucao ENUM('Novo produto', 'Valor em crédito', 'Devolução do dinheiro') NULL,
  PRIMARY KEY (idDevolucao, idEntrega),
  CONSTRAINT fk_Devolucao_Entrega FOREIGN KEY (idEntrega) REFERENCES Entrega (idEntrega)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


-- -----------------------------------------------------
-- CRIANDO TABELA Empresa_Transporte
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Empresa_Transporte(
  idEmpresa INT NOT NULL,
  idEntrega INT NOT NULL,
  Status_pedido ENUM('Despachado', 'A caminho', 'Entregue', 'Devolvido') NULL,
  Código_Rastreio VARCHAR(45) NULL,
  Razão_Social VARCHAR(150) NOT NULL,
  Nome_Fantasia VARCHAR(150) NULL,
  CNPJ CHAR(15) NOT NULL,
  Telefone VARCHAR(15) NOT NULL,
  Email VARCHAR(50),
  PRIMARY KEY (idEmpresa, idEntrega),
  CONSTRAINT UNIQUE_CNPJ_EMPRESA UNIQUE (CNPJ),
  CONSTRAINT fk_Empresa_Transporte_Entrega1 FOREIGN KEY (idEntrega) REFERENCES Entrega (idEntrega)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- CRIANDO TABELA Produto_has_Estoque
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Produto_has_Estoque(
  Produto_idProduto INT,
  Estoque_idEstoque INT,
  PRIMARY KEY (Produto_idProduto, Estoque_idEstoque),
  CONSTRAINT fk_Produto_has_Estoque_Produto1 FOREIGN KEY (Produto_idProduto) REFERENCES Produto (idProduto)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_Produto_has_Estoque_Estoque1 FOREIGN KEY (Estoque_idEstoque) REFERENCES Estoque (idEstoque)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- INSERÇÃO DE DADOS E QUERIES
-- -----------------------------------------------------

show tables;
desc Cliente;
-- idCliente, nome, sobrenome, endereço, telefone, email, CPF
insert into Cliente (Nome, Sobrenome, Endereco, Telefone, Email, CPF)
       values ('Andresa', 'Marques', 'Rua Dr. Laerte 35, Pequis - UberLandia', '3299965522', 'andresa.m@email.com', '12121212121'),
			  ('Ricardo', 'Assis', 'Rua Prego de Arueira 265, Jardim - Campos', '5268163845', 'ric_cardo@email.com', '23232323232'),
              ('Mateus', 'Silva', 'Rua Laranjeiras 85, Centro - Cidade das Flores', '1582364798', 'silva@email.com', '45454545454'),
              ('Julia', 'Pereira', 'Avenida Campos Lemos 9965, Centro - Itajaí', '1237469582', 'julia_pereira@email.com', '85858585858'),
              ('Cleiton', 'Cruz', 'Alameda Vinha 874, Esperança - Minas', '2246358791', 'cruz_clei@email.com', '24242424242');

desc Produto;
-- idProduto, nome, Categoria (Aminoácidos, Roupas, Vitaminas, Proteína, Acessórios, Termogênicos) , descrição, valor, avaliação
insert into Produto (idProduto, Nome, Categoria, Descrição, Valor, Avaliacao)
	   values (1,'Creatina', 'Aminoácidos', 'Fundamental na contração muscular, proporcionando maior força muscular, resistência física, redução no tempo de recuperação, e aumento do volume muscular.',
				'75.00', '4'),
			  (2,'Whey Protein', 'Proteína', 'O whey protein é um suplemento alimentar que nos ajuda a complementar a quantidade de proteínas diárias que necessitamos.',
              '90.00', '5'),
              (3, 'Cafeína 420mg', 'Termogênicos', 'Cafeína é um elemento que pode desenvolver diferentes reações nas pessoas. Cada uma pode apresentar sintomas específicos. Há pessoas que metabolizam bem a cafeína e há outras que não possuem boa tolerância.',
              '45.00', '3'),
              (4, 'Coqueteleira', 'Acessórios', 'A coqueteleira de treino é feita de plástico, com fechamento à prova de vazamento tanto pra você chacoalhar quanto pra tomar o suplemento.', '20.00', '2'),
              (5, 'Multivitamínico', 'Vitaminas', 'Fonte de nutrientes indispensáveis para uma rotina saudável. Com uma cápsula por dia, você garante uma boa dose de vitaminas e minerais, nutrientes importantes para o bom funcionamento do organismo.',
              '37.00', '5');

select * from Cliente;
Select *from Produto;

desc Pedido;
-- idPedidoCliente, descricao_pedido, status_pedido, valor_frete, pagamento, Cliente_idCliente
insert into Pedido(idPedido, idPedidoCliente, descricao_pedido, status_pedido, valor_frete, pagamento, Cliente_idCliente)
       values (1, 1, 'Whey Protein 1kg, Creatina 500mg', 'Em processamento', null, 1, 1),
			  (2, 2,'Multivitamínico - 3 caixas', 'Confirmado', 10, 2, 5),
              (3, 3,'Cafeína 420mg', 'Cancelado', 10, 4, 3),
              (4, 2,'Whey Protein 1kg', 'Em processamento', 10, 2, 5);


desc Pedido_tem_Produto;
-- idPedido, idProduto, Quantidade do produto, satus do produto
insert into Pedido_tem_Produto (Pedido_idPedido, Produto_idProduto, Quantidade, ProdutoStatus)
	   values (1, 2, 2, null),
              (2, 1, 3, null),
              (3, 3, null, default);

desc Estoque;
insert into Estoque (idEstoque, idEstoqueProd, Nome, Local_Estoque, Qtd_Produto)
	   values(1, 1, 'Estoque Rápido', 'Rio de Janeiro', 1000),
			 (2, 5, 'Galpão Rei', 'Rio de Janeiro', 100),
		     (3, 3, null, 'São Paulo', 500),
             (4, 4, 'Piá Armazén', 'Maranhão', 600),
             (5, 2, null , 'Espírito Santo', 500);

desc Terceiro_Vendedor;
insert into Terceiro_Vendedor (idVendedor, Razão_Social, Nome_Fantasia, CNPJ, Endereco, Telefone)
	   values (1, 'JAA Suplementos', 'Mister Músculos', 123652847952874, 'Rua Dolradinho 98 - Campo Grande/SP', 11457845123),
			  (2, 'Joao Termogênicos', 'Termogênicos', 203746852057895, 'Rua Romario Ruim 2236 - Jardins/ RJ', 21556894354),
              (3, 'Ricardo e Cia', 'Super Suplementos', 850006987326085, 'Rua Painel 05 - Campo Grande/SP', 21569875981),
			  (4, 'Guto Parrudo CIA', null, 251486329751245, 'Rua Delrei 320 - Cidadezinha/PR', 26999995555); 
              
desc Pagamento;
-- idCliente, idPagamento, Forma de pagamento, limite diponivel
insert into Pagamento (id_Pagamento, id_Cliente, FormaPagamento, LimiteDisponivel)
	   values (1, 5, 'Boleto', 500.00),
			  (2, 3, 'Cartão de crédito1', 1500.00),
              (3, 2, 'PIX', 2000.00),
              (4, 1, 'PIX', 3000.00),
              (5, 4, 'Boleto', 1500.00);
              
desc Fornecedor;
-- idFornecedor, Estoque_idEstoque, Razão_Social, CNPJ, Telefone, Email
insert into Fornecedor (idFornecedor, Estoque_idEstoque, Razão_Social, CNPJ, Telefone, Email)
	   values (1 , 5, 'Guto Parrudo CIA', 251486329751245, 26999995555, null),
			  (2, 3, 'Rei da Creatina J.A', 000132564800752, 11926547813, 'reidacreatina@estoque.com'),
              (3, 1, 'Robson Suplementos CIA', 652000089536002, 21965321245, null),
              (4, 2, 'Tem de tudo P. A.', 251365478945321, 94925631458, 'suplemetostem@temdetudo.com'),
              (5, 4, 'Marcia Maria Almeida', 000000152634589, 85231657498, null);

desc Entrega;
-- idEntrega, idPedido, idCliente, StatusEntrega, DataAtualizacao
insert into Entrega (idEntrega, idPedido, idCliente, StatusEntrega, DataAtualizacao)
	   values (1, 1, 1, null, null),
			  (2, 2, 5, 'Em processamento', 20/08/22),
              (3, 3, 3, 'Cancelada', NULL);
              
desc Devolução;
-- idDevolucao, idEntrega, Identificação_Produto, Descricao_defeito, Forma_Devolucao
-- Não vou atribuir nada a essa tabela porque não houve devolução de pedido no exemplo; lembrando que o pedido precisa ser entrege para que haja a possibilidade de devolução


desc Empresa_Transporte;
-- idEmpresa, idEntrega, Status_pedido, Código_Rastreio, Razão_Social, Nome_Fantasia, CNPJ, Telefone, Email
insert into Empresa_Transporte (idEmpresa, idEntrega, Status_pedido, Código_Rastreio, Razão_Social, Nome_Fantasia, CNPJ, Telefone, Email)
	   values (2, 3, 'Despachado', 'FL5236874521R', 'B.C. Flash', 'Entregas dFlash', 000006255184773, 21958746325, 'flash_entregas@flash.com'),
		      (3, 3, null, null, 'Cegonha Transportes', null, 135600008749532, 11952418764, null);
              
              
select count(*) from Cliente; -- Contando quantos clientes tem registrado

select * from Cliente c order by Endereco asc; -- Clientes apresentados por ordem alfabética de seus endereços

select * from Cliente c, Pedido d where c.idCliente = Cliente_idCliente order by Nome; -- Somente os Clientes e seus dados com o pedido realizado 

select Nome , cliente_idCliente as "Identificação", count(*) as "Quantidade de Pedidos" -- Quantidade de pedidos que foram feitos por cada cliente
	from Cliente c, Pedido d 
    where c.idCliente = cliente_idCliente
    group by cliente_idCliente;
    
select * from Terceiro_Vendedor a inner join Fornecedor b on a.Razão_Social = b.Razão_Social ; -- Vendedor que também é fornecedor

select idEstoque as "Estoque", idFornecedor as "Fornecedor", Nome as "Produto" ,  -- Relação de nomes dos fornecedores e nomes dos produtos;
Razão_Social as "Razão Social", CNPJ, Telefone 
	from Fornecedor c 
		cross join Estoque on c.Estoque_idEstoque = idEstoque
		cross join Produto on idEstoqueProd = idProduto
			order by Nome, Razão_Social ASC;  
    
select p.Nome as "Nome dos Produtos", Razão_Social as "Fornecedores" from Fornecedor -- Relação de nomes dos fornecedores e nomes dos produtos;
inner join Estoque a on Estoque_idEstoque = idEstoque 
inner join Produto p on idEstoqueProd = idProduto;

Select * from Produto where Categoria like "%ei%"; -- Somente produtos que tenham o 'ei' na categoria
    

SELECT * FROM Fornecedor -- Relação de produtos, fornecedores e estoques;
	JOIN Estoque JOIN Produto;

SELECT concat(Nome,' ',Sobrenome) as "Nome Completo", Endereco, CPF FROM Cliente, Pedido -- Clientes que tem pedidos onde o endereço com a palavra 'rua'
	WHERE idPedidoCliente = idCliente
		GROUP BY CPF
			HAVING Endereco like "%Rua%" 
				ORDER BY Nome ASC;





             
              
 