--FERNANDO_CAMIRAN

--CRIAR TABELAS

CREATE TABLE TB_MUNICIPIO (
  MUN_ID INT PRIMARY KEY,
  MUN_DESCRICAO VARCHAR2(100) NOT NULL
);

CREATE TABLE TB_BAIRRO (
  BAI_ID INT PRIMARY KEY,
  BAI_DESCRICAO VARCHAR2(100) NOT NULL,
  MUN_ID INT,
  FOREIGN KEY (MUN_ID) REFERENCES TB_MUNICIPIO(MUN_ID)
);

CREATE TABLE TB_ENDERECO(
  END_ID INT PRIMARY KEY,
  END_DESCRICAO VARCHAR2(100) NOT NULL,
  BAI_ID INT,
  FOREIGN KEY (BAI_ID) REFERENCES TB_BAIRRO(BAI_ID)
);

CREATE TABLE TB_CLIENTE (
  CLI_ID INT PRIMARY KEY,
  CLI_NOME VARCHAR2(100) NOT NULL,
  CLI_CPF VARCHAR2(14) UNIQUE NOT NULL,
  CLI_RG VARCHAR2(20),
  CLI_TELEFONE VARCHAR2(13),
  CLI_DT_NASCIMENTO DATE,
  CLI_END_ID INT,
  FOREIGN KEY (CLI_END_ID) REFERENCES TB_ENDERECO(END_ID)
);

CREATE TABLE TB_FUNCIONARIO (
  FUN_ID INT PRIMARY KEY,
  FUN_NOME VARCHAR2(100) NOT NULL,
  FUN_CPF VARCHAR2(14) UNIQUE NOT NULL,
  FUN_RG VARCHAR2(20),
  FUN_TELEFONE VARCHAR2(13),
  FUN_SALARIO NUMBER(7,2), 
  FUN_END_ID INT,
  FOREIGN KEY (FUN_END_ID) REFERENCES TB_ENDERECO(END_ID)
);

CREATE TABLE TB_GENERO(
  GEN_ID INT PRIMARY KEY,
  GEN_DESCRICAO VARCHAR2(100) NOT NULL
);

CREATE TABLE TB_FILME(
  FIL_ID INT PRIMARY KEY,
  FIL_CODGENERO INT,
  FIL_NOME VARCHAR2(100) NOT NULL,
  FIL_TEMP NUMBER(3) NOT NULL, --DURACAO TOTAL DO FILME
  FIL_QUANT INT NOT NULL,
  FOREIGN KEY (FIL_CODGENERO) REFERENCES TB_GENERO(GEN_ID)
);

CREATE TABLE TB_VENDA(
  VEND_ID INT PRIMARY KEY,
  VEND_DATA DATE NOT NULL,
  VEND_VALOR NUMBER(10,2) NOT NULL,
  VEND_CLI_ID INT,
  VEND_FUN_ID INT,
  FOREIGN KEY (VEND_CLI_ID) REFERENCES TB_CLIENTE(CLI_ID),
  FOREIGN KEY (VEND_FUN_ID) REFERENCES TB_FUNCIONARIO(FUN_ID)
);

CREATE TABLE TB_VENDA_FILME(
  VEND_ID INT,
  FIL_ID INT, 
  VF_VALOR NUMBER(10,2),
  FOREIGN KEY (VEND_ID) REFERENCES TB_VENDA(VEND_ID),
  FOREIGN KEY (FIL_ID) REFERENCES TB_FILME(FIL_ID)
);