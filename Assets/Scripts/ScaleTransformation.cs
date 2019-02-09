using UnityEngine;

namespace Rendering {

    public class ScaleTransformation : Transformation {

        public Vector3 scale;

        public override Matrix4x4 Matrix {
			get {
                var matrix = new Matrix4x4();
                matrix.SetRow(0, new Vector4(scale.x, 0f, 0f, 0f));
                matrix.SetRow(1, new Vector4(0f, scale.y, 0f, 0f));
                matrix.SetRow(2, new Vector4(0f, 0f, scale.z, 0f));
                matrix.SetRow(3, new Vector4(0f, 0f, 0f, 1f));
                return matrix;
            }
        }

        public override Vector3 Apply(Vector3 pt) {
            pt.x *= scale.x;
            pt.y *= scale.y;
            pt.z *= scale.z;
            return pt;
        }
    }
}
