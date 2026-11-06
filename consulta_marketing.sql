USE MarketingAlimentos;
GO


            /* gasto, faturamento, ROI, CTR e CPC */
WITH Gastos AS (
    SELECT campanha_id,
           SUM(gasto)      AS gasto_total,
           SUM(cliques)    AS total_cliques,
           SUM(impressoes) AS total_impressoes
    FROM ResultadosCampanha
    GROUP BY campanha_id
),
Faturamento AS (
    SELECT p.campanha_id,
           SUM(i.quantidade * i.preco_unitario) AS faturamento
    FROM Pedidos p
    JOIN ItensPedido i ON i.pedido_id = p.pedido_id
    WHERE p.status = 'Entregue'
      AND p.campanha_id IS NOT NULL
    GROUP BY p.campanha_id
)
SELECT c.campanha_id,
       c.nome,
       c.orcamento,
       g.gasto_total,
       ISNULL(f.faturamento, 0)                                    AS faturamento,
       ROUND((ISNULL(f.faturamento, 0) - g.gasto_total)
             / NULLIF(g.gasto_total, 0), 2)                        AS ROI,
       ROUND(CAST(g.total_cliques AS FLOAT)
             / NULLIF(g.total_impressoes, 0) * 100, 2)             AS CTR_percentual,
       ROUND(g.gasto_total / NULLIF(g.total_cliques, 0), 2)        AS CPC
FROM Campanhas c
JOIN Gastos g           ON g.campanha_id = c.campanha_id
LEFT JOIN Faturamento f ON f.campanha_id = c.campanha_id
ORDER BY ROI DESC;
GO


            /*  orçamento planejado - gasto real */
WITH GastosPorCampanha AS (
    SELECT campanha_id, SUM(gasto) AS gasto_total
    FROM ResultadosCampanha
    GROUP BY campanha_id
)
SELECT c.nome,
       c.orcamento,
       g.gasto_total,
       c.orcamento - g.gasto_total AS saldo_orcamento
FROM Campanhas c
JOIN GastosPorCampanha g ON c.campanha_id = g.campanha_id
ORDER BY saldo_orcamento DESC;
GO


            /*resumo por campanha*/
CREATE OR ALTER VIEW vw_ResumoCampanhas AS
WITH Gastos AS (
    SELECT campanha_id,
           SUM(gasto)      AS gasto_total,
           SUM(cliques)    AS total_cliques,
           SUM(impressoes) AS total_impressoes
    FROM ResultadosCampanha
    GROUP BY campanha_id
),
Faturamento AS (
    SELECT p.campanha_id,
           SUM(i.quantidade * i.preco_unitario) AS faturamento
    FROM Pedidos p
    JOIN ItensPedido i ON i.pedido_id = p.pedido_id
    WHERE p.status = 'Entregue'
      AND p.campanha_id IS NOT NULL
    GROUP BY p.campanha_id
)
SELECT c.campanha_id,
       c.nome                                                     AS campanha,
       ca.nome                                                    AS canal,
       c.data_inicio,
       c.data_fim,
       c.orcamento,
       g.gasto_total,
       c.orcamento - g.gasto_total                                AS saldo_orcamento,
       g.total_impressoes,
       g.total_cliques,
       ISNULL(f.faturamento, 0)                                   AS faturamento,
       (ISNULL(f.faturamento, 0) - g.gasto_total)
           / NULLIF(g.gasto_total, 0)                             AS ROI,
       CAST(g.total_cliques AS FLOAT)
           / NULLIF(g.total_impressoes, 0)                        AS CTR,
       g.gasto_total / NULLIF(g.total_cliques, 0)                 AS CPC
FROM Campanhas c
JOIN Canais ca          ON ca.canal_id = c.canal_id
JOIN Gastos g           ON g.campanha_id = c.campanha_id
LEFT JOIN Faturamento f ON f.campanha_id = c.campanha_id;
GO


            /*vendas detalhadas*/
CREATE OR ALTER VIEW vw_VendasDetalhadas AS
SELECT p.pedido_id,
       p.data_pedido,
       p.status,
       cl.cliente_id,
       cl.nome                          AS cliente,
       cl.cidade,
       cl.estado,
       can.nome                         AS canal_aquisicao,
       ca.nome                          AS campanha,
       cat.nome                         AS categoria,
       pr.nome                          AS produto,
       i.quantidade,
       i.preco_unitario,
       i.quantidade * i.preco_unitario  AS valor_total,
       i.quantidade * pr.custo          AS custo_total
FROM Pedidos p
JOIN Clientes cl       ON cl.cliente_id = p.cliente_id
JOIN Canais can        ON can.canal_id = cl.canal_aquisicao_id
JOIN ItensPedido i     ON i.pedido_id = p.pedido_id
JOIN Produtos pr       ON pr.produto_id = i.produto_id
JOIN Categorias cat    ON cat.categoria_id = pr.categoria_id
LEFT JOIN Campanhas ca ON ca.campanha_id = p.campanha_id;
GO

            /*FIM*/
SELECT * FROM vw_ResumoCampanhas ORDER BY faturamento DESC;
SELECT TOP 10 * FROM vw_VendasDetalhadas;
GO

