
-- -----------------------------------------------------
-- CRIAÇÃO DO BD PARA O CENÁRIO OFICINA
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS Oficina;
USE Oficina;

-- -----------------------------------------------------
-- CRIANDO TABELA CLIENTE
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS Cliente(
  idCliente INT AUTO_INCREMENT NOT NULL,
  Autoriza_Servicos ENUM ('SIM', 'NÃO', 'AGUARDANDO') DEFAULT 'AGUARDANDO',
  Revisao VARCHAR(45) NULL,
  Conserto VARCHAR(45) NULL,
  PRIMARY KEY (idCliente)
  );

-- -----------------------------------------------------
-- CRIANDO TABELA CADASTRO
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS Cadastro(
  idCadastro INT AUTO_INCREMENT NOT NULL,
  Cliente_idCliente INT NOT NULL,
  Nome VARCHAR(45) NULL,
  Endereco VARCHAR(300) NULL,
  Especificacoes_veiculo VARCHAR(45) NULL,
  PRIMARY KEY (idCadastro, Cliente_idCliente),
   CONSTRAINT fk_Cadastro_Cliente1 FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente(idCliente)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- CRIANDO TABELA VEICULO
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS Veiculo(
  idVeiculo INT AUTO_INCREMENT NOT NULL,
  Cadastro_idCadastro INT NOT NULL,
  Cadastro_Cliente_idCliente INT NOT NULL,
  Categoria ENUM ('Carro', 'Moto', 'Caminhão', 'Ônibus', 'Outro') NULL,
  Modelo VARCHAR(45) NULL,
  Placa VARCHAR(7) NULL,
  PRIMARY KEY (idVeiculo),
  CONSTRAINT fk_Veiculo_Cadastro1 FOREIGN KEY (Cadastro_idCadastro, Cadastro_Cliente_idCliente) REFERENCES Cadastro (idCadastro, Cliente_idCliente)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- CRIANDO TABELA EQUIPE_DE_SERVICO
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS Equipe_de_Servico(
  idEquipe INT AUTO_INCREMENT NOT NULL,
  Especificacao_do_Servico VARCHAR(300) NOT NULL,
  PRIMARY KEY (idEquipe)
);

-- -----------------------------------------------------
-- CRIANDO TABELA ORDEMDESERVICO
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS OrdemdeServico(
  idOrdemDeServico INT AUTO_INCREMENT NOT NULL,
  Equipe_de_Servico_idEquipe INT NOT NULL,
  Número_OS VARCHAR(15) NULL,
  Especificacoes VARCHAR(45) NULL,
  Status_do_Trabalho ENUM  ('Iniciado', 'Em processo', 'Finalizado', 'Cancelado', 'Aguardando aprovação'),
  Data_de_entrega DATE NULL,
  Valor FLOAT,
  PRIMARY KEY (idOrdemDeServico, Equipe_de_Servico_idEquipe),
  CONSTRAINT fk_Ordem_de_Servico_Equipe_de_Servico1 FOREIGN KEY (Equipe_de_Servico_idEquipe) REFERENCES Equipe_de_Servico (idEquipe)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


-- -----------------------------------------------------
-- CRIANDO TABELA SERVICO
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS Servico (
  idServico INT AUTO_INCREMENT NOT NULL,
  OrdemDeServico_idOrdemDeServico INT NOT NULL,
  Cliente_idCliente INT NOT NULL,
  Tipo_de_Servico VARCHAR(200) NULL,
  Avaliacao VARCHAR(100) NULL,
  Valor VARCHAR(45) NULL,
  PRIMARY KEY (idServico, OrdemDeServico_idOrdemDeServico, Cliente_idCliente),
  CONSTRAINT fk_Servico_OrdemDeServico1
    FOREIGN KEY (OrdemDeServico_idOrdemDeServico) REFERENCES OrdemdeServico (idOrdemDeServico)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_Servico_Cliente1 FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente (idCliente)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- CRIANDO TABELA PECAS
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS Pecas (
  idPecas INT AUTO_INCREMENT NOT NULL,
  TipoPeca VARCHAR(45) NULL,
  Valor FLOAT NULL,
  PRIMARY KEY (idPecas)
);

-- -----------------------------------------------------
-- CRIANDO TABELA MAO_DE_OBRA
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS MaoDeObra (
  idMaoDeObra INT AUTO_INCREMENT NOT NULL,
  Qualificacao VARCHAR(45) NULL,
  Valor VARCHAR(100) NULL,
  Equipe_de_Servico_idMecanico INT NOT NULL,
  PRIMARY KEY (idMaoDeObra, Equipe_de_Servico_idMecanico),
  CONSTRAINT fk_Mao_de_Obra_Equipe_de_Servico1
    FOREIGN KEY (Equipe_de_Servico_idMecanico)
    REFERENCES Equipe_de_Servico (idEquipe)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


-- -----------------------------------------------------
-- CRIANDO TABELA Pecas_has_OrdemDeServico
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS Pecas_has_OrdemDeServico (
  Pecas_idPecas INT NOT NULL,
  OrdemDeServico_idOrdemDeServico INT NOT NULL,
  CONSTRAINT fk_Pecas_has_OrdemDeServico_Pecas1 FOREIGN KEY (Pecas_idPecas) REFERENCES Pecas(idPecas)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_Pecas_has_OrdemDeServico_OrdemDeServico1 FOREIGN KEY (OrdemDeServico_idOrdemDeServico)
    REFERENCES OrdemdeServico (idOrdemDeServico)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- CRIANDO TABELA MECANICO
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS Mecanico (
  idMecanico INT NOT NULL,
  Area_Especializacao VARCHAR(50) NULL,
  Nome VARCHAR(50) NULL,
  Endereco VARCHAR(150) NULL,
  Codigo VARCHAR(45) NULL,
  CONSTRAINT fk_Mecanico_Equipe_de_Servico FOREIGN KEY (idMecanico) REFERENCES Equipe_de_Servico (idEquipe)
      ON DELETE CASCADE
	  ON UPDATE CASCADE
);



-- -----------------------------------------------------
-- CRIANDO TABELA VEICULO_HAS_SERVICO
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS veiculo_has_servico (
  Veiculo_idVeiculo INT NOT NULL,
  Servico_idServico INT NOT NULL,
  Servico_OrdemDeServico_idOrdemDeServico INT NOT NULL,
  PRIMARY KEY (Veiculo_idVeiculo, Servico_idServico, Servico_OrdemDeServico_idOrdemDeServico),
  CONSTRAINT fk_Veiculo_has_Servico_Veiculo1 FOREIGN KEY (Veiculo_idVeiculo) REFERENCES Veiculo (idVeiculo)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_Veiculo_has_Servico_Servico1 FOREIGN KEY (Servico_idServico, Servico_OrdemDeServico_idOrdemDeServico) REFERENCES Servico (idServico , OrdemDeServico_idOrdemDeServico)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


-- -----------------------------------------------------
-- CRIANDO TABELA MAODEOBRA_HAS_MECANICO
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS MaoDeObra_has_Mecanico (
  MaodeObra_idMaoDeObra INT NOT NULL,
  MaodeObra_Equipe_de_Servico_idMecanico INT NOT NULL,
  Mecanico_idMecanico INT NOT NULL,
  PRIMARY KEY (MaodeObra_idMaoDeObra, MaodeObra_Equipe_de_Servico_idMecanico, Mecanico_idMecanico),
  CONSTRAINT fk_MaodeObra_has_Mecanico_MaodeObra1 FOREIGN KEY (MaodeObra_idMaoDeObra , MaodeObra_Equipe_de_Servico_idMecanico) REFERENCES MaoDeObra (idMaoDeObra , Equipe_de_Servico_idMecanico)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_MaodeObra_has_Mecanico_Mecanico1 FOREIGN KEY (Mecanico_idMecanico) REFERENCES Mecanico (idMecanico)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- *******************************************************
-- INSERÇÃO DE DADOS 
-- *******************************************************

desc cliente;
-- idCliente, Autoriza_Servicos, Revisao, Conserto
insert into Cliente (Autoriza_Servicos, Revisao, Conserto)
	   values ('AGUARDANDO', 'Sim', 'Não'),
			  ('SIM', 'SIM', 'SIM'),
              ('NÃO', 'NÃO', 'SIM');			
              
desc Cadastro;
select * from cliente;
-- Cliente_idCliente, Nome, Endereco, Especificacoes_veiculo
insert into Cadastro (Cliente_idCliente, Nome, Endereco, Especificacoes_veiculo)
	   values (1, 'Valter Ramos', 'Avenida Nelson Mandela 85, Zona Leste - Cidade Verde', 'Moto, CBX250, Vermelho, Ano 2015'),
              (2, 'Maria Aparecida Vieira', 'Rua das Alamedas 654, Maravilha - Santa Mônica', 'Caminhão, Scania R450, Branco, Ano 2020'),
              (3, 'Bianca Mattus', 'Rua Laranjeiras 85, Centro - Cidade das Flores', 'Carro, Sandero, Prata, Ano 2006');


desc veiculo;
-- Cadastro_idCadastro, Cadastro_Cliente_idCliente, Categoria, Modelo, Placa
insert into veiculo (Cadastro_idCadastro, Cadastro_Cliente_idCliente, Categoria, Modelo, Placa)
	        values (1, 1, 'Moto','CBX250', 'JFH6521'),
				   (2, 2, 'Caminhão', 'Scania R450', 'S4DR62F'),
                   (3, 3, 'Carro', 'Sandero', 'P5AS238');
                 

desc Equipe_de_Servico;
-- Especificacao_do_Servico
insert into Equipe_de_Servico (Especificacao_do_Servico)
	   values ('Troca de óleo'),
			  ('Troca de óleo, Empreagem e freios'),
			  ('Lataria Traseira');
              

desc OrdemdeServico;			
-- idOrdemDeServico, Equipe_de_Servico_idEquipe, Número_OS, Especificacoes, Status_do_Trabalho, Data_de_entrega, Valor              
insert into OrdemdeServico (Equipe_de_Servico_idEquipe, Número_OS, Especificacoes, Status_do_Trabalho, Data_de_entrega, Valor)
	   values (1, 150, null, 'Aguardando aprovação', 15/11/22, 100),
			  (2, 151, 'Requer equipe específica', 'Iniciado', 20/11/22,2200),
			  (3, 152, 'Requer equipe específica',  'Cancelado', 21/11/22, 1600);
              
              
desc Servico;
select * from ordemdeservico;
-- idServico, OrdemDeServico_idOrdemDeServico, Cliente_idCliente, Tipo_de_Servico, Avaliacao, Valor
insert into Servico (OrdemDeServico_idOrdemDeServico, Cliente_idCliente, Tipo_de_Servico, Avaliacao, Valor)
values (1, 1, 'Revisão: Troca de óleo', null, 'R$100,00'),
       (2, 2, 'Revisão: Troca de óleo | Mecânico: conserto de empreagem e freio', 'Serviço de dificuldade média', 'R$2.200,00'),
       (3, 3, 'Conserto: Lataria traseira - desamassar, polir, pintar', 'Serviço de dificuldade alta', 'R$1.600,00');

desc Pecas;
-- idPecas, TipoPeca,Valor
insert into Pecas (TipoPeca,Valor)
values ('Oleo', 50),
	   ('Jogo de Empreagem e freio, oleo', 1800),
       ('Assoalho da caçamba, tinta', 1000);

desc MaodeObra;
select * from mecanico;
-- idMaoDeObra, Qualificacao, Valor, Equipe_de_Servico_idMecanico
insert into MaodeObra (Qualificacao, Valor, Equipe_de_Servico_idMecanico)
values ('Mecânico básico', 'R$50,00', 1),
	   ('Mecanico intermediário', 'R$400,00', 2),
       ('Funileiro automotivo', 'R$600,00', 3);
          
       
desc Pecas_has_ordemdeservico;
-- Pecas_idPecas, OrdemDeServico_idOrdemDeServico, Quantidade
insert into Pecas_has_ordemdeservico (Pecas_idPecas, OrdemDeServico_idOrdemDeServico)
values (1, 1),
	   (2, 2),
       (3, 3);

desc Mecanico;
select*from equipe_de_servico;
-- idMecanico, Area_Especializacao, Nome, Endereco, Codigo
insert into Mecanico (idMecanico, Area_Especializacao, Nome, Endereco, Codigo)
values (1, 'Manutenção de veículos leves e pesados', 'Julia Robs', 'Rua Laranjeiras 85, Centro - Cidade das Flores', '1256'),
       (2, 'Transmissão e Manutenção', 'Paulo Borges', 'Avenida Campos Lemos 9965, Centro - Itajaí', '1325'),
       (3, 'Funileiro automotivo', 'Marta Viera', 'Rua Dr. Laerte 35, Pequis - UberLandia', '3256');
       
       
desc veiculo_has_servico;
-- Veiculo_idVeiculo, Servico_idServico, Servico_OrdemDeServico_idOrdemDeServico
insert into veiculo_has_servico (Veiculo_idVeiculo, Servico_idServico, Servico_OrdemDeServico_idOrdemDeServico)
values (1, 1, 1),
	   (2, 2, 2),
       (3, 3, 3);


desc MaoDeObra_has_Mecanico;
select * from mecanico;
-- MaodeObra_idMaoDeObra, MaodeObra_Equipe_de_Servico_idMecanico, Mecanico_idMecanico
insert into MaoDeObra_has_Mecanico ( MaodeObra_idMaoDeObra, MaodeObra_Equipe_de_Servico_idMecanico, Mecanico_idMecanico)
values (1, 1, 1),
	   (2, 2, 2),
       (3, 3, 3);


-- *******************************************************
-- INSERÇÃO DE QUERIES
-- *******************************************************

select count(*) from Cliente; -- Contando quantos clientes tem registrado

select * from cadastro;

desc mecanico;

select * from Cliente c, cadastro d where c.idCliente = d.cliente_idCliente order by Nome; -- Somente os Clientes e seus dados 

select * from pecas where valor>=500; -- Valores de peças e materiais para os serviços maiores que R$500,00

select idMecanico, nome, area_especializacao from mecanico order by Nome; -- Mecanicos e suas especializações

select Nome , cliente_idCliente as "Identificação", count(*) as 'Quantidade de Ordem de Serviços' -- Quantidade de ordens de pedidos em aberto por cada cliente
	from Cadastro, OrdemdeServico 
    where cliente_idCliente = idOrdemDeServico
    group by cliente_idCliente;
    
select concat(Categoria,' | ', modelo) as "Veículo" from veiculo; -- Relação de veículos concatenado com o modelo

select * from pecas -- relação das peças e materiais para o serviço, mostrando os mecânicos responsáveis ordenador pelo número da OS
inner join OrdemdeServico on idpecas = idOrdemdeservico 
inner join mecanico on idmecanico = Equipe_de_Servico_idEquipe
order by Número_OS;

show tables;

SELECT Nome, especificacoes_veiculo, autoriza_servicos FROM Cadastro, Cliente  -- Clientes que sutorizaram o inicio do serviço
	WHERE idCliente = Cliente_idCliente
		HAVING Autoriza_Servicos like "%SIM%" 
			ORDER BY Nome ASC;
            







