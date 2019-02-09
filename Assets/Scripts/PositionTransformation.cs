using UnityEngine;

namespace Rendering {

    public class PositionTransformation : Transformation {
        public Vector3 position;

        public override Vector3 Apply(Vector3 pt) => pt + position;
    }
}