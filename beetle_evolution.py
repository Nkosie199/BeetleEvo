import json
import math

def simulate_beetle_populations(data):
    growth_rates = {
        'Red': 0.17,
        'Green': 0.26,
        'Blue': 0.11
    }

    capacity = data['capacity']
    rainfall = data['rainfall']
    current_phase = data['state']['phase']
    populations = data['state']['populations']
    results = []

    for i in range(len(rainfall)):
        if current_phase == "boom":
            for species, growth_rate in growth_rates.items():
                populations[species] = evolution(populations[species], growth_rate, True)
        elif current_phase == "bust":
            for species, growth_rate in growth_rates.items():
                populations[species] = evolution(populations[species], growth_rate, False)
        else:
            print('Error: no phase registered')

        total_population = sum(populations.values())
        if capacity < total_population:
            current_phase = "bust"
        elif rainfall[i]:
            current_phase = "boom"

        results.append({
            "phase": current_phase,
            "populations": populations.copy()
        })

    return results

def evolution(population, growth_rate, boom):
    if boom:
        return math.floor(population * (1 + growth_rate))
    else:
        return math.floor(population * (1 - growth_rate))


def main():
    with open('input.json', 'r') as file:
        input_data = json.load(file)
    output_data = simulate_beetle_populations(input_data)

    with open('output.json', 'w') as file:
        json.dump(output_data, file, indent=4)
    print(output_data)

if __name__ == "__main__":
    main()