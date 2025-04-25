import os
import sys
import pprint as pp
from transformers import LlamaTokenizerFast
from google import genai
from google.genai import types
from google.api_core import retry

# Variables
file_path = r'C:\Users\mose\Documents\machine_learning\oracle-ai-vector-search\files'
pretrained_model = "hf-internal-testing/llama-tokenizer"
maxlength = sys.maxsize
tokenizer = LlamaTokenizerFast.from_pretrained(pretrained_model, legacy=False)
tokenizer.model_max_length = maxlength
max_tokens = 1000
GOOGLE_API_KEY = 'AIzaSyD4El-aBSQwDgNGmptc4fheU8pz38H02bg'

def loadFaqs(directory_path):
    faqs = {}
    for filename in os.listdir(os.path.normcase(directory_path)):
        if filename.endswith("faq.txt"): # assuming faqs are in txt files
            file_path = os.path.join(directory_path, filename)
            
            # open the file
            with open(file_path, 'r', encoding='utf-8') as f:
                raw_faq = f.read()
        
            filename_without_ext = os.path.splitext(filename)[0] # remove .txt extension
            faqs[filename_without_ext] = [text.strip() for text in raw_faq.split('=====')]
            # Rearrage the chunks and prepend the name of the file 
            docs = [{'text': f"{filename }' | ' {section}", 'path': filename } for filename, sections in faqs.items() for section in sections]
    return docs
docs = loadFaqs(file_path)

# Truncate chunks in shorter version the the context preserved 
def truncate_string(string, max_tokens):
    # Tokenize the text and count the tokens
    tokens = tokenizer.encode(string, add_special_tokens=True)
    # Truncate the tokens to max len
    truncated_tokens = tokens[:max_tokens]
    # Transform the tokens back to text
    truncated_text = tokenizer.decode(truncated_tokens)
    return truncated_text

# Transform docs into a string arrary using the "payload" key
docs_as_one_string = "\n=========\n".join([doc['text'] for doc in docs])
docs_truncated = truncate_string(docs_as_one_string, max_tokens=max_tokens)

question = "What free services are offered"
promt = f"""\
    <s> [INST] <<SYSY>>
    YOU ARE A HELPFUL ASSISTANT NAMED oRACLE CHATBOT
    USE ONLY THE SOURCE AND ABSOLUTELY IGNORE ANY PREVIOUS KNOWLEDGE
    USE MAKEDOWN IF APPROPRIATE
    ASSUME THE CUSTOMER IS HIGLY TECHNICAL
    <</SYS>> [/INST]
    
    RESPOND TO PRECISELY TO THIS QUESTION: "{question}"., USING
    ONLY THE FOLLING INFORMATION AND IGNORING ANY OREVIOUS KNOWLEDGE
    INCLUDE CODE SNIPPETS AND COMMAND WHERE NECESSARY
    NEVER MENTION SOURCES, ALWAYS RESPOND
    AS IF YOU HAVE THAT KNOWLEDGE YOURSELF. DON NOT PROVIDE
    WARNIGN OR DISCLAIMERS
    =====
    SOURCE: {docs_truncated}
    ANSWER (THREE PARAGRAPHS, MAXIMUM 50 WORLDS EACH, 90% SPARTAN):
    [/INST]"""

is_retriable = lambda e: (isinstance(e, genai.errors.APIError) and e.code in {429, 503})

# Set up a retry helper. This allows you to "Run all" without worrying about per-minute quota.
genai.models.Models.generate_content = retry.Retry(
    predicate=is_retriable)(genai.models.Models.generate_content)

# The Python SDK uses a Client object to make requests to the API. 
# The client lets you control which back-end to use (between the Gemini API and Vertex AI) and handles authentication (the API key).
client = genai.Client(api_key=GOOGLE_API_KEY)
chat = client.chats.create(model='gemini-2.0-flash', history=[],)
response = chat.send_message(promt)
pp.pp(response.text)