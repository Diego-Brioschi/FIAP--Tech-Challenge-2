# FIAP - Tech Challenge Fase 2

**Projeto 1 | Otimizacao de modelos de diagnostico por algoritmos geneticos + LLM + escalabilidade**

Autor: **Diego Brioschi Silva**  
Pos-graduacao: **IA for Devs - FIAP**

## 1. Escopo e independencia da Fase 1

Base: Breast Cancer Wisconsin Diagnostic (569 observacoes; 30 caracteristicas
morfologicas citologicas; alvo `diagnostico_maligno`, 1=maligno e 0=benigno).
Dados originarios do [UCI Machine Learning Repository](https://archive.ics.uci.edu/dataset/17/breast+cancer+wisconsin+diagnostic).

## 2. Requisitos e o que foi feito

| Exigencia do PDF | Onde demonstrar |
|---|---|
| Codificacao dos genes e fitness | `fase2/models.py`, `fase2/evaluation.py` |
| Selecao, crossover, mutacao, elitismo | `fase2/ga.py` |
| Tres configuracoes diferentes de GA | `CONFIGURACOES` em `fase2/ga.py` |
| Comparativo antes vs depois | `data/processed/comparacao_modelos.csv`; grafico |
| Logging/monitoramento | `fase2/tracking.py`; API `/status` e `/metrics` |
| Recursos de autoescalabilidade | `fase2/autoscale.py`; `scripts/demo_autoscaling.py` |
| LLM + prompt engineering | `fase2/llm.py`; API `/interpret` |
| Avaliacao de qualidade LLM | `scripts/demo_llm.py`; `docs/AVALIACAO_LLM.md` |
| Arquitetura/documentacao | `docs/ARQUITETURA.md`, `docs/API.md` |
| Testes automatizados | pasta `tests/`, `pytest` |
| Video de ate 15 minutos | `docs/ROTEIRO_VIDEO.md` |
| Relatorio tecnico | `reports/Relatorio_Tecnico_Fase2_Diego_Brioschi.docx` |

## 3. Como executar o projeto

Extraia o ZIP em outra pasta

No Terminal do PyCharm (PowerShell):

```powershell
python --version
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
python -m pytest -q
```

Abra `main.py`, clique com o botao direito e selecione **Run main**. Ele roda todos os 12 experimentos. Para abrir a API, apos o treino, execute `iniciar_api.py` da mesma forma.

## 4. O que sai depois do treinamento

| Arquivo | Finalidade |
|---|---|
| `data/processed/tres_experimentos_ga.csv` | 3 configuracoes por modelo; parametros, fitness, tempo |
| `data/processed/historico_fitness.csv` | Melhor fitness por geracao |
| `data/processed/comparacao_modelos.csv` | Matriz de resultados originais/otimizados no holdout |
| `reports/figures/fitness_*.png` | Evolucao de fitness (1 imagem/modelo) |
| `reports/figures/comparacao_recall_baseline_vs_ga.png` | Comparacao do recall no teste |
| `models/*_baseline_fase1.joblib` | Baselines reproduzidos |
| `models/*_otimizado_ga.joblib` | Modelos com hiperparametros GA |
| `models/modelo_ga_demo.joblib` | Modelo escolhido por MELHOR FITNESS CV, para API |
| `models/metadata.json` | Parametros, fitness, modelos e controle de reproducibilidade |
| `reports/resultados_experimentos.md` | Sintese gerada automaticamente |

## 5. Demonstração de escalabilidade automatica

```powershell
python -m scripts.demo_autoscaling
```

O exemplo injeta tarefas com tempo artificial **apenas na simulacao** para
visualizar crescimento e reducao de workers. Salva:

- `reports/figures/autoscaling_workers_fila.png`
- `data/processed/evidencia_autoscaling.csv`

A API real recebe tarefas por uma fila e aumenta ou reduz o numero de workers
locais conforme a demanda, mantendo limites min/max configuraveis.

## 6. API interativa + monitoramento

Depois de treinar:

```powershell
python -m scripts.example_request
python -m uvicorn fase2.api:app --host 127.0.0.1 --port 8000
```

Abra **http://127.0.0.1:8000/docs** (Swagger). Use o arquivo
`data/processed/exemplo_request.json` no endpoint `POST /predict`.
Para consultar o status, `GET /status`; para metricas Prometheus, `GET /metrics`.
Rotas detalhadas em `docs/API.md`.

## 7. Integração com LLM real (Utilizei OpenAI)

Reinicie o `uvicorn`. No Swagger, use `POST /interpret` com o mesmo JSON de
`POST /predict`. O endpoint executa primeiro a previsao deterministica e pede a LLM.

Avaliacao REAL, com quatro amostras anonimizadas:

```powershell
python -m scripts.demo_llm --provider openai
```

Para demonstrar o fluxo:

```powershell
python -m scripts.demo_llm --provider example
```

## 8. Testes

```powershell
python -m pytest -q
```

Testes: GA deterministico, operadores e limites, split, CV, inferencia API,
validacao da entrada, endpoints, verificacoes de segurança da LLM e scaling.

## 9. Documentos

- `docs/ARQUITETURA.md`: fluxo e diagrama Mermaid.
- `docs/API.md`: endpoints e exemplos PowerShell.
- `docs/AVALIACAO_LLM.md`: engenharia de prompt e rubrica de avaliacao.
- `docs/ROTEIRO_VIDEO.md`: roteiro de 10 a 13 minutos.
- `docs/CHECKLIST_ENTREGA.md`: o que enviar e o que ainda depende do autor.
- `reports/Relatorio_Tecnico_Fase2_Diego_Brioschi.docx`: relatorio editavel.

## 10. Fonte e referencias

- UCI ML Repository: [Breast Cancer Wisconsin (Diagnostic)](https://archive.ics.uci.edu/dataset/17/breast+cancer+wisconsin+diagnostic)
- Scikit-learn: https://scikit-learn.org/stable/
- DEAP nao utilizado: os operadores geneticos foram implementados neste projeto.
- OpenAI: https://platform.openai.com/docs/api-reference/responses
- FastAPI: https://fastapi.tiangolo.com/
- Prometheus Python client: https://prometheus.github.io/client_python/