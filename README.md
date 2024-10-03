# Crypto Linguist Chatbot
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
The dataset contains following columns.
- Terms: A curated collection of essential terms from the cryptocurrency and blockchain industry.
- Categories: The dataset is organized into ten categories to enhance clarity and user understanding.
- Descriptions: Each term is accompanied by a brief description that defines its meaning and context.

# Setting up OpenAI API KEY and Project Environment
Because it is a fresh codespace instance, update apt and then install direnv. 
Ensure YOUR_OPENAI_KEY is added (export KEY="!dfw#&") in .envrc file before running following commands.
    sudo apt update 
    sudo apt install direnv 
    direnv bash hook >> ~/.bashrc
    direnv allow

Now install pipenv and the required packages.
    pip install pipenv
    pipenv install --dev