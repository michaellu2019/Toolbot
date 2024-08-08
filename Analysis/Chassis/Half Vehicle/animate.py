import csv
import pygame as py
import time

csv_path = "./data.csv"

# Function to read and parse the CSV file
def read_csv(csv_path):
    data = []
    with open(csv_path, "r") as csvfile:
        datareader = csv.reader(csvfile)
        next(datareader)  # Skip the header row
        for row in datareader:
            # Convert string data to appropriate types
            time_val = float(row[0])
            terrain_val = float(row[1])  # Assuming terrain is a string
            y_val = float(row[2])
            theta_val = float(row[3])
            data.append((time_val, terrain_val, y_val, theta_val))
    return data

# Read and parse the CSV data
parsed_data = read_csv(csv_path)
py.init()
game_size = [500, 500]
screen = py.display.set_mode(game_size)

tank_width = 100
tank_height = 20
tank_color = (0, 0, 255)
tank_surface = py.Surface((tank_width, tank_height))
tank_surface.set_colorkey((255, 255, 255))
tank_surface.fill(tank_color)

tank_surface_copy = tank_surface.copy()
tank_surface.set_colorkey((255, 255, 255))
tank_rect = tank_surface_copy.get_rect()
tank_rect.center = (game_size[0]//2, game_size[1]//2)

# Now parsed_data contains all the rows as tuples
last_time_val = 0
for row in parsed_data:
    time_val, terrain_val, y_val, theta_val = row
    dt = time_val - last_time_val
    last_time_val = time_val

    scaled_y_val = y_val * 10
    scaled_theta_val = theta_val * 10

    screen.fill((255, 255, 255))

    old_tank_rect_center = tank_rect.center  
    new_tank_surface = py.transform.rotate(tank_surface , scaled_theta_val)  
    new_tank_rect = new_tank_surface.get_rect()  
    # set the rotated rectangle to the old center  
    new_tank_rect.center = old_tank_rect_center  
    # drawing the rotated rectangle to the screen  
    screen.blit(new_tank_surface , new_tank_rect)

    py.display.flip()

    time.sleep(0.1)


py.quit()