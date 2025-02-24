package org.taomee.component.control
{
   import flash.display.DisplayObject;
   import org.taomee.component.UIComponent;
   
   public class UIMovieClip extends UIComponent
   {
      public function UIMovieClip(mc:DisplayObject = null)
      {
         super();
         bgMC.mouseChildren = true;
         if(Boolean(mc))
         {
            append(mc);
         }
      }
      
      override public function get numChildren() : int
      {
         return bgMC.numChildren;
      }
      
      override public function get width() : Number
      {
         return bgMC.width;
      }
      
      override public function get height() : Number
      {
         return bgMC.height;
      }
      
      override public function getChildByName(name:String) : DisplayObject
      {
         return bgMC.getChildByName(name);
      }
      
      override public function getChildAt(index:int) : DisplayObject
      {
         return bgMC.getChildAt(index);
      }
      
      public function append(child:DisplayObject) : DisplayObject
      {
         bgMC.addChild(child);
         return child;
      }
      
      override public function getChildIndex(child:DisplayObject) : int
      {
         return bgMC.getChildIndex(child);
      }
      
      override public function set width(i:Number) : void
      {
         bgMC.width = i;
      }
      
      public function appendAt(child:DisplayObject, index:int) : DisplayObject
      {
         bgMC.addChildAt(child,index);
         return child;
      }
      
      override public function set height(i:Number) : void
      {
         bgMC.height = i;
      }
      
      override public function setChildIndex(child:DisplayObject, index:int) : void
      {
         return bgMC.setChildIndex(child,index);
      }
   }
}

