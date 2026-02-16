import bpy
import csv

# Function to export vertex groups and world-space coordinates of the selected object
def export_vertex_groups_and_world_coordinates(obj, filepath):
    if obj.type != 'MESH':
        print("Selected object is not a mesh!")
        return
    
    # Get the object's world matrix (to convert local coordinates to world coordinates)
    world_matrix = obj.matrix_world
    
    # Open the CSV file for writing
    with open(filepath, 'w', newline='') as csvfile:
        fieldnames = ['Vertex Index', 'World X', 'World Y', 'World Z', 'Vertex Group', 'Weight']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        # Write the header row
        writer.writeheader()

        # Iterate over the vertices
        for vert in obj.data.vertices:
            # Convert the local vertex coordinates to world space
            world_coordinates = world_matrix @ vert.co
            
            # Get the world space coordinates (X, Y, Z)
            world_x, world_y, world_z = world_coordinates.x, world_coordinates.y, world_coordinates.z
            
            # Iterate through each vertex group for the current vertex
            for group in vert.groups:
                # Get the name of the vertex group and the weight
                vertex_group = obj.vertex_groups[group.group]
                weight = group.weight

                # Write the data to the CSV
                writer.writerow({
                    'Vertex Index': vert.index,
                    'World X': round(world_x, 4),
                    'World Y': round(world_y, 4),
                    'World Z': round(world_z, 4),
                    'Vertex Group': vertex_group.name,
                    'Weight': round(weight, 4)
                })

    print(f"Vertex groups and world coordinates exported to {filepath}")

# Example usage:
# Get the active object in the scene (ensure it's a mesh)
obj = bpy.context.active_object
if obj:
#    export_vertex_groups_and_world_coordinates(obj, "V:/IntraoperativeRecordings/Data_Recordings/IP35/ReconLocations/FileOutputs/IP35exportClinicalElectrodes1.csv")
#    export_vertex_groups_and_world_coordinates(obj, "V:/IntraoperativeRecordings/Data_Recordings/IP35/ReconLocations/FileOutputs/IP35exportClinicalElectrodes2.csv")
    export_vertex_groups_and_world_coordinates(obj, "V:/IntraoperativeRecordings/Data_Recordings/IP35/ReconLocations/FileOutputs/IP35exportResearchElectrodes1.csv")
#    export_vertex_groups_and_world_coordinates(obj, "V:/IntraoperativeRecordings/Data_Recordings/IP35/ReconLocations/FileOutputs/IP35exportResearchElectrodes2.csv")    
#    export_vertex_groups_and_world_coordinates(obj, "V:/IntraoperativeRecordings/Data_Recordings/IP35/ReconLocations/FileOutputs/IP35exportResearchElectrodes3.csv") 
#    export_vertex_groups_and_world_coordinates(obj, "V:/IntraoperativeRecordings/Data_Recordings/IP35/ReconLocations/FileOutputs/IP35exportResearchElectrodes4.csv") 
else:
    print("No active object found.")
