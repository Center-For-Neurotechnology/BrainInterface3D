import pymeshlab
import numpy as np
import sys
import pandas as pd

def extract_geodesic_distances(pathname, point, indexvert, outputpath, outputpathVert):
    """
    psd: numpy array (n_channels x m_freqs)
    freqs: numpy array (m_freqs)
    ch_names: list of channel names
    output_path (str): '' if you dont want to export, modify it if you do want to
    """

    # Load the mesh
    ms = pymeshlab.MeshSet()
    ms.load_new_mesh(pathname)

    # Extract vertex data
    vertex_matrix = ms.current_mesh().vertex_matrix()
    face_matrix = ms.current_mesh().face_matrix()

    # Define start and end points (example coordinates)
    # point1 = [-43.93870163, -62.18130112,  14.81470013] 
    # point2 = [-10.03129959,  76.81809998,   8.20250988]
    # point3 = [-55.8896, 14.0071, 18.2098]
    # point4 = [1.45923, 1.26442, -0.564307]

    # point

    # Compute distances from point1 to all vertices
    ms.compute_scalar_by_geodesic_distance_from_given_point_per_vertex(startpoint=point)

    # measures = ms.apply_filter('get_geometric_measures')

    MeshDistances=ms.mesh(0).vertex_scalar_array()

    if outputpath:
        # MeshDistances.to_csv(outputpath)
        df = pd.DataFrame(MeshDistances)
        df.to_csv(outputpath)

    if outputpathVert:
        # MeshDistances.to_csv(outputpath)
        df2 = pd.DataFrame(vertex_matrix)
        df2.to_csv(outputpathVert)

    return MeshDistances

if __name__ == '__main__':
    pathname = sys.argv[1]
    #indexvert = 1
    point = [float(sys.argv[2]), float(sys.argv[3]), float(sys.argv[4])]
    indexvert = sys.argv[5]
    string_number = str(indexvert)
    outputpath = pathname.replace('.ply', string_number + '.csv')
    outputpathVert = pathname.replace('.ply', string_number + 'Vertices.csv')
    extract_geodesic_distances(pathname, point, indexvert, outputpath, outputpathVert)

    

