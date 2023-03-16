#ifdef USE_SKINNING
      mat4 skin_matrix = mat4(0.0);
      skin_matrix += VertexWeights.x * joints_matrices[int(float(VertexJoints.x)*0xFFFF)];
      skin_matrix += VertexWeights.y * joints_matrices[int(float(VertexJoints.y)*0xFFFF)];
      skin_matrix += VertexWeights.z * joints_matrices[int(float(VertexJoints.z)*0xFFFF)];
      skin_matrix += VertexWeights.w * joints_matrices[int(float(VertexJoints.w)*0xFFFF)];

      vert_position = skin_matrix * vert_position;
#endif