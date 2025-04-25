INSERT INTO my_books
(file_name, file_size, file_type, file_content)
VALUES ("23ai_Release_notes.pdf",
bdms_lob.getlength(to_blob(bfilename())))