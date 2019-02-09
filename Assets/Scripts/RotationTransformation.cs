using UnityEngine;

namespace Rendering {

    public class RotationTransformation : Transformation {

        public Vector3 rotation;

        public override Vector3 Apply(Vector3 pt) {
            var radX = rotation.x * Mathf.Deg2Rad;
            var radY = rotation.y * Mathf.Deg2Rad;
            var radZ = rotation.z * Mathf.Deg2Rad;
            var sinX = Mathf.Sin(radX);
            var cosX = Mathf.Cos(radX);
            var sinY = Mathf.Sin(radY);
            var cosY = Mathf.Cos(radY);
            var sinZ = Mathf.Sin(radZ);
            var cosZ = Mathf.Cos(radZ);

            var xAxis = new Vector3(
                cosY * cosZ,
                cosX * sinZ + sinX * sinY * cosZ,
                sinX * sinZ - cosX * sinY * cosZ
            );
            var yAxis = new Vector3(
                -cosY * sinZ,
                cosX * cosZ - sinX * sinY * sinZ,
                sinX * cosZ + cosX * sinY * sinZ
            );
            var zAxis = new Vector3(
                sinY,
                -sinX * cosY,
                cosX * cosY
            );
            return xAxis * pt.x + yAxis * pt.y + zAxis * pt.z;
        }
    }
}
