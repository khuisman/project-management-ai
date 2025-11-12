FROM python:3.13-slim-bookworm

# Update container, install necessary dependencies
RUN apt-get update -y && apt-get install -y \
    build-essential \
    libevent-dev \
    curl

RUN pip install uv
RUN echo 'eval "$(uv generate-shell-completion bash)"' >> ~/.bashrc

RUN mkdir -p /serve
WORKDIR /serve
COPY ./uv.lock /serve/
COPY ./pyproject.toml /serve/
RUN uv sync

COPY . /serve/
COPY ./.env /serve/
#RUN uv run alembic upgrade head
ENTRYPOINT ["uv", "run", "python", "app.py"]

# loc-server
EXPOSE 3000
