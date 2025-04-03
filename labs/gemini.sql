select dbms_vector_chain.utl_to_generate_text(
    'What is Oracle?',
    json('{
"provider": "googleai",
"credential_name": "GEMINI_AI",
"url": "https://generativelanguage.googleapis.com/v1beta/models/",
"model": "gemini-2.0-flash"
}')) from dual;
