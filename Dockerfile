FROM python:3.12-slim
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    MPLBACKEND=Agg
WORKDIR /app
COPY requirements.txt .
RUN python -m pip install --no-cache-dir -r requirements.txt
COPY . /app
EXPOSE 8000
# Requer treinamento prévio (artefatos joblib em /app/models).
CMD ["python", "-m", "uvicorn", "fase2.api:app", "--host", "0.0.0.0", "--port", "8000"]
