# QGIS Desktop con qgis_process (Docker Hub, público)
FROM qgis/qgis:release-3.34

# Paquetes mínimos para ejecutar procesos y API
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip fonts-dejavu fonts-liberation tini && \
    rm -rf /var/lib/apt/lists/*

# API FastAPI para invocar qgis_process
WORKDIR /app
COPY app.py /app/app.py
COPY proyecto.qgz /app/proyecto.qgz

RUN pip3 install fastapi uvicorn[standard]

# Carpeta de salida
RUN mkdir -p /app/out

# Puerto web
ENV PORT=8000
EXPOSE 8000

# Arranque
ENTRYPOINT ["/usr/bin/tini","--"]
CMD ["uvicorn","app:api","--host","0.0.0.0","--port","8000"]
