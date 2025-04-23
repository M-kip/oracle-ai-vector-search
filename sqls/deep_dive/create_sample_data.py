import random

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
    row = f"({i}, '{info}', '[{', '.join(map(str, vector))}]')"
    rows.append(row)

# Create SQL insert statement
insert_sql = "INSERT INTO my_data VALUES\n" + ",\n".join(rows) + ";"

# Print or write to file
print(insert_sql)
