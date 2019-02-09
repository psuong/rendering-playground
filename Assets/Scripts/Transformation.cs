using UnityEngine;

namespace Rendering {

    /// <summary>
    /// Representation of a transformation which for now really is scoped down to:
    /// Position
    /// Rotation
    /// Scale
    /// </summary>
    public abstract class Transformation : MonoBehaviour {

        public abstract Matrix4x4 Matrix { get; }
        public abstract Vector3 Apply(Vector3 pt);
        public Vector3 ApplyTransformation(Vector3 pt) => Matrix.MultiplyPoint(pt);
    }
}
