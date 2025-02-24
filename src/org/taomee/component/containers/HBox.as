package org.taomee.component.containers
{
   public class HBox extends Box
   {
      public function HBox(gap:int = 5)
      {
         super(gap);
         direction = BoxDirection.HORIZONTAL;
      }
   }
}

