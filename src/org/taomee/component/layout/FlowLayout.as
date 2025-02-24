package org.taomee.component.layout
{
   import org.taomee.component.UIComponent;
   
   public class FlowLayout extends EmptyLayout implements ILayoutManager
   {
      private static const TYPE:String = "flowLayout";
      
      public static const CENTER:int = 0;
      
      public static const LEFT:int = 1;
      
      public static const RIGHT:int = 2;
      
      public static const TOP:uint = 1;
      
      public static const MIDLLE:uint = 0;
      
      public static const BOTTOM:uint = 2;
      
      public static const X_AXIS:uint = 0;
      
      public static const Y_AXIS:uint = 1;
      
      private var _axis:uint;
      
      private var _halign:uint;
      
      private var _valign:uint;
      
      private var _gap:int;
      
      public function FlowLayout(axis:uint = 1, halign:uint = 1, valign:uint = 1, gap:int = 5)
      {
         super();
         this._axis = axis;
         this._gap = gap;
         this._halign = halign;
         this._valign = valign;
      }
      
      public function get axis() : uint
      {
         return _axis;
      }
      
      public function set axis(i:uint) : void
      {
         if(i == _axis)
         {
            return;
         }
         _axis = i;
         broadcast();
      }
      
      public function get gap() : int
      {
         return _gap;
      }
      
      public function get halign() : uint
      {
         return _halign;
      }
      
      private function layoutY() : void
      {
         var oldComp:UIComponent = null;
         var i:UIComponent = null;
         var y_margin:Number = NaN;
         var totalH:Number = 0;
         var num:uint = container.compList.length;
         for each(i in container.compList)
         {
            i.x = i.y = 0;
            totalH += i.height;
            if(Boolean(oldComp))
            {
               i.y = oldComp.y + oldComp.height + gap;
            }
            oldComp = i;
         }
         totalH += gap * (num - 1);
         switch(valign)
         {
            case BOTTOM:
               y_margin = container.height - totalH;
               break;
            case MIDLLE:
               y_margin = (container.height - totalH) / 2;
               break;
            default:
               y_margin = 0;
         }
         for each(i in container.compList)
         {
            i.y += y_margin;
            switch(halign)
            {
               case RIGHT:
                  i.x = container.width - i.width;
                  break;
               case CENTER:
                  i.x = (container.width - i.width) / 2;
                  break;
            }
         }
      }
      
      override public function getType() : String
      {
         return TYPE + axis.toString() + gap.toString();
      }
      
      override public function doLayout() : void
      {
         if(axis == Y_AXIS)
         {
            layoutY();
         }
         else
         {
            layoutX();
         }
      }
      
      public function get valign() : uint
      {
         return _valign;
      }
      
      public function set halign(i:uint) : void
      {
         if(i == _halign)
         {
            return;
         }
         _halign = i;
         broadcast();
      }
      
      public function set gap(i:int) : void
      {
         if(i == _gap)
         {
            return;
         }
         _gap = i;
         broadcast();
      }
      
      private function layoutX() : void
      {
         var oldComp:UIComponent = null;
         var i:UIComponent = null;
         var x_margin:Number = NaN;
         var totalW:Number = 0;
         var num:uint = container.compList.length;
         for each(i in container.compList)
         {
            i.x = i.y = 0;
            totalW += i.width;
            if(Boolean(oldComp))
            {
               i.x = oldComp.x + oldComp.width + gap;
            }
            oldComp = i;
         }
         totalW += gap * (num - 1);
         switch(halign)
         {
            case RIGHT:
               x_margin = container.width - totalW;
               break;
            case CENTER:
               x_margin = (container.width - totalW) / 2;
               break;
            default:
               x_margin = 0;
         }
         for each(i in container.compList)
         {
            i.x += x_margin;
            switch(valign)
            {
               case BOTTOM:
                  i.y = container.height - i.height;
                  break;
               case MIDLLE:
                  i.y = (container.height - i.height) / 2;
                  break;
            }
         }
      }
      
      public function set valign(i:uint) : void
      {
         if(i == _valign)
         {
            return;
         }
         _valign = i;
         broadcast();
      }
   }
}

