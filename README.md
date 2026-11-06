# Análise de Marketing de uma Empresa de Alimentos

Projeto de ponta a ponta que fiz para praticar SQL e Power BI: carreguei o banco
no SQL Server, escrevi as análises e construí um relatório de 4 páginas para
responder uma pergunta simples: **quais campanhas de marketing realmente deram retorno?**

> **Sobre os dados:** a base é fictícia e foi gerada com a ajuda de uma IA (Claude),
> que criou a base simulada. Executei o banco no SQL Server,
> fiz as consultas, montei o relatório no Power BI e conferi os resultados.

## O que eu quis descobrir
- Quais campanhas e canais têm o melhor e o pior ROI?
- Quais categorias, produtos e clientes mais faturam?
- Como estão a margem e a taxa de cancelamento?

## Como fiz
1. **Banco de dados:** carreguei no SQL Server 8 tabelas (categorias, produtos, canais, campanhas, clientes, pedidos, itens e resultados das campanhas).
2. **Análises em SQL:** usei CTEs e JOINs para calcular gasto, faturamento, ROI, CTR e CPC por campanha, e criei duas views para alimentar o Power BI.
3. **Power BI:** importei as views, criei as medidas em DAX e montei o relatório.

Regras que usei: o faturamento conta só pedidos entregues e o ROI é
(faturamento − gasto) ÷ gasto.

## O que encontrei
- ROI geral de **60,25%** sobre R$ 29,62 mil investidos.
- Melhor campanha: **Inverno Iogurte**, com ROI de 198,33%. Pior: **Black Friday Alimentos**, com −71,14%.
- Influenciadores é o canal que mais devolve por real investido.
- Bebidas e Laticínios lideram o faturamento, mas têm as menores margens.
- Margem média de 47,20% e taxa de cancelamento de 6,28%.

## O relatório
![Visão geral](Captura%20de%20tela%202026-11-05%20204835.png)
![Campanhas e canais](Captura%20de%20tela%202026-11-05%20204949.png)
![Produtos e clientes](Captura%20de%20tela%202026-11-05%20205027.png)

📄 [Leia o case completo](Case%20do%20portfolio%20%28analise%20de%20marketing%29.pdf)

## Arquivos
- `marketing_alimentos.sql`: cria o banco, as tabelas e os dados.
- `consulta_marketing.sql`: consultas de análise e as views para o Power BI.
- `relatório_de_marketing 01.pbix`: o relatório em Power BI.

## Como reproduzir
1. Rode `marketing_alimentos.sql` no SQL Server (SSMS).
2. Rode `consulta_marketing.sql` para criar as views.
3. Abra o `.pbix` no Power BI Desktop e aponte a fonte de dados para o seu servidor.

## Ferramentas
SQL Server · SSMS · Power BI · DAX

## Contato
Wesley · [LinkedIn]https://www.linkedin.com/in/wesley-silva-b37145218/ · wesleyalex103@gmail.com
