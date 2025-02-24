package gs.utils.tween
{
   public class FilterVars extends SubVars
   {
      public var index:int;
      
      public var addFilter:Boolean;
      
      public var remove:Boolean;
      
      public function FilterVars($remove:Boolean = false, $index:int = -1, $addFilter:Boolean = false)
      {
         super();
         this.remove = $remove;
         if($index > -1)
         {
            this.index = $index;
         }
         this.addFilter = $addFilter;
      }
   }
}

