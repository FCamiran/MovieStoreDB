--FERNANDO_CAMIRAN

--PROCEDURE

-- CADASTRAR CLIENTE
  CREATE OR REPLACE PROCEDURE SP_CADASTRAR_CLIENTE
                    (P_NOME  IN TB_CLIENTE.CLI_NOME%TYPE, 
                    P_CPF IN TB_CLIENTE.CLI_CPF%TYPE, 
                    P_RG IN TB_CLIENTE.CLI_CPF%TYPE,
                    P_TELEFONE IN TB_CLIENTE.CLI_TELEFONE%TYPE,
                    P_DT_NASCIMENTO IN TB_CLIENTE.CLI_DT_NASCIMENTO%TYPE, 
                    P_MUNICIPIO IN TB_MUNICIPIO.MUN_DESCRICAO%TYPE, 
                    P_BAIRRO IN TB_BAIRRO.BAI_DESCRICAO%TYPE, 
                    P_ENDERECO IN TB_ENDERECO.END_DESCRICAO%TYPE)
  IS 
    V_MUN_ID TB_MUNICIPIO.MUN_ID%TYPE;
    V_BAI_ID TB_BAIRRO.BAI_ID%TYPE;
    V_END_ID TB_ENDERECO.END_ID%TYPE;
  BEGIN
      --VERIFICAR SE MUNICIPIO EXISTE
      BEGIN
          SELECT MUN_ID INTO V_MUN_ID
           FROM TB_MUNICIPIO
           WHERE MUN_DESCRICAO = P_MUNICIPIO;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO TB_MUNICIPIO (MUN_ID, MUN_DESCRICAO)
            VALUES(MUN_ID.NEXTVAL, P_MUNICIPIO)
            RETURNING MUN_ID INTO V_MUN_ID;
      END;
      
      --VERIFICAR SE BAIRRO EXISTE
      BEGIN
        SELECT BAI_ID INTO V_BAI_ID
        FROM TB_BAIRRO
        WHERE BAI_DESCRICAO = P_BAIRRO
          AND MUN_ID = V_MUN_ID;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO TB_BAIRRO (BAI_ID, BAI_DESCRICAO, MUN_ID)
            VALUES (BAI_ID.NEXTVAL, P_BAIRRO, V_MUN_ID)
            RETURNING BAI_ID INTO V_BAI_ID;
      END; 
      
      --VERIFICAR SE ENDERECO EXISTE
      BEGIN
        SELECT END_ID INTO V_END_ID
        FROM TB_ENDERECO
        WHERE END_DESCRICAO = P_ENDERECO
          AND BAI_ID = V_BAI_ID;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO TB_ENDERECO (END_ID, END_DESCRICAO, BAI_ID)
            VALUES (END_ID.NEXTVAL, P_ENDERECO, V_BAI_ID)
            RETURNING END_ID INTO V_END_ID;
      END;
      
      INSERT INTO TB_CLIENTE (
      CLI_ID, CLI_NOME, CLI_CPF, CLI_RG, CLI_TELEFONE, CLI_DT_NASCIMENTO, CLI_END_ID)
      VALUES ( CLI_ID.NEXTVAL, P_NOME, P_CPF, P_RG, P_TELEFONE, P_DT_NASCIMENTO, V_END_ID);
      
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Cliente cadastrado com sucesso!');
   EXCEPTION
      WHEN OTHERS THEN
          ROLLBACK; -- Reverter a transação em caso de erro
         DBMS_OUTPUT.PUT_LINE('Erro ao cadastrar cliente: ' || SQLERRM);
          RAISE;
  
  END;

--TESTE
  BEGIN
    SP_CADASTRAR_CLIENTE(
        P_NOME          => 'Rodolfo Camargo',
        P_CPF           => '1123141242',
        P_RG            => '88844447',
        P_TELEFONE      => '251234576',
        P_DT_NASCIMENTO => TO_DATE('1992-05-02', 'YYYY-MM-DD'),
        P_MUNICIPIO     => 'São Paulo',
        P_BAIRRO        => 'Centro',
        P_ENDERECO      => 'RUA BRASIL'
    );
  END;
  
--VISUALIZAÇÃO 
  SELECT * FROM TB_CLIENTE;

-- PROCEDURE ATUALIZAR SALARIO FUNCIONARIO

  CREATE OR REPLACE PROCEDURE SP_ATUALIZAR_SALARIO(
                                P_FUNCIONARIO_ID IN TB_FUNCIONARIO.FUN_ID%TYPE,
                                P_SALARIO IN TB_FUNCIONARIO.FUN_SALARIO%TYPE)
 IS BEGIN
          BEGIN
             UPDATE TB_FUNCIONARIO
             SET FUN_SALARIO = P_SALARIO
             WHERE FUN_ID = P_FUNCIONARIO_ID;
            
            
            
             IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Nenhum funcionário encontrado com o ID: ' || P_FUNCIONARIO_ID);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Salário do funcionário ID ' || P_FUNCIONARIO_ID || ' atualizado para ' || P_SALARIO);
        END IF;

        COMMIT; -- Confirma a transação
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK; -- Reverte a transação em caso de erro
            DBMS_OUTPUT.PUT_LINE('Erro ao atualizar salário: ' || SQLERRM);
            RAISE; -- Relança a exceção para notificar o chamador
    END;
  END;

--TESTE
  BEGIN
    SP_ATUALIZAR_SALARIO(
        P_FUNCIONARIO_ID => 1,         
        P_SALARIO => 5000.00     
    );
  END;
  
--VISUALIZAÇÃO 
    SELECT * FROM TB_FUNCIONARIO;
    
