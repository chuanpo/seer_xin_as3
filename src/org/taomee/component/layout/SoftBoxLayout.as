package org.taomee.component.layout
{
   import org.taomee.component.UIComponent;
   
   public class SoftBoxLayout extends EmptyLayout implements ILayoutManager
   {
      private static const TYPE:String = "softBoxLayout";
      
      public static const CENTER:uint = 0;
      
      public static const LEFT:uint = 1;
      
      public static const TOP:uint = 1;
      
      public static const RIGHT:uint = 2;
      
      public static const BOTTOM:uint = 2;
      
      public static const X_AXIS:uint = 0;
      
      public static const Y_AXIS:uint = 1;
      
      private var _axis:uint;
      
      private var _align:uint;
      
      private var _gap:int;
      
      public function SoftBoxLayout(axis:int = 0, gap:int = 5, align:int = 0)
      {
         super();
         this._axis = axis;
         this._gap = gap;
         this._align = align;
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
      
      public function get align() : uint
      {
         return _align;
      }
      
      public function set align(i:uint) : void
      {
         if(i == _align)
         {
            return;
         }
         _align = i;
         broadcast();
      }
      
      private function layoutX() : void
      {
         var margin:Number = NaN;
         var comp:UIComponent = null;
         var c:UIComponent = null;
         var oldComp:UIComponent = null;
         var totalWidth:Number = 0;
         var num:int = int(container.compList.length);
         var i:uint = 0;
         for each(comp in container.compList)
         {
            comp.y = 0;
            comp.x = 0;
            totalWidth += comp.width;
            comp.height = container.height;
            i++;
         }
         if(num > 0)
         {
            totalWidth += (num - 1) * gap;
         }
         switch(align)
         {
            case RIGHT:
               margin = container.width - totalWidth;
               break;
            case CENTER:
               margin = (container.width - totalWidth) / 2;
               break;
            default:
               margin = 0;
         }
         var j:uint = 0;
         for each(c in container.compList)
         {
            if(j == 0)
            {
               c.x = margin;
            }
            else
            {
               oldComp = container.compList[j - 1];
               c.x = oldComp.x + oldComp.width + gap;
            }
            j++;
         }
      }
      
      private function layoutY() : void
      {
         var margin:Number = NaN;
         var comp:UIComponent = null;
         var c:UIComponent = null;
         var oldComp:UIComponent = null;
         var totalHeight:Number = 0;
         var num:int = int(container.compList.length);
         var i:uint = 0;
         for each(comp in container.compList)
         {
            comp.y = 0;
            comp.x = 0;
            totalHeight += comp.height;
            comp.width = container.width;
            i++;
         }
         if(num > 0)
         {
            totalHeight += (num - 1) * gap;
         }
         switch(align)
         {
            case RIGHT:
               margin = container.height - totalHeight;
               break;
            case CENTER:
               margin = (container.height - totalHeight) / 2;
               break;
            default:
               margin = 0;
         }
         var j:uint = 0;
         for each(c in container.compList)
         {
            if(j == 0)
            {
               c.y = margin;
            }
            else
            {
               oldComp = container.compList[j - 1];
               c.y = oldComp.y + oldComp.height + gap;
            }
            j++;
         }
      }
      
      override public function getType() : String
      {
         return TYPE + axis.toString() + gap.toString() + align.toString();
      }
      
      public function get gap() : int
      {
         return _gap;
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
      
      override public function doLayout() : void
      {
         if(axis == X_AXIS)
         {
            layoutX();
         }
         else
         {
            layoutY();
         }
      }
   }
}

