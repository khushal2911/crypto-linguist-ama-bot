# Crypto Linguist Chatbot
This project was implemented for 
[LLM Zoomcamp](https://github.com/DataTalksClub/llm-zoomcamp) - a free course about LLMs and RAG.

## Overview
The Crypto Linguist Chatbot is a specialized chatbot designed to assist users in understanding the world of cryptocurrency and blockchain technology. This project is developed as part of the LLM-Zoomcamp course and aims to provide clear, concise explanations of key crypto-related terms through a carefully curated knowledge base generated with chatGPT.

## Usage
The chatbot responds to user questions based solely on terms available in its knowledge base. 
It can provide:
Definitions or Clarifications of crypto-related terms in the following categories
1. Cryptocurrency & Tokens
2. Blockchain Technology & Concepts
3. Wallets & Storage
4. Security & Attacks
5. Decentralized Finance (DeFi) & Protocols
6. Trading & Market Mechanics
7. Smart Contracts & Protocols
8. Metaverse & Gaming
9. Governance & Community
10. Miscellaneous & Emerging Technologies.

## Features
**Feedback Collection**: 
The chatbot collects and monitor positive and negative feedback from users on the answers it provides. This feedback will be used to improve the quality and accuracy of the chatbot's responses.

**Knowledge Base Updates**: 
The chatbot's knowledge base will be periodically updated based on feedback, with the goal of maximizing positive feedback and improving user satisfaction.

**Future Vision**:
This project aspires to evolve into a comprehensive crypto guru, continuously enhancing its understanding of the cryptocurrency landscape and becoming a trusted source of information for users.


## Dataset
Project dataset is generated using ChatGPT and has ~300 Terms related to crypto.

The dataset contains following columns.
- Terms: A curated collection of essential terms from the cryptocurrency and blockchain industry.
- Categories: The dataset is organized into ten categories to enhance clarity and user understanding.
- Descriptions: Each term is accompanied by a brief description that defines its meaning and context.

You can find the data in [`data/data.csv`](data/data.csv).

## Technologies

- Python 3.12
- Docker and Docker Compose for containerization
- [Minsearch](https://github.com/alexeygrigorev/minsearch) for full-text search
- Flask as the API interface (see [Background](#background) for more information on Flask)
- Grafana for monitoring and PostgreSQL as the backend for it
- OpenAI Models as an LLM

## Preparation

Since we use OpenAI, you need to provide the API key:

Because it is a fresh codespace instance, update apt and then install direnv. 
Also, Ensure YOUR_OPENAI_KEY is added (export KEY="!dfw#&") in .envrc file before running following commands.
```bash
sudo apt update 
sudo apt install direnv 
direnv bash hook >> ~/.bashrc
direnv allow
```
For dependency management, we use pipenv, so you need to install it:

```bash
pip install pipenv
```

Once installed, you can install all the app dependencies:

```bash
pipenv install --dev
```

## Running the application


### Database configuration

Before the application starts for the first time, the database
needs to be initialized.

First, run `postgres`:

```bash
docker-compose up postgres
```

Then run the [`db_prep.py`](crypto-linguist/db_prep.py) script:

```bash
pipenv shell

cd crypto-linguist

export POSTGRES_HOST=localhost
python db_prep.py
```

To check the content of the database, use `pgcli` (already
installed with pipenv):

```bash
pipenv run pgcli -h localhost -U your_username -d crypto_linguist -W
```

You can view the schema using the `\d` command:

```sql
\d conversations;
```

And select from this table:

```sql
select * from conversations;
```

### Running with Docker-Compose

The easiest way to run the application is with `docker-compose`:

Run with specific files: Use the -f flag with docker-compose to specify the file to use. For example:

```bash
docker-compose -f docker-compose.dev.yaml up
```
Or for production:

```bash
docker-compose -f docker-compose.prod.yaml up
```

### Running locally

If you want to run the application locally,
start only postres and grafana:

```bash
docker-compose up postgres grafana
```

If you previously started all applications with
`docker-compose up`, you need to stop the `app`:

```bash
docker-compose stop app
```

Now run the app on your host machine:

```bash
pipenv shell

cd crypto-linguist

export POSTGRES_HOST=localhost
python app.py
```

### Running with Docker (without compose)

Sometimes you might want to run the application in
Docker without Docker Compose, e.g., for debugging purposes.

First, prepare the environment by running Docker Compose
as in the previous section.

Next, build the image:

```bash
docker build -t crypto-linguist .
```

And run it:

```bash
docker run -it --rm \
    --network="crypto-linguist_default" \
    --env-file=".env" \
    -e OPENAI_API_KEY=${OPENAI_API_KEY} \
    -e DATA_PATH="data/data.csv" \
    -p 5000:5000 \
    crypto-linguist
```

## Using the Flask application

Modify dockerfile to run flask application as below:
Uncomment following lines
```
#EXPOSE 5000
#CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
```
And comment following lines related to streamlit app
```
EXPOSE 8501
CMD ["streamlit", "run", "app_ui.py"]
```
Now build the dockerfile as below
```docker-compose -f docker-compose.dev.yaml up --build```

When the application is running, we can start using it.

### CLI

We built an interactive CLI application using
[questionary](https://questionary.readthedocs.io/en/stable/).

To start it, run:

```bash
pipenv run python app_cli.py
```

You can also make it randomly select a question from
[our ground truth dataset](data/crypto-guru-ground-truth-data.csv):

```bash
pipenv run python cli.py --random
```

### Using `requests`

When the application is running, you can use
[requests](https://requests.readthedocs.io/en/latest/)
to send questions—use [test.py](test.py) for testing it:

```bash
pipenv run python test.py
```

It can also pick a random question from the ground truth dataset or you can write your own
and send it to the app.


## Code Structure

The code for the application is in the [`crypto-linguist`](crypto-linguist/) folder:

- [`app.py`](crypto-linguist/app.py) - the Flask API, the main entrypoint to the application
- [`app_ui.py`](crypto-linguist/app_ui.py) - the streamlit UI application
- [`rag.py`](crypto-linguist/rag.py) - the main RAG logic for retrieving the data and building the prompt
- [`ingest.py`](crypto-linguist/ingest.py) - loading the data into the knowledge base
- [`minsearch.py`](crypto-linguist/minsearch.py) - an in-memory search engine
- [`db.py`](crypto-linguist/db.py) - the logic for logging the requests and responses to postgres
- [`db_prep.py`](crypto-linguist/db_prep.py) - the script for initializing the database

We also have some code in the project root directory:

- [`test.py`](test.py) - select a random question for testing
- [`app_cli.py`](app_cli.py) - interactive CLI for the APP, can pick randomly from data as well.

### Interface

We use Flask for serving the application as an API.

Refer to the ["Using the Application" section](#using-the-application)
for examples on how to interact with the application.

### Ingestion

The ingestion script is in [`ingest.py`](crypto-linguist/ingest.py).

Since we use an in-memory database, `minsearch`, as our
knowledge base, we run the ingestion script at the startup
of the application.

It's executed inside [`rag.py`](crypto-linguist/rag.py)
when we import it.

## Experiments

For experiments, we use Jupyter notebooks.
They are in the [`intro`](intro/) folder.

To start Jupyter, run:

```bash
cd intro
pipenv run jupyter notebook
```

We have the following notebooks:

- [`rag-test.ipynb`](intro/rag-test.ipynb): The RAG flow with minsearch and elastic search.
- [`vector_search.ipynb`](intro/vector_search.ipynb): The RAG flow with vector search.
- [`evaluation-data-generation.ipynb`](intro/evaluation-data-generation.ipynb): Generating the ground truth dataset for retrieval evaluation.
- [`project-pipeline.ipynb`](intro/project-pipeline.ipynb): The complete RAG flow as expected in the project.md. Retrieval evaluation using parameter optimization and RAG evaluations using 'LLM As Judge'

### Retrieval evaluation

The basic approach - using `minsearch` without any boosting - gave the following metrics:

- Hit rate: 99.5%
- MRR: 92%

The improved version (with parameter tuned boosting):

- Hit rate: 99.5%
- MRR: 95.7%

The best boosting parameters:

```python
boost = {
    'term':0.39,
    'category':0.15,
    'descriptions':0.23
}
```

### RAG flow evaluation

We used the LLM-as-a-Judge metric to evaluate the quality
of our RAG flow.

For `gpt-4o-mini`, in a sample with 200 records, we had:

- 86% `RELEVANT`
- 5% `PARTLY_RELEVANT`
- 9% `NON_RELEVANT`

We also tested `gpt-4o`:

- 87% `RELEVANT`
- 6% `PARTLY_RELEVANT`
- 7% `NON_RELEVANT`

The difference is minimal, so we opted for `gpt-4o-mini`.

## Monitoring

We use Grafana for monitoring the application. 

It's accessible at [localhost:3000](http://localhost:3000):

- Login: "admin"
- Password: "admin"

### Dashboards

The monitoring dashboard contains several panels:

1. **Last 5 Conversations (Table):** Displays a table showing the five most recent conversations, including details such as the question, answer, relevance, and timestamp. This panel helps monitor recent interactions with users.
2. **+1/-1 (Pie Chart):** A pie chart that visualizes the feedback from users, showing the count of positive (thumbs up) and negative (thumbs down) feedback received. This panel helps track user satisfaction.
3. **Relevancy (Gauge):** A gauge chart representing the relevance of the responses provided during conversations. The chart categorizes relevance and indicates thresholds using different colors to highlight varying levels of response quality.
4. **OpenAI Cost (Time Series):** A time series line chart depicting the cost associated with OpenAI usage over time. This panel helps monitor and analyze the expenditure linked to the AI model's usage.
5. **Tokens (Time Series):** Another time series chart that tracks the number of tokens used in conversations over time. This helps to understand the usage patterns and the volume of data processed.
6. **Model Used (Bar Chart):** A bar chart displaying the count of conversations based on the different models used. This panel provides insights into which AI models are most frequently used.
7. **Response Time (Time Series):** A time series chart showing the response time of conversations over time. This panel is useful for identifying performance issues and ensuring the system's responsiveness.

### Setting up Grafana

All Grafana configurations are in the [`grafana`](grafana/) folder:

- [`init.py`](grafana/init.py) - for initializing the datasource and the dashboard.
- [`dashboard.json`](grafana/dashboard.json) - the actual dashboard (taken from LLM Zoomcamp without changes).

To initialize the dashboard, first ensure Grafana is
running (it starts automatically when you do `docker-compose -f docker-compose.prod.yaml up`).

Then run:

```bash
pipenv shell

cd grafana

# make sure the POSTGRES_HOST variable is not overwritten 
env | grep POSTGRES_HOST

python init.py
```

Then go to [localhost:3000](http://localhost:3000):

- Login: "admin"
- Password: "admin"

When prompted, keep "admin" as the new password.

## Background

Here we provide background on some tech not used in the
course and links for further reading.

### Flask

We use Flask for creating the API interface for our application.
It's a web application framework for Python: we can easily
create an endpoint for asking questions and use web clients
(like `curl` or `requests`) for communicating with it.

In our case, we can send questions to `http://localhost:5000/question`.

For more information, visit the [official Flask documentation](https://flask.palletsprojects.com/).


## Acknowledgements 

Thank you for exploring crypto-linguist. Hope you liked it. 