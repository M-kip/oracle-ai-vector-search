-- Generates text for a prompt (input string) 
select dbms_vector_chain.utl_to_generate_text(
    'What is Oracle?',
    json('{"provider": "openai", 
           "credential_name": "OPENAI", 
           "url": "https://api.openai.com/v1/chat/completions", 
           "model": "gpt-4o"}'));
           
-- Extracts a summary from documents
select dbms_vector_chain.utl_to_summary(
    'What is Oracle?',
    json('{"provider": "openai", 
           "credential_name": "OPENAI", 
           "url": "https://api.openai.com/v1/chat/completions", 
           "model": "gpt-4o"}'));
