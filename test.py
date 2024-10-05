import pandas as pd

import requests

df = pd.read_csv("./data/crypto-guru-ground-truth-data.csv")
question = df.sample(n=1).iloc[0]['question']

print("question: ", question)

url = "http://localhost:5000/question"


data = {"question": question}

response = requests.post(url, json=data)
# print(response.content)

print(response.json())