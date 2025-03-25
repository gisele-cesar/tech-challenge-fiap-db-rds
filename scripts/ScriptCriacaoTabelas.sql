USE [master]; 
GO 

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'PosTechFiap')
  CREATE DATABASE PosTechFiap;
GO

USE PosTechFiap;
GO

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Pedido')
	DROP TABLE Pedido;
GO 
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'StatusPedido')
	DROP TABLE StatusPedido;
GO 
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Produto')
	DROP TABLE Produto;
GO 
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'CategoriaProduto')
	DROP TABLE CategoriaProduto;
GO 
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ItemPedido')
	DROP TABLE ItemPedido;
GO 
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Cliente')
	DROP TABLE Cliente;
GO 

CREATE TABLE Cliente (
        IdCliente INT IDENTITY PRIMARY KEY,
        Nome VARCHAR(255) NOT NULL,
        Cpf VARCHAR(11) NOT NULL,
        Email VARCHAR(255) NOT NULL,
        DataCriacao DATETIME NOT NULL
);

CREATE TABLE CategoriaProduto (
        IdCategoriaProduto INT IDENTITY PRIMARY KEY,
        Nome VARCHAR(255) NOT NULL,
        DataCriacao DATETIME NOT NULL
    );

CREATE TABLE Produto (
        IdProduto INT IDENTITY PRIMARY KEY,
        IdCategoriaProduto INT,
        Nome VARCHAR(255) NOT NULL,
        Descricao VARCHAR(255) NOT NULL,
        Preco DECIMAL(18,2) NOT NULL,
        DataCriacao DATETIME NOT NULL,
        DataAlteracao DATETIME NULL,
        CONSTRAINT FK_CategoriaProduto FOREIGN KEY (IdCategoriaProduto) REFERENCES CategoriaProduto(IdCategoriaProduto)
    );

    CREATE TABLE StatusPagamento (
        IdStatusPagamento INT IDENTITY PRIMARY KEY,
        Descricao VARCHAR(50) NOT NULL
    )


    CREATE TABLE StatusPedido (
        IdStatusPedido INT IDENTITY PRIMARY KEY,
        Descricao VARCHAR(50) NOT NULL
    )


    CREATE TABLE Pedido (
        IdPedido INT IDENTITY PRIMARY KEY,
        IdCliente INT NOT NULL,
        NumeroPedido VARCHAR(255) NOT NULL,
        IdStatusPedido INT NOT NULL,
        ValorTotalPedido DECIMAL(18,2) NOT NULL,
        DataCriacao DATETIME NOT NULL,
        DataAlteracao DATETIME NULL,
        IdStatusPagamento INT NOT NULL,
        CONSTRAINT FK_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente),
        CONSTRAINT FK_StatusPedido FOREIGN KEY (IdStatusPedido) REFERENCES StatusPedido(IdStatusPedido),
        CONSTRAINT FK_StatusPagamento FOREIGN KEY (IdStatusPagamento) REFERENCES StatusPagamento(IdStatusPagamento)
    );


    CREATE TABLE ItemPedido (
        IdPedido INT NOT NULL,
        IdProduto INT NOT NULL
    );

go
CREATE INDEX idx_cliente_cpf ON Cliente (Cpf);
go

INSERT INTO CategoriaProduto(Nome, DataCriacao)
VALUES ('Lanche', getdate()), 
	   ('Acompanhamento', getdate()), 
	   ('Bebida', getdate()), 
	   ('Sobremesa', getdate());

INSERT INTO StatusPagamento(Descricao)
VALUES ('Pendente'), 
	   ('Aprovado'), 
	   ('Recusado');

INSERT INTO StatusPedido(Descricao)
VALUES ('Solicitado'), 
	   ('Recebido'), 
	   ('Em prepara��o'), 
	   ('Pronto'), 
	   ('Finalizado');