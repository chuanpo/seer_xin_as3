package gs.utils.tween
{
   public class ArrayTweenInfo
   {
      public var change:Number;
      
      public var start:Number;
      
      public var index:uint;
      
      public function ArrayTweenInfo($index:uint, $start:Number, $change:Number)
      {
         super();
         this.index = $index;
         this.start = $start;
         this.change = $change;
      }
   }
}

