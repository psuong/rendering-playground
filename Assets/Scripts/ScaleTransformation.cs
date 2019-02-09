using UnityEngine;

namespace Rendering {

    public class ScaleTransformation : Transformation {

        public Vector3 scale;

        public override Vector3 Apply(Vector3 pt) {
            pt.x *= scale.x;
            pt.y *= scale.y;
            pt.z *= scale.z;
            return pt;
        }
    }
}
