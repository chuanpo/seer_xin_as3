package org.taomee.component.layout
{
   import org.taomee.component.UIComponent;
   
   public class FlowWarpLayout extends EmptyLayout implements ILayoutManager
   {
      private static const TYPE:String = "flowWarpLayout";
      
      public static const CENTER:int = 0;
      
      public static const LEFT:int = 1;
      
      public static const RIGHT:int = 2;
      
      public static const TOP:uint = 1;
      
      public static const MIDLLE:uint = 0;
      
      public static const BOTTOM:uint = 2;
      
      private var initialHeight:Number;
      
      private var _hgap:int;
      
      private var initialWidth:Number;
      
      private var _valign:uint;
      
      private var _halign:uint;
      
      private var _vgap:int;
      
      public function FlowWarpLayout(halign:uint = 1, valign:uint = 0, hgap:int = 5, vgap:int = 5)
      {
         super();
         this._halign = halign;
         this._valign = valign;
         this._hgap = hgap;
         this._vgap = vgap;
      }
      
      public function set vgap(i:int) : void
      {
         if(i == _vgap)
         {
            return;
         }
         _vgap = i;
         broadcast();
      }
      
      public function get valign() : uint
      {
         return _valign;
      }
      
      override public function doLayout() : void
      {
         var comp:UIComponent = null;
         initialWidth = initialHeight = 0;
         var begin:int = 0;
         var maxHeight:Number = 0;
         var num:Number = compSprite.numChildren;
         var i:uint = 0;
         for each(comp in container.compList)
         {
            if(initialWidth + comp.width + hgap * (i - begin) > container.width)
            {
               moveComponent(begin,i - 1,initialWidth,maxHeight);
               begin = int(i);
               initialWidth = comp.width;
               maxHeight = comp.height;
               if(i == num - 1)
               {
                  moveComponent(begin,num - 1,initialWidth,maxHeight);
               }
            }
            else
            {
               initialWidth += comp.width;
               maxHeight = Math.max(maxHeight,comp.height);
               if(i == num - 1)
               {
                  moveComponent(begin,num - 1,initialWidth,maxHeight);
               }
            }
            i++;
         }
      }
      
      public function get halign() : uint
      {
         return _halign;
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
      
      public function get vgap() : int
      {
         return _vgap;
      }
      
      public function set hgap(i:int) : void
      {
         if(i == _hgap)
         {
            return;
         }
         _hgap = i;
         broadcast();
      }
      
      private function moveComponent(begin:int, end:int, totalWidth:Number, maxHeight:Number) : void
      {
         var X:Number = NaN;
         var comp:UIComponent = null;
         var prev_comp:UIComponent = null;
         switch(halign)
         {
            case RIGHT:
               X = container.width - totalWidth - hgap * (end - begin);
               break;
            case CENTER:
               X = (container.width - totalWidth - hgap * (end - begin)) / 2;
               break;
            default:
               X = 0;
         }
         for(var i:int = begin; i < end + 1; i++)
         {
            comp = container.compList[i] as UIComponent;
            if(i == begin)
            {
               comp.x = X;
            }
            else
            {
               prev_comp = container.compList[i - 1] as UIComponent;
               comp.x = prev_comp.x + prev_comp.width + hgap;
            }
            switch(valign)
            {
               case MIDLLE:
                  comp.y = (maxHeight - comp.height) / 2 + initialHeight;
                  break;
               case BOTTOM:
                  comp.y = maxHeight - comp.height + initialHeight;
                  break;
               default:
                  comp.y = initialHeight;
                  break;
            }
         }
         initialHeight += maxHeight + vgap;
      }
      
      public function get hgap() : int
      {
         return _hgap;
      }
      
      override public function getType() : String
      {
         return TYPE + halign.toString() + valign.toString() + hgap.toString() + vgap.toString();
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
   }
}

