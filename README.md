# Projeto de Infraestrutura de Banco de Dados RDS com Terraform

## Visão Geral

Este projeto utiliza Terraform para provisionar uma instância de banco de dados RDS SQL Server na AWS. A infraestrutura inclui a criação de sub-redes, grupos de segurança e a execução de scripts SQL para a criação de tabelas.

## Estrutura do Banco de Dados

### SQL Server

O SQL Server foi escolhido como o banco de dados para este projeto devido às seguintes razões:

1. **Compatibilidade**: SQL Server é amplamente utilizado em ambientes corporativos e é compatível com diversas ferramentas de BI e análise de dados.
2. **Recursos Avançados**: SQL Server oferece recursos avançados como suporte a transações, segurança robusta, e ferramentas de gerenciamento integradas.
3. **Escalabilidade**: SQL Server pode ser facilmente escalado para atender a demandas crescentes de dados e usuários.
4. **Integração com AWS**: A integração do SQL Server com o AWS RDS facilita a gestão e manutenção do banco de dados, permitindo backups automáticos, atualizações de software e alta disponibilidade.

## Estrutura do Repositório

- `infra/terraform/main.tf`: Arquivo principal do Terraform para provisionamento da infraestrutura.
- `infra/terraform/variables.tf`: Definição das variáveis utilizadas no Terraform.
- `scripts/ScriptCriacaoTabelas.sql`: Script SQL para a criação das tabelas no banco de dados.
- `.github/workflows/deploy.yml`: Arquivo de configuração do GitHub Actions para automação do deploy.

## Como Executar

1. Clone o repositório:
   ```sh
   git clone https://github.com/gisele-cesar/tech-challenge-fiap-db-rds.git
   cd https://github.com/gisele-cesar/tech-challenge-fiap-db-rds.git

2. Configure as variáveis de ambiente no GitHub Actions:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `DB_PASSWORD`

3. Faça o push das alterações para a branch `develop` para acionar o workflow do GitHub Actions.

### Tabelas

O banco de dados contém as seguintes tabelas:

1. **Cliente**
   - `IdCliente` (INT, IDENTITY, PRIMARY KEY): Identificador único para cada cliente.
   - `Nome` (VARCHAR(255), NOT NULL): Nome do cliente.
   - `Cpf` (VARCHAR(11), NOT NULL): CPF do cliente.
   - `Email` (VARCHAR(255), NOT NULL): Email do cliente.
   - `DataCriacao` (DATETIME, NOT NULL): Data de criação do registro.

2. **CategoriaProduto**
   - `IdCategoriaProduto` (INT, IDENTITY, PRIMARY KEY): Identificador único para cada categoria de produto.
   - `Nome` (VARCHAR(255), NOT NULL): Nome da categoria de produto.
   - `DataCriacao` (DATETIME, NOT NULL): Data de criação do registro.

3. **Produto**
   - `IdProduto` (INT, IDENTITY, PRIMARY KEY): Identificador único para cada produto.
   - `IdCategoriaProduto` (INT): Identificador da categoria do produto.
   - `Nome` (VARCHAR(255), NOT NULL): Nome do produto.
   - `Descricao` (VARCHAR(255), NOT NULL): Descrição do produto.
   - `Preco` (DECIMAL(18,2), NOT NULL): Preço do produto.
   - `DataCriacao` (DATETIME, NOT NULL): Data de criação do registro.
   - `DataAlteracao` (DATETIME, NULL): Data de alteração do registro.
   - `CONSTRAINT FK_CategoriaProduto FOREIGN KEY (IdCategoriaProduto) REFERENCES CategoriaProduto(IdCategoriaProduto)`: Chave estrangeira para a tabela CategoriaProduto.

4. **StatusPagamento**
   - `IdStatusPagamento` (INT, IDENTITY, PRIMARY KEY): Identificador único para cada status de pagamento.
   - `Descricao` (VARCHAR(50), NOT NULL): Descrição do status de pagamento.

5. **StatusPedido**
   - `IdStatusPedido` (INT, IDENTITY, PRIMARY KEY): Identificador único para cada status de pedido.
   - `Descricao` (VARCHAR(50), NOT NULL): Descrição do status de pedido.

6. **Pedido**
   - `IdPedido` (INT, IDENTITY, PRIMARY KEY): Identificador único para cada pedido.
   - `IdCliente` (INT, NOT NULL): Identificador do cliente.
   - `NumeroPedido` (VARCHAR(255), NOT NULL): Número do pedido.
   - `IdStatusPedido` (INT, NOT NULL): Identificador do status do pedido.
   - `ValorTotalPedido` (DECIMAL(18,2), NOT NULL): Valor total do pedido.
   - `DataCriacao` (DATETIME, NOT NULL): Data de criação do pedido.
   - `DataAlteracao` (DATETIME, NULL): Data de alteração do pedido.
   - `IdStatusPagamento` (INT, NOT NULL): Identificador do status de pagamento.
   - `CONSTRAINT FK_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente)`: Chave estrangeira para a tabela Cliente.
   - `CONSTRAINT FK_StatusPedido FOREIGN KEY (IdStatusPedido) REFERENCES StatusPedido(IdStatusPedido)`: Chave estrangeira para a tabela StatusPedido.
   - `CONSTRAINT FK_StatusPagamento FOREIGN KEY (IdStatusPagamento) REFERENCES StatusPagamento(IdStatusPagamento)`: Chave estrangeira para a tabela StatusPagamento.

7. **ItemPedido**
   - `IdPedido` (INT, NOT NULL): Identificador do pedido.
   - `IdProduto` (INT, NOT NULL): Identificador do produto.

### Índices

- `idx_cliente_cpf`: Índice na tabela Cliente para o campo CPF.

### Dados de Exemplo

- **CategoriaProduto**
  - `Lanche`
  - `Acompanhamento`
  - `Bebida`
  - `Sobremesa`

- **StatusPagamento**
  - `Pendente`
  - `Aprovado`
  - `Recusado`

- **StatusPedido**
  - `Solicitado`
  - `Recebido`
  - `Em preparação`
  - `Pronto`
  - `Finalizado`

### Script de Criação de Tabelas

O script SQL para a criação das tabelas está localizado no arquivo `scripts/ScriptCriacaoTabelas.sql` e é executado logo após a criação da instância RDS.

## Modelagem de Dados

A modelagem de dados foi projetada para ser simples e eficiente, atendendo aos requisitos básicos do projeto. As tabelas foram criadas para armazenar informações de clientes, produtos, pedidos e seus respectivos status. Esta estrutura pode ser facilmente expandida conforme necessário para incluir mais tabelas e relacionamentos.
