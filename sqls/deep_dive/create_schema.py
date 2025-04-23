import random
import os
import time
import array
import sys
import getpass

import oracledb

un = "c##moses"
cs = "localhost/free"
pw = "mbuyuni_2025" #getpass.getpass(f'Enter password for {un}@{cs}: ')

# Sample African cities and cultural themes
cities = [
    "Lagos", "Cairo", "Nairobi", "Johannesburg", "Accra", "Addis Ababa", "Kampala", "Algiers", "Khartoum",
    "Dakar", "Luanda", "Casablanca", "Abuja", "Kinshasa", "Tunis", "Harare", "Mogadishu", "Conakry",
    "Bamako", "Freetown", "Libreville", "Lusaka", "Tripoli", "Gaborone", "Port Harcourt", "Monrovia",
    "Nouakchott", "Kigali", "Niamey", "Ouagadougou", "Windhoek", "Asmara", "Banjul", "Lome", "Yaounde",
    "Maputo", "Mombasa", "Zanzibar", "Durban", "Ibadan", "Benin City", "Soweto", "Maroua", "Blantyre"
]

cultures = [
    "Yoruba cuisine", "Zulu dance", "Berber language", "Hausa traditions", "Swahili music",
    "Maasai festivals", "Fulani herding", "Igbo markets", "traditional storytelling",
    "pan-African fashion", "ancestral rituals", "drumming circles", "tribal tattoos",
    "desert caravans", "coastal fishing", "nomadic lifestyle", "village elders", "spice markets"
]

# Generate 100 rows of data
rows = []
for i in range(1, 101):
    city = random.choice(cities)
    culture = random.choice(cultures)
    info = f"{city} - {culture}"
    vector = [round(random.uniform(0, 1), 2) for _ in range(3)]
    #row = [i, info, f"[{', '.join(map(str, vector))}]"] # radom vector values for testing
    row = [i, info, None]
    rows.append(row)

# Create SQL create statement for my_data table
create_sql = ["DROP TABLE IF EXISTS my_data PURGE", "CREATE TABLE IF NOT EXISTS my_data (id number primary key, info varchar2(128), v vector)"]
# Create SQL insert statement
insert_sql = "INSERT INTO my_data VALUES (:1, :2, :3)"

# connect to oracle 23ai
print("connecting to the database...............................\n")
with oracledb.connect(user=un, password=pw, dsn=cs) as connection:

    db_version = tuple(int(s) for s in connection.version.split("."))[:2]
    if db_version < (23, 4):
        sys.exit("This example only works for oracle db 23.4 or later")
    print("connected to the database...............................") 

    with connection.cursor() as cursor:
        connection.autocommit = True
        print("Creating database table.........")
        for s in create_sql:
            try:
                cursor.execute(s)
                print("Creating database table sucessful.........")
            except oracledb.DatabaseError as e:
                sys.exit(e)

        # Insert data into the table
        for observation in rows:
            try:
                print(f"adding \t{observation[0]}-->{observation}")
                cursor.execute(insert_sql, observation)
                print(f"added \t{observation[0]}-->{observation}")
            except oracledb.DatabaseError as e:
                sys.exit(e)

print("\nSchema create and sample data loaded")
print("-----------------------------------\n")