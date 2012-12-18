package play
{
// Represents an edge on the "dual" graph - used for pathing.
public class GraphEdge
  {
  public var start:Number;
  public var end:Number;
  public var weight:Number;
  public function GraphEdge ()
    {
    start = -1;
    end = -1;
    weight = 100.0;
    }
  }

} // end package.