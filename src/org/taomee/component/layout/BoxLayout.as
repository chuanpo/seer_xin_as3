package org.taomee.component.layout
{
   import org.taomee.component.UIComponent;
   
   public class BoxLayout extends EmptyLayout implements ILayoutManager
   {
      private static var TYPE:String = "boxLayout";
      
      public static const X_AXIS:uint = 0;
      
      public static const Y_AXIS:uint = 1;
      
      private var _axis:uint;
      
      private var _gap:int;
      
      public function BoxLayout(axis:int = 0, gap:int = 5)
      {
         super();
         this._axis = axis;
         this._gap = gap;
      }
      
      public function get axis() : uint
      {
         return _axis;
      }
      
      public function set axis(i:uint) : void
      {
         if(_axis == i)
         {
            return;
         }
         _axis = i;
         broadcast();
      }
      
      public function set gap(i:int) : void
      {
         if(_gap == i)
         {
            return;
         }
         _gap = i;
         broadcast();
      }
      
      private function layoutY() : void
      {
         var comp:UIComponent = null;
         var num:uint = container.compList.length;
         var perH:Number = (container.height - (num - 1) * _gap) / num;
         var i:uint = 0;
         for each(comp in container.compList)
         {
            if(i == 0)
            {
               comp.y = perH * i;
            }
            else
            {
               comp.y = perH * i + _gap;
            }
            comp.x = 0;
            comp.height = perH;
            comp.width = container.width;
            i++;
         }
      }
      
      override public function getType() : String
      {
         return TYPE + _axis.toString() + _gap.toString();
      }
      
      override public function doLayout() : void
      {
         if(_axis == Y_AXIS)
         {
            layoutY();
         }
         else
         {
            layoutX();
         }
      }
      
      public function get gap() : int
      {
         return _gap;
      }
      
      private function layoutX() : void
      {
         var comp:UIComponent = null;
         var num:uint = container.compList.length;
         var perW:Number = (container.width - (num - 1) * _gap) / num;
         var i:uint = 0;
         for each(comp in container.compList)
         {
            if(i == 0)
            {
               comp.x = perW * i;
            }
            else
            {
               comp.x = perW * i + _gap;
            }
            comp.y = 0;
            comp.width = perW;
            comp.height = container.height;
            i++;
         }
      }
   }
}

