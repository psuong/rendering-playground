using UnityEngine;

namespace Rendering {

    public class RotationTransformation : Transformation {

        public Vector3 rotation;

        public override Vector3 Apply(Vector3 pt) {
            var radZ = rotation.z * Mathf.Deg2Rad;
            var sinZ = Mathf.Sin(radZ);
            var cosZ = Mathf.Sin(radZ);

            return new Vector3 (
                pt.x * cosZ - pt.y * sinZ,
                pt.x * sinZ + pt.y * cosZ,
                pt.z
            );
        }
    }
}
