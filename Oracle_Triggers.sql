CREATE TABLE TB_PEDIDOS (ID NUMBER,
COD_PEDIDO NUMBER,
DATA_CRIACAO DATE,
DATA_ATUAL DATE,
STATUS VARCHAR2(10))

CREATE OR REPLACE TRIGGER trg_pedido
    BEFORE INSERT ON TB_PEDIDOS
    FOR EACH ROW

BEGIN 
--Atualiza o status do pedido para "Novo" após a inserção
    IF :NEW.STATUS IS NULL THEN
    :NEW.STATUS := 'Novo Pedido';
    END IF;
END;

INSERT INTO TB_PEDIDOS VALUES (
    1, 
    2255,
    SYSDATE,
    SYSDATE + 2,
    'PEDIDO NOVO'
);

SELECT * FROM tb_pedidos;

INSERT INTO tb_pedidos (
    id,
    cod_pedido,
    data_criacao,
    data_atual
)

VALUES (
    111,
    555,
    sysdate,
    sysdate + 8
);

ALTER TABLE tb_pedidos MODIFY STATUS VARCHAR2(30);

CREATE TABLE TB_AUDITORIA
(
    ID NUMBER GENERATED ALWAYS AS IDENTITY,
    TABELA VARCHAR2(30),
    OPERACAO VARCHAR2(30),
    DATA DATE,
    USUARIO VARCHAR2(30)
)
    
CREATE OR REPLACE TRIGGER trg_auditoria
    AFTER INSERT OR UPDATE OR DELETE ON tb_pedidos
    FOR EACH ROW
DECLARE
    OPERACAO VARCHAR2(30);
    NOME_USUARIO VARCHAR2(100);
    
BEGIN 
--Determina a operação realizada (Insert, Update, Delete)
    IF INSERTING THEN
        OPERACAO := 'INSERT';
    ELSIF UPDATING THEN
        OPERACAO:= 'UPDATE';
    ELSIF DELETING THEN
        OPERACAO := 'DELETE';
    END IF;

--Obtém o nome do usuário da sessão atual    
    NOME_USUARIO := SYS_CONTEXT('USERENV', 'SESSION_USER');
    
-- Registra a auditoria na tabela de auditoria
    INSERT INTO TB_AUDITORIA
        (TABELA, OPERACAO, DATA, USUARIO)
    VALUES
        ('PEDIDOS NOVOS', OPERACAO, SYSDATE, NOME_USUARIO);
        
END;

SELECT * FROM TB_AUDITORIA;

UPDATE tb_pedidos SET ID = 222 WHERE ID = 1;

DELETE FROM tb_pedidos;

