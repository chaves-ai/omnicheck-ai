-- ============================================================
-- OmniCheck AI — Schema do Banco de Dados
-- Versão: 1.0
-- Setor: Grande Varejo
-- Descrição: Schema base para o agente analítico OmniCheck AI
--            com suporte a perguntas de negócio em linguagem natural.
-- ============================================================


-- ------------------------------------------------------------
-- TABELA: clientes
-- Descrição: Armazena os dados dos clientes da rede de varejo.
-- Usada para segmentação por perfil, região e comportamento.
-- ------------------------------------------------------------
CREATE TABLE clientes (
    id_cliente      INTEGER PRIMARY KEY,
    nome            VARCHAR(100),
    data_nascimento DATE,           -- Idade calculada na query, nunca armazenada
    sexo            VARCHAR(1),     -- M ou F
    cidade          VARCHAR(100),
    estado          VARCHAR(2)      -- Sigla: SP, RJ, MG...
);


-- ------------------------------------------------------------
-- TABELA: produtos
-- Descrição: Catálogo de produtos disponíveis na rede.
-- Usada para análise de margem, categoria e movimentação.
-- ------------------------------------------------------------
CREATE TABLE produtos (
    id_produto      INTEGER PRIMARY KEY,
    nome            VARCHAR(100),
    categoria       VARCHAR(50),
    tipo            VARCHAR(50),
    preco_custo     DECIMAL(10,2),  -- Valor pago ao fornecedor
    preco_venda     DECIMAL(10,2),  -- Valor cobrado do cliente
    unidade_medida  VARCHAR(10)     -- UN, KG, LT, CX, PCT...
);


-- ------------------------------------------------------------
-- TABELA: lojas
-- Descrição: Unidades físicas e digitais da rede de varejo.
-- Usada para análise de desempenho por unidade e região.
-- ------------------------------------------------------------
CREATE TABLE lojas (
    id_loja          INTEGER PRIMARY KEY,
    nome             VARCHAR(100),
    cidade           VARCHAR(100),
    estado           VARCHAR(2),
    tipo             VARCHAR(100),  -- Loja Física, E-commerce, Centro de Distribuição
    metros_quadrados INT
);


-- ------------------------------------------------------------
-- TABELA: vendas
-- Descrição: Cabeçalho do evento de compra.
-- Registra quem comprou, onde, quando e por qual canal.
-- Não armazena produtos — isso é responsabilidade de itens_venda.
-- ------------------------------------------------------------
CREATE TABLE vendas (
    id_venda     INTEGER PRIMARY KEY,
    id_cliente   INTEGER REFERENCES clientes(id_cliente),
    id_loja      INTEGER REFERENCES lojas(id_loja),
    data_hora    TIMESTAMP,
    canal_venda  VARCHAR(100),  -- Loja Física, E-commerce, App
    status_venda VARCHAR(100)   -- Concluída, Cancelada, Devolvida
);


-- ------------------------------------------------------------
-- TABELA: itens_venda
-- Descrição: Detalhe dos produtos em cada venda.
-- Uma linha por produto dentro da compra.
-- Conecta vendas e produtos.
-- ------------------------------------------------------------
CREATE TABLE itens_venda (
    id_item        INTEGER PRIMARY KEY,
    id_venda       INTEGER REFERENCES vendas(id_venda),
    id_produto     INTEGER REFERENCES produtos(id_produto),
    quantidade     INT,
    preco_unitario DECIMAL(10,2)  -- Preço no momento da compra
);


-- ------------------------------------------------------------
-- TABELA: entregas
-- Descrição: Registro logístico de cada venda.
-- Usada para análise de prazo, status e cobertura geográfica.
-- ------------------------------------------------------------
CREATE TABLE entregas (
    id_entrega     INTEGER PRIMARY KEY,
    id_venda       INTEGER REFERENCES vendas(id_venda),
    endereco       VARCHAR(255),
    cidade         VARCHAR(100),
    estado         VARCHAR(2),
    status_entrega VARCHAR(50),   -- Em Trânsito, Entregue, Atrasado, Devolvido
    data_envio     DATE,          -- Data de saída do armazém
    data_entrega   DATE           -- Data de chegada ao cliente
);
