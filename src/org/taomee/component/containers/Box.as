package org.taomee.component.containers
{
   import org.taomee.component.Container;
   import org.taomee.component.layout.FlowLayout;
   
   public class Box extends Container
   {
      private var _dir:String;
      
      private var _valign:int;
      
      private var _halign:int;
      
      public function Box(gap:int = 5)
      {
         super();
         layout = new FlowLayout(FlowLayout.X_AXIS);
         this.gap = gap;
      }
      
      private function updateLayout() : void
      {
         if(_dir == BoxDirection.HORIZONTAL)
         {
            (layout as FlowLayout).axis = FlowLayout.X_AXIS;
         }
         else
         {
            (layout as FlowLayout).axis = FlowLayout.Y_AXIS;
         }
      }
      
      public function set valign(i:uint) : void
      {
         _valign = i;
         (layout as FlowLayout).valign = i;
      }
      
      public function set gap(i:uint) : void
      {
         (layout as FlowLayout).gap = i;
      }
      
      public function get gap() : uint
      {
         return (layout as FlowLayout).gap;
      }
      
      public function set halign(i:uint) : void
      {
         _halign = i;
         (layout as FlowLayout).halign = i;
      }
      
      public function set direction(i:String) : void
      {
         if(i == _dir)
         {
            return;
         }
         _dir = i;
         updateLayout();
      }
      
      public function get direction() : String
      {
         return _dir;
      }
   }
}

