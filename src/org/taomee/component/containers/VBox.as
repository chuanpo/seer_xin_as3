package org.taomee.component.containers
{
   public class VBox extends Box
   {
      public function VBox(gap:int = 5)
      {
         super(gap);
         direction = BoxDirection.VERTICAL;
      }
   }
}

