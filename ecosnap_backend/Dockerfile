FROM python:3.13.1

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

RUN pip install torch torchvision pillow transformers

COPY . .

COPY ./cached_models /root/.cache/huggingface/transformers

CMD ["gunicorn", "ecosnap_backend.wsgi:application", "--bind", "0.0.0.0:8000"]

