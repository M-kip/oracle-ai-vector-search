declare
    v_messages clob;
    v_params_genai clob;
    v_output clob;
begin
    v_messages := '
    {"message":"If intelligent people are constantly shopping around for good value, selling those stocks they think 
will turn out to be overvalued and buying those they expect are now undervalued, the result of this 
action by intelligent investors will be to have existing stock prices already have discounted in them 
an allowance for their future prospects. Hence, to the passive investor, who does not himself search 
for under-and overvalued situations, there will be presented a pattern of stock prices that makes one 
stock about as good or bad a buy as another. To that passive investor, chance alone would be as good 
a method of selection as anything else.."},
    {"Question":"What does the book say passive investing vs. active investing?"}
    ';

    v_params_genai := '
    {
        "provider":"googleai",
        "credential_name": "GEMINI_AI",
        "url":"https://generativelanguage.googleapis.com/v1beta/models/",
        "model":"gemini-2.0-flash"
    }';
    
    v_output := dbms_vector_chain.utl_to_generate_text(v_messages, json(v_params_genai));
    
    dbms_output.put_line(v_output);
end;