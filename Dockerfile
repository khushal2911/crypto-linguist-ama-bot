FROM python:3.12-slim

WORKDIR /app

RUN pip install pipenv

COPY data/data.csv data/data.csv
COPY ["Pipfile", "Pipfile.lock", "./"]

RUN pipenv install --deploy --ignore-pipfile --system --dev

COPY crypto-linguist .

#EXPOSE 5000

#CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
EXPOSE 8501

CMD ["streamlit", "run", "app_ui.py"]