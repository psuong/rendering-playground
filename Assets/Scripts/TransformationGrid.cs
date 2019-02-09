using System.Collections.Generic;
using UnityEngine;

namespace Rendering {

    /// <summary>
    /// The transformation grid is by no means an actual shader, but it allows us to understand how vertices really
    /// work in an easy to understand format.
    /// </summary>
    public class TransformationGrid : MonoBehaviour {

        public Transform prefab;
        public int gridResolution = 10;

        private Transform[] grid;
        private List<Transformation> transformations;
        private Matrix4x4 transformation;

        private void Awake() {
            grid = new Transform[gridResolution * gridResolution * gridResolution];
            transformations = new List<Transformation>();

            for (int z = 0, i = 0; z < gridResolution; z++) {
                for (int y = 0; y < gridResolution; y++) {
                    for (int x = 0; x < gridResolution; x++, i++) {
                        grid[i] = CreateGridPoints(x, y, z);
                    }
                }
            }
        }

        private void Update() {
            UpdateTransformations();
            for (int i = 0, z = 0; z < gridResolution; z++) {
                for (int y = 0; y < gridResolution; y++) {
                    for (int x = 0; x < gridResolution; x++, i++) {
                        grid[i].localPosition = TransformPoint(x, y, z);
                    }
                }
            }
        }

        private void UpdateTransformations() {
            GetComponents<Transformation>(transformations);
            if (transformations.Count > 0) {
                transformation = transformations[0].Matrix;
                for (int i = 1; i < transformations.Count; i++) {
                    transformation = transformations[i].Matrix * transformation;
                }
            }
        }

        private Transform CreateGridPoints(int x, int y, int z) {
            var point = Instantiate<Transform>(prefab);
            point.localPosition = GetCoordinate(x, y, z);
            point.GetComponent<MeshRenderer>().material.color = new Color(
                (float) x / gridResolution,
                (float) y / gridResolution,
                (float) z / gridResolution
            );
            return point;
        }

        private Vector3 GetCoordinate(int x, int y, int z) {
            return new Vector3 (
                x - (gridResolution - 1) * 0.5f,
                y - (gridResolution - 1) * 0.5f,
                z - (gridResolution - 1) * 0.5f
            );
        }

        private Vector3 TransformPoint(int x, int y, int z) {
            var coordinate = GetCoordinate(x, y, z);
            // Usually I would use MultiplyPoint3x4, but there are bottom row manipulations
            return transformation.MultiplyPoint(coordinate);
        }
    }
}
